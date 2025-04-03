//
//  ConstantPool.swift
//  JavaDecompiler
//
//  Created by Qing Xu on 23/01/2018.
//

import Common

let CONSTANT_Class :UInt8 = 7
let CONSTANT_Fieldref :UInt8 = 9
let CONSTANT_Methodref  :UInt8 = 10
let CONSTANT_InterfaceMethodref :UInt8 = 11
let CONSTANT_String :UInt8 = 8
let CONSTANT_Integer :UInt8 = 3
let CONSTANT_Float :UInt8 = 4
let CONSTANT_Long :UInt8 = 5
let CONSTANT_Double :UInt8 = 6
let CONSTANT_NameAndType :UInt8 = 12
let CONSTANT_Utf8 :UInt8 = 1
let CONSTANT_MethodHandle :UInt8 = 15
let CONSTANT_MethodType :UInt8 = 16
let CONSTANT_InvokeDynamic :UInt8 = 18
let CONSTANT_Module :UInt8 = 19
let CONSTANT_Package: UInt8 = 20

// MARK: - Constant Pool
protocol ConstantPoolInfo {
    var tag: UInt8 { get }
}

struct CONSTANT_Class_info : ConstantPoolInfo {
    let tag = CONSTANT_Class
    let name_index: Int
    
    init(_ input: DataInputStream) throws {
        name_index = Int(try input.readU2())
    }
}

struct CONSTANT_Utf8_info : ConstantPoolInfo {
    let tag = CONSTANT_Utf8
    let bytes: [UInt8]
    
    init(_ input: DataInputStream) throws {
        let length = try input.readU2()
        bytes = try input.readBytes(Int(length))
    }
}

struct CONSTANT_String_info : ConstantPoolInfo {
    let tag = CONSTANT_String
    let string_index: Int
    
    init(_ input: DataInputStream) throws {
        string_index = Int(try input.readU2())
    }
}

struct CONSTANT_Fieldref_info : ConstantPoolInfo {
    let tag = CONSTANT_Fieldref
    let class_index: Int
    let name_and_type_index: Int
    
    init(_ input: DataInputStream) throws {
        class_index = Int(try input.readU2())
        name_and_type_index = Int(try input.readU2())
    }
}

struct CONSTANT_Methodref_info : ConstantPoolInfo {
    let tag = CONSTANT_Methodref
    let class_index: Int
    let name_and_type_index: Int
    
    init(_ input: DataInputStream) throws {
        class_index = Int(try input.readU2())
        name_and_type_index = Int(try input.readU2())
    }
}

struct CONSTANT_InterfaceMethodref_info : ConstantPoolInfo {
    let tag = CONSTANT_InterfaceMethodref
    let class_index: Int
    let name_and_type_index: Int
    
    init(_ input: DataInputStream) throws {
        class_index = Int(try input.readU2())
        name_and_type_index = Int(try input.readU2())
    }
}

struct CONSTANT_NameAndType_info : ConstantPoolInfo {
    let tag = CONSTANT_NameAndType
    let name_index: UInt16
    let descriptor_index: UInt16
    
    init(_ input: DataInputStream) throws {
        name_index = try input.readU2()
        descriptor_index = try input.readU2()
    }
}

struct CONSTANT_Long_info : ConstantPoolInfo {
    let tag = CONSTANT_Long
    let value: Int64
    
    init(_ input: DataInputStream) throws {
        let high_bytes = try input.readU4()
        let low_bytes = try input.readU4()
        value = Int64(high_bytes) << 32 | Int64(low_bytes)
    }
}

struct CONSTANT_Double_info : ConstantPoolInfo {
    let tag = CONSTANT_Double
    let value: Double
    
    init(_ input: DataInputStream) throws {
        let high_bytes = try input.readU4()
        let low_bytes = try input.readU4()
        
        let bytes = UInt64(high_bytes) << 32 | UInt64(low_bytes)
        value = Double(bitPattern: bytes)
    }
}

struct CONSTANT_Float_info : ConstantPoolInfo {
    let tag = CONSTANT_Float
    let value: Float
    
    init(_ input: DataInputStream) throws {
        let bits = try input.readU4()
        value = Float(bitPattern: bits)
    }
}

struct CONSTANT_Integer_info : ConstantPoolInfo {
    let tag = CONSTANT_Integer
    let value:Int32
    
    init(_ input: DataInputStream) throws {
        let bytes = try input.readU4()
        value = Int32(bitPattern: bytes)
    }
}

struct CONSTANT_InvokeDynamic_info : ConstantPoolInfo {
    let tag = CONSTANT_InvokeDynamic
    let bootstrap_method_attr_index: Int
    let name_and_type_index: Int
    
    init(_ input: DataInputStream) throws {
        bootstrap_method_attr_index = Int(try input.readU2())
        name_and_type_index = Int(try input.readU2())
    }
}

struct CONSTANT_MethodHandle_info : ConstantPoolInfo {
    let tag = CONSTANT_MethodHandle
    let reference_kind: UInt8
    let reference_index: UInt16
    
    init(_ input: DataInputStream) throws {
        reference_kind = try input.readU()
        reference_index = try input.readU2()
    }
}

struct CONSTANT_MethodType_info : ConstantPoolInfo {
    let tag = CONSTANT_MethodType
    let descriptor_index: UInt16
    
    init(_ input: DataInputStream) throws {
        descriptor_index = try input.readU2()
    }
}

struct CONSTANT_Module_info: ConstantPoolInfo {
    let tag = CONSTANT_Module
    let name_index: UInt16
    
    init(_ input: DataInputStream) throws {
        name_index = try input.readU2()
    }
}

struct CONSTANT_Package_info: ConstantPoolInfo {
    let tag = CONSTANT_Package
    let name_index: UInt16
    
    init(_ input: DataInputStream) throws {
        name_index = try input.readU2()
    }
}
