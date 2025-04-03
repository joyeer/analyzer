//
//  ExceptionTable.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/8/17.
//

import Foundation

public class ExceptionTable : Equatable {
    public let from:Int
    var to: Int
    public fileprivate(set) var target: Int
    public fileprivate(set) var types = [Int]()
    
    init(from:Int, to: Int, target: Int, type: Int) {
        self.from = from
        self.to = to
        self.target = target
        self.types.append(type)
    }
    
    func isSameTryBlock(from:Int, to:Int) -> Bool {
        return self.from == from && self.to == to
    }
    
    
    func contains(type: Int) -> Bool {
        for t in types {
            if type == t {
                return true
            }
        }
        return false
    }
    
    func equals(types: [Int]) -> Bool {
        if types.count == self.types.count {
            for type in types {
                var flag = false
                for selfType in self.types {
                    if selfType == type {
                        flag = true
                        break
                    }
                }
                if flag == false {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func isTypeAny() -> Bool {
        
        for type in types {
            if type != 0 {
                return false
            }
        }
        return true
    }
}

public func == (left:ExceptionTable, right:ExceptionTable) -> Bool {
    if left.types.count != right.types.count {
        return false
    }
    
    for (index, type) in left.types.enumerated() {
        if right.types[index] != type {
            return false
        }
    }
    
    return left.from == right.from && left.to == right.to && left.target == right.target
}

class ExceptionTableLookup {
    private(set) var exceptions = [ExceptionTable]()
    private(set) var monitors = [ExceptionTable]()
    
    var count: Int {
        return exceptions.count
    }
    
    func insert(rawException: CodeAttributeInfo.ExceptionTable, method: Method) {
        let from = rawException.start_pc
        let to = rawException.end_pc
        let target = rawException.handler_pc
        
        // Merge the insert exception
        if let previous = exceptions.last {
            if previous.contains(type: rawException.catch_type ) {
                if previous.target == target {
                    if method.code!.getOpcodeIndexForJumpIndex(offset: previous.to)! + 1 == method.code!.getOpcodeIndexForJumpIndex(offset: from) {
                        previous.to = to
                        return
                    }
                }
            }
        }
        
        // Merge the monitors exception
        if let previous = monitors.last {
            if previous.contains(type: rawException.catch_type) && previous.isTypeAny() {
                if previous.target == target {
                    previous.to = to
                    return
                }
            }
        }
        
        let table = ExceptionTable(from: from, to: to, target: target, type: rawException.catch_type)
        if isMonitorOpcodeTryCatchBlock(method: method, table: table) {
            monitors.append(table)
        } else {
            
            if let targetTable = self.get(from: table.from, to: table.to, target: table.target) {
                // Exception table:
                //  from    to  target type
                //  2    43    46   Class java/lang/ClassNotFoundException
                //  2    43    46   Class java/lang/NoClassDefFoundError
                //  2    43    64   Class java/lang/IllegalAccessException
                //  2    43    64   Class java/security/AccessControlException
                
                targetTable.types.append(table.types.last!)
            } else {
                if(table.from >= table.target) {
                    return
                }
                exceptions.append(table)
            }
        }
    }
    
    func peek(_ index:Int) -> ExceptionTable? {
        if index >= exceptions.count {
            return nil
        }
        return exceptions[exceptions.index(exceptions.startIndex, offsetBy: index)]
    }
    
    func get(from:Int, to:Int) -> ExceptionTable? {
        for exception in exceptions {
            if exception.isSameTryBlock(from: from, to: to) {
                return exception
            }
        }
        return nil
    }
    
    func get(from: Int, to:Int, target:Int) -> ExceptionTable? {
        for exception in exceptions {
            if exception.from == from && exception.to == to && exception.target == target {
                return exception
            }
        }
        
        return nil
    }
    
    func get(target: Int, types:[Int]) -> [ExceptionTable] {
        var result = [ExceptionTable]()
        for exception in exceptions {
            if exception.target == target && exception.equals(types: types) {
                result.append(exception)
            }
        }
        return result
    }

    var first: ExceptionTable? {
        return exceptions.first
    }
    
    func monitors(from:Int) -> [ExceptionTable] {
        var result = [ExceptionTable]()
        
        for exception in monitors {
            if exception.from == from {
                result.append(exception)
            }
        }
        return result
    }
    
    // check if it is a monitorenter  monitorexist opcode try catch block
    func isMonitorOpcodeTryCatchBlock(method:Method, table: ExceptionTable) -> Bool {
        let from = method.code!.getOpcodeIndexForJumpIndex(offset: table.from)!
        let to = method.code!.getOpcodeIndexForJumpIndex(offset: table.to)!
        
        for monitorException in monitors {
            if table.isTypeAny() && table.target == monitorException.target {
                return true
            }
        }
        
        if from > 0 && to > 0 {
            if method.code!.opcodes[from - 1].code == OP_MONITORENTER {
                if method.code!.opcodes[to - 1].code == OP_MONITOREXIT {
                    if table.isTypeAny() {
                        return true
                    }
                }
            }
        }
        return false
    }
}
