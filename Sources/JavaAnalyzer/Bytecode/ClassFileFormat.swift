//
//  ClassFile.swift
//  Decompilr
//
//  Created by Qing Xu on 01/12/2016.
//  Copyright © 2016 decompile.io. All rights reserved.
//
import Common

// MARK: - Class File Format

public struct ClassFile {
    static let MAGIC:UInt32 = 0xCAFEBABE
    
    let minor_version: UInt16
    let major_version: UInt16
    let constant_pool: [ConstantPoolInfo]
    let access_flags: UInt16
    let this_class: UInt16
    let super_class: UInt16
    let interfaces: [UInt16]
    let fields: [FieldInfo]
    let methods: [MethodInfo]
    let attributes: [AttributeInfo]
    
    public init(_ inputStream: DataInputStream) throws {
        
        let magic = try inputStream.readU4()
        guard magic == ClassFile.MAGIC else {
            throw ClassFileReaderError.formatError
        }

        minor_version = try inputStream.readU2()
        major_version = try inputStream.readU2()
        
        let constant_pool_count = try inputStream.readU2()
        var constantPool = [ConstantPoolInfo]()
        var index = 1
        while index < constant_pool_count {
            let constant = try ClassFile.readConstantPool(inputStream)
            if constant.tag == CONSTANT_Long || constant.tag == CONSTANT_Double {
                constantPool.append(constant)
                index += 1
            }
            constantPool.append(constant)
            index += 1
        }
        self.constant_pool = constantPool
        access_flags = try inputStream.readU2()
        this_class = try inputStream.readU2()
        super_class = try inputStream.readU2()
        
        // interfaces
        let interfaces_count = try inputStream.readU2()
        var interfaces = [UInt16]()
        for _ in 0 ..< interfaces_count {
            interfaces.append(try inputStream.readU2())
        }
        self.interfaces = interfaces
        
        let constantReader = ConstantPoolReader(constantPool)
        
        // Fields
        let fields_count = try inputStream.readU2()
        var fields = [FieldInfo]()
        for _ in 0 ..< fields_count {
            fields.append(try FieldInfo(inputStream, constant:constantReader))
        }
        self.fields = fields
        
        // Methods
        let methods_count = try inputStream.readU2()
        var methods = [MethodInfo]()
        for _ in 0 ..< methods_count {
            methods.append(try MethodInfo(inputStream, constant:constantReader))
        }
        self.methods = methods
        
        // Attributes
        let attributes_count = try inputStream.readU2()
        var attributes = [AttributeInfo]()
        for _ in 0 ..< attributes_count {
            let reader = AttributeReader(inputStream, constant: constantReader)
            let attribute = try reader.read()
            attributes.append(attribute)
        }
        self.attributes = attributes
    }
    
    // MARK: - Constant Pool
    private static func readConstantPool(_ input:DataInputStream) throws -> ConstantPoolInfo {
        let tag = try input.readU()
        switch tag {
        case CONSTANT_Class:
            return try CONSTANT_Class_info(input)
        case CONSTANT_Fieldref:
            return try CONSTANT_Fieldref_info(input)
        case CONSTANT_Methodref:
            return try CONSTANT_Methodref_info(input)
        case CONSTANT_InterfaceMethodref:
            return try CONSTANT_InterfaceMethodref_info(input)
        case CONSTANT_String:
            return try CONSTANT_String_info(input)
        case CONSTANT_Integer:
            return try CONSTANT_Integer_info(input)
        case CONSTANT_Float:
            return try CONSTANT_Float_info(input)
        case CONSTANT_Long:
            return try CONSTANT_Long_info(input)
        case CONSTANT_Double:
            return try CONSTANT_Double_info(input)
        case CONSTANT_NameAndType:
            return try CONSTANT_NameAndType_info(input)
        case CONSTANT_Utf8:
            return try CONSTANT_Utf8_info(input)
        case CONSTANT_MethodHandle:
            return try CONSTANT_MethodHandle_info(input)
        case CONSTANT_MethodType:
            return try CONSTANT_MethodType_info(input)
        case CONSTANT_InvokeDynamic:
            return try CONSTANT_InvokeDynamic_info(input)
        case CONSTANT_Module:
            return try CONSTANT_Module_info(input)
        case CONSTANT_Package:
            return try CONSTANT_Package_info(input)
        default:
            throw ClassFileReaderError.formatError;
        }
    }
    
}

