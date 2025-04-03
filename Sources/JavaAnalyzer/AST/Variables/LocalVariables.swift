//
//  LocalVariableLookup.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/7/27.
//
import Foundation

struct LocalVariableType {
    var type: JType
    var name: String
    var startAt: Int = -1
    var endAt: Int = -1
    var declared = false
}

class LocalVariable : Equatable {
    var type: JType {
        return types.last!.type
    }
    var name: String {
        return types.last!.name
    }
    
    var declared = false
    
    private var types = [LocalVariableType]()
    
    init(type: JType, name:String, startAt:Int, endAt: Int, declared: Bool) {
        let type = LocalVariableType(type: type, name: name, startAt: startAt, endAt: endAt, declared: declared)
        types.append(type)
    }
    
    func getType(target: JType) -> LocalVariableType {
        for type in types {
            if type.type == target {
                return type
            }
        }
        return types.last!
    }
    
    func description(target:JType) -> String {
        
        for type in types {
            if type.type == target {
                return type.name
            }
        }
        
        return types.last!.name
    }
    
    var description: String {
        return name
    }
    
    func append(type: LocalVariableType) {
        types.append(type)
    }
    
    func contains(type: JType) -> Bool {
        if type == .Top {
            return true
        }
        
        if type == ObjectType.Object {
            return true
        }
        
        for variable in types {
            if variable.type == type {
                return true
            }
            
            if (variable.type == .Boolean && type == .Integer) || (variable.type == .Integer && type == .Boolean ) {
                return true
            }
            
            if variable.type == ObjectType.Object  {
                return true
            }
            
        }
        return false
    }

    
}

func == (l: LocalVariable, r: LocalVariable) -> Bool {
    return l.type == r.type && l.name == r.name
}


class LocalVariableTable {
    private var localVariables: [LocalVariable]
    init(localVariables:[LocalVariable]) {
        self.localVariables = localVariables
    }

    func find(index:Int) -> LocalVariable {
        return self.localVariables[index]
    }
    
    /**
        Get all undeclared variables
     */
    func undeclaredVariables() -> [LocalVariable] {
        var result = [LocalVariable]()
        for variable in localVariables {
            if variable.declared == false {
                result.append(variable)
            }
        }
        return result
    }
}

class LocalVariableFrameSnapshot {
    var offset: Int = 0
    var locals = [JType]()
    
}

extension LocalVariableFrameSnapshot : NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let snapshot = LocalVariableFrameSnapshot()
        snapshot.locals.append(contentsOf: locals)
        snapshot.offset = offset
        return snapshot
    }
}

class StackMapTable {
    
    var snapshot = [LocalVariableFrameSnapshot]()
    
    func removeAll() {
        snapshot.removeAll()
    }
}
