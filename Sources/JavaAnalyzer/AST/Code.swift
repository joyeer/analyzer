//
//  Code.swift
//  JavaDecompiler
//
//  Created by joyeer on 03/03/2018.
//

import Foundation

public class Code : @unchecked Sendable {
    // Internal to handle the attributes
    typealias CodeAttributeProcessFunction = (Code) -> (AttributeInfo, ConstantPoolReader) throws -> Void
    nonisolated(unsafe) private static let AttributeCodeProcessFunctions:[String: CodeAttributeProcessFunction] = [
        AttributeReader.LocalVariableTable: processAttributeLocalVariableTable,
        AttributeReader.LocalVariableTypeTable: processAttributeLocalVariableTypeTable,
        AttributeReader.LineNumberTable: processAttributeLineNumberTable,
        AttributeReader.StackMapTable: processAttributeStackMapTable,
        AttributeReader.RuntimeInvisibleTypeAnnotations: processAttributeRuntimeInvisibleTypeAnnotations
    ]
    
    public private(set)var opcodes = [JOpcode]()
    private let codeInfo:CodeAttributeInfo?
    private var scan = -1
    private let reader: ConstantPoolReader?
    private let method:Method?
    
    private(set) var localVariables = [LocalVariable]()
    private var offsetOpcodeIndexMapping = [Int: Int]()
    private(set) var stackMapTable = StackMapTable()
    
    init(opcodes ops: [JOpcode]) {
        self.opcodes = ops
        codeInfo = nil
        reader = nil
        method = nil
    }
    
    init(code: CodeAttributeInfo, method:Method, reader: ConstantPoolReader) throws {
        self.codeInfo = code
        self.reader = reader
        self.method = method
        
        let decoder = OpcodeDecoder(codeInfo!.code)
        let jopcodes = try decoder.decode()
        
        jopcodes.enumerated().forEach { (index, elem) in
            offsetOpcodeIndexMapping[elem.offset] = index
        }
        
        opcodes = jopcodes
        
        for i in 0 ..< code.max_locals {
            let variable = LocalVariable(type: ObjectType.Object, name: "var\(i)", startAt: 0, endAt: code.code.count, declared: false)
            localVariables.append(variable)
        }
        
        try processCodeAttributes(attributes: code.attributes, reader: reader)
    }
    
    // Get the opcode index for a specific offset
    public func getOpcodeIndexForJumpIndex(offset:Int) -> Int? {
        return offsetOpcodeIndexMapping[offset]
    }
}

extension Code {
    
    func processCodeAttributes(attributes:[AttributeInfo], reader: ConstantPoolReader) throws {
        for attribute in attributes {
            let processor = Code.AttributeCodeProcessFunctions[attribute.name]!
            try processor(self)(attribute, reader)
        }
    }
    
    func processAttributeLocalVariableTable(attribute:AttributeInfo, reader:ConstantPoolReader) throws {
        let localVariableTableAttributeInfo = attribute as! LocalVariableTableAttributeInfo
        
        var flags = Set<Int>()
        for table in localVariableTableAttributeInfo.local_variable_tables {
            let name = reader.readUtf8(table.name_index)
            let descriptor = try FieldDescritpor(reader.readUtf8(table.descriptor_index))
            
            if flags.contains(table.index) == false {
                localVariables[table.index] = LocalVariable(type: JType(type: descriptor.javaType, descriptor: descriptor.rawDescriptor), name: name, startAt: table.start_pc, endAt: table.start_pc + table.length, declared: false)
                
                //  the given local variable is of type double or long, it occupies both index and index + 1
                if descriptor.javaType == "double" || descriptor.javaType == "long" {
                    localVariables[table.index + 1] = localVariables[table.index]
                }
                flags.insert(table.index)
            } else {
                let localVariableType = LocalVariableType(type: JType(type: descriptor.javaType, descriptor: descriptor.rawDescriptor), name: name, startAt: table.start_pc, endAt: table.start_pc + table.length, declared: false)
                localVariables[table.index].append(type: localVariableType)
            }
        }
        
    }
    
    func processAttributeLocalVariableTypeTable(attribute:AttributeInfo, reader:ConstantPoolReader) throws {
        
    }
    
    func processAttributeRuntimeInvisibleTypeAnnotations(attribute:AttributeInfo, reader: ConstantPoolReader) throws {
        
    }
    
    func processAttributeLineNumberTable(attribute:AttributeInfo, reader:ConstantPoolReader) throws {
        
    }
    
