//
//  EncodedValue.swift
//  ApkAnalyzer
//
//  Created by Joyeer on 2019/10/14.
//

import Common
import Foundation

struct EncodedAnnotation {
    let type_idx: UInt
    let size: UInt
    let elements: [AnnotationElement]
    
    init(_ data: DataInputStream) throws {
        type_idx = try data.readUleb128()
        size = try data.readUleb128()
        var elements = [AnnotationElement]()
        for _ in 0 ..< size {
            elements.append(try AnnotationElement(data))
        }
        self.elements = elements
    }
    
    func toAnnotation(table: Table, visibility: AnnotationVisibility?) throws -> Annotation {
        let type = table.types[Int(type_idx)]
        var pairs = [String: Value]()
        for element in elements {
            let name = table.strings[Int(element.name_idx)]
            let value = try element.value.toValue(table: table)
            pairs[name] = value
        }
        
        return Annotation(visibility: visibility, type: type, elements: pairs)
    }
}

struct AnnotationElement {
    let name_idx: UInt
    let value: EncodedValue
    
    init(_ data: DataInputStream) throws {
        name_idx = try data.readUleb128()
        value = try EncodedValue(data)
    }
}

struct EncodedValue {
    static let VALUE_BYTE: UInt8 = 0x00
    static let VALUE_SHORT: UInt8 = 0x02
    static let VALUE_CHAR: UInt8 = 0x03
    static let VALUE_INT: UInt8 = 0x04
    static let VALUE_LONG: UInt8 = 0x06
    static let VALUE_FLOAT: UInt8 = 0x10
    static let VALUE_DOUBLE: UInt8 = 0x11
    static let VALUE_METHOD_TYPE: UInt8 = 0x15
    static let VALUE_METHOD_HANDLE: UInt8 = 0x16
    static let VALUE_STRING: UInt8 = 0x17
    static let VALUE_TYPE: UInt8 = 0x18
    static let VALUE_FIELD: UInt8 = 0x19
    static let VALUE_METHOD: UInt8 = 0x1a
    static let VALUE_ENUM: UInt8 = 0x1b
    static let VALUE_ARRAY: UInt8 = 0x1c
    static let VALUE_ANNOTATION:UInt8 = 0x1d
    static let VALUE_NULL: UInt8 = 0x1e
    static let VALUE_BOOLEAN: UInt8 = 0x1f
    
    static let DexAnnotationValueTypeMask:UInt8 = 0x1f
    
    let value_arg: UInt8
    let value_type: UInt8
    let values: Any?
    
    init(_ data: DataInputStream) throws {
        let value = try data.readU()
        self.value_type = value & EncodedValue.DexAnnotationValueTypeMask
        self.value_arg = value >> 5
        switch self.value_type {
        case EncodedValue.VALUE_BYTE:
            if value_arg != 0 {
                throw IOError.format
            }
            self.values = try data.readBytes(1)
        case EncodedValue.VALUE_SHORT,
             EncodedValue.VALUE_CHAR,
             EncodedValue.VALUE_INT,
             EncodedValue.VALUE_LONG,
             EncodedValue.VALUE_FLOAT,
             EncodedValue.VALUE_DOUBLE,
             EncodedValue.VALUE_METHOD_TYPE,
             EncodedValue.VALUE_METHOD_HANDLE,
             EncodedValue.VALUE_STRING,
             EncodedValue.VALUE_TYPE,
             EncodedValue.VALUE_FIELD,
             EncodedValue.VALUE_METHOD,
             EncodedValue.VALUE_ENUM:
            self.values = try data.readBytes(Int(value_arg) + 1)
        case EncodedValue.VALUE_ARRAY:
            self.values = try EncodedArray(data)
        case EncodedValue.VALUE_ANNOTATION:
            self.values = try EncodedAnnotation(data)
        case EncodedValue.VALUE_NULL:
            self.values = nil
        case EncodedValue.VALUE_BOOLEAN:
            self.values = nil
        default:
            throw IOError.format
        }
    }
    
    func toValue(table:Table) throws -> Value {
        var value:Any? = nil
        switch self.value_type {
        case EncodedValue.VALUE_BYTE,
             EncodedValue.VALUE_CHAR,
             EncodedValue.VALUE_INT     ,
             EncodedValue.VALUE_LONG,
             EncodedValue.VALUE_FLOAT,
             EncodedValue.VALUE_DOUBLE,
             EncodedValue.VALUE_METHOD_TYPE,
             EncodedValue.VALUE_METHOD_HANDLE,
             EncodedValue.VALUE_STRING,
             EncodedValue.VALUE_TYPE,
             EncodedValue.VALUE_FIELD,
             EncodedValue.VALUE_METHOD,
             EncodedValue.VALUE_ENUM:
            guard let bytes = values as? [UInt8] else {
                throw IOError.format
            }
            
            let reader = DataInputStream(Data(bytes), litteEndian: true)
            switch self.value_type {
            case EncodedValue.VALUE_BYTE:
                value = try reader.readU()
            case EncodedValue.VALUE_FLOAT,
                 EncodedValue.VALUE_DOUBLE,
                 EncodedValue.VALUE_SHORT,
                 EncodedValue.VALUE_INT,
                 EncodedValue.VALUE_LONG,
                 EncodedValue.VALUE_CHAR,
                 EncodedValue.VALUE_METHOD,
                 EncodedValue.VALUE_METHOD_TYPE,
                 EncodedValue.VALUE_METHOD_HANDLE,
                 EncodedValue.VALUE_STRING,
                 EncodedValue.VALUE_TYPE,
                 EncodedValue.VALUE_TYPE,
                 EncodedValue.VALUE_FIELD,
                 EncodedValue.VALUE_ENUM:
                switch (value_arg + 1) {
                case 1:
                    value = try reader.readU()
                case 2:
                    value = try reader.readU2()
                case 4:
                    value = try reader.readU4()
                case 8:
                    value = try reader.readUInt64()
                default:
                    value = 0
                    print("error in EncodedValue, align not 1/2/4/8, its: (value_arg+ 1)")
                }
                
                if value_type == EncodedValue.VALUE_FLOAT {
                    value = Float(bitPattern: UInt32("\(value!)")!)
                } else if value_type == EncodedValue.VALUE_DOUBLE {
                    value = Double(bitPattern: UInt64("\(value!)")!)
                }
            default:
                fatalError()
            }
        case EncodedValue.VALUE_ARRAY:
            guard let valueArray = values as? EncodedArray else {
                throw IOError.format
            }
            
            var result = [Value]()
            for v in valueArray.values {
                result.append(try v.toValue(table: table))
            }
            value = result
        case EncodedValue.VALUE_ANNOTATION:
            guard let encodedAnnotation = values as? EncodedAnnotation else {
                throw IOError.format
            }
            
            value = try encodedAnnotation.toAnnotation(table: table, visibility: nil)
        case EncodedValue.VALUE_NULL:
            value = nil
        case EncodedValue.VALUE_BOOLEAN:
            value = value_arg == 1
        default:
            fatalError()
        }
        return Value(type: Int(value_type), arg: Int(value_arg), value: value)
    }
    
}

struct EncodedArray {
    
    let values: [EncodedValue]
    init(_ data: DataInputStream) throws {
        let size = try data.readUleb128()
        var values = [EncodedValue]()
        for _ in 0 ..< size {
            let encodedValue = try EncodedValue(data)
            values.append(encodedValue)
        }
        self.values = values
    }
}