    func processAttributeStackMapTable(attribute:AttributeInfo, reader:ConstantPoolReader) throws {
        let stackMapFrame  = StackMapTable()
        
        var previous :LocalVariableFrameSnapshot = LocalVariableFrameSnapshot()
        var previousOffset = 0
        
        var initVariableCount:Int = method!.parameters.count
        if method!.accessFlags.isStatic == false {
            initVariableCount += 1
        }
        
        for i in 0 ..< initVariableCount {
            previous.locals.append(localVariables[i].type)
        }
        
        let stackMapTableAttributeInfo = attribute as! StackMapTableAttributeInfo
        for frame in stackMapTableAttributeInfo.entries {
            let snapshot: LocalVariableFrameSnapshot?
            let offsetDelta: Int
            if frame.full_frame != nil {
                offsetDelta = frame.full_frame!.getOffsetDelta()
                snapshot = try processStackMapFullFrame(frame: frame.full_frame!, previous: previous)
            } else if frame.same_frame != nil {
                offsetDelta = frame.same_frame!.getOffsetDelta()
                snapshot = processStackMapSameFrame(frame: frame.same_frame!, previous: previous)
            } else if frame.same_locals_1_stack_item_frame != nil {
                offsetDelta = frame.same_locals_1_stack_item_frame!.getOffsetDelta()
                snapshot = processStackMapSameLocals1StackItemFrame(frame: frame.same_locals_1_stack_item_frame!, previous: previous)
            } else if frame.same_locals_1_stack_item_frame_extended != nil {
                offsetDelta = frame.same_locals_1_stack_item_frame_extended!.getOffsetDelta()
                snapshot = processStackMapSameLocals1StackItemFrameExtended(frame: frame.same_locals_1_stack_item_frame_extended!, previous: previous)
            } else if frame.chop_frame != nil {
                offsetDelta = frame.chop_frame!.getOffsetDelta()
                snapshot = processStackMapChopFrame(frame: frame.chop_frame!, previous: previous)
            } else if frame.same_frame_extended != nil {
                offsetDelta = frame.same_frame_extended!.getOffsetDelta()
                snapshot = processStackMapSameFrameExtended(frame: frame.same_frame_extended!, previous: previous)
            } else if frame.append_frame != nil {
                offsetDelta = frame.append_frame!.getOffsetDelta()
                snapshot = try processStackMapAppendFrame(frame: frame.append_frame!, previous: previous)
            }  else {
                fatalError()
            }
            
            snapshot!.offset = previousOffset + offsetDelta + 1
            previousOffset = snapshot!.offset
            previous = snapshot!
            stackMapFrame.snapshot.append(snapshot!)
            
//            verifySnapshotFrame(snapshot: snapshot!)
        }
    }
    
    private func processStackMapSameFrame(frame: StackMapTableAttributeInfo.StackMapFrame.SameFrame, previous: LocalVariableFrameSnapshot) -> LocalVariableFrameSnapshot? {
        return previous.copy() as? LocalVariableFrameSnapshot
    }
    
    private func processStackMapSameLocals1StackItemFrame(frame: StackMapTableAttributeInfo.StackMapFrame.SameLocals1StackItemFrame, previous: LocalVariableFrameSnapshot) -> LocalVariableFrameSnapshot? {
        return previous.copy() as? LocalVariableFrameSnapshot
    }
    
    private func processStackMapSameLocals1StackItemFrameExtended(frame: StackMapTableAttributeInfo.StackMapFrame.SameLocals1StackItemFrameExtended, previous: LocalVariableFrameSnapshot) -> LocalVariableFrameSnapshot? {
        return previous.copy() as? LocalVariableFrameSnapshot
    }
    
    private func processStackMapChopFrame(frame: StackMapTableAttributeInfo.StackMapFrame.ChopFrame, previous: LocalVariableFrameSnapshot) -> LocalVariableFrameSnapshot? {
        let snapshot = previous.copy() as? LocalVariableFrameSnapshot
        let k = 251 - frame.frame_type
        for _ in 0 ..< k {
            snapshot!.locals.removeLast()
        }
        
        return snapshot
    }
    
    private func processStackMapSameFrameExtended(frame: StackMapTableAttributeInfo.StackMapFrame.SameFrameExtended, previous: LocalVariableFrameSnapshot) -> LocalVariableFrameSnapshot? {
        return previous.copy() as? LocalVariableFrameSnapshot
    }
    
    private func processStackMapAppendFrame(frame: StackMapTableAttributeInfo.StackMapFrame.AppendFrame, previous: LocalVariableFrameSnapshot) throws -> LocalVariableFrameSnapshot? {
        let snapshot = previous.copy() as? LocalVariableFrameSnapshot
        for var i in 0 ..< frame.locals.count {
            let local = frame.locals[i]
            let type = try getVerificationType(info: local)
            if type == .Double || type == .Long {
                i += 1
                snapshot!.locals.append(type)
            }
            
            snapshot!.locals.append(type)
        }
        return snapshot
    }
 
    private func processStackMapFullFrame(frame: StackMapTableAttributeInfo.StackMapFrame.FullFrame,previous: LocalVariableFrameSnapshot) throws -> LocalVariableFrameSnapshot? {
        let snapshot = LocalVariableFrameSnapshot()
        for var i in 0 ..< frame.locals.count {
            let local = frame.locals[i]
            let type = try getVerificationType(info: local)
            if type == .Double || type == .Long {
                i += 1
                snapshot.locals.append(type)
            }
            
            snapshot.locals.append(type)

        }
        return snapshot
    }

    private func getVerificationType(info: StackMapTableAttributeInfo.VerificationTypeInfo) throws -> JType {
        switch info {
        case .Top_variable_info:
            return .Top
        case .Integer_variable_info:
            return .Integer
        case .Float_variable_info:
            return .Float
        case .Long_variable_info:
            return .Long
        case .Double_variable_info:
            return .Double
        case .Null_variable_info:
            return .Null
        case .UninitializedThis_variable_info:
            return localVariables.first!.type
        case .Object_variable_info(let objectInfo):
            return try reader!.readClassInfo(Int(objectInfo.cpool_index))
        default:
            fatalError()
        }
    }
    
    private func verifySnapshotFrame(snapshot: LocalVariableFrameSnapshot) {
        for (index, local) in snapshot.locals.enumerated() {
            let bucket = localVariables[index]
            if bucket.contains(type: local) == false {
                print("error:\(local.fullDescription), inde:\(index)")
            }
            
        }
    }
}
