//
//  Annotation.swift
//  JavaDecompiler
//
//  Created by joyeer on 26/01/2018.
//

import Foundation
import Common

// element_value {
//  u1 tag;
//  union {
//      u2 const_value_index;
//
//      {   u2 type_name_index;
//          u2 const_name_index;
//      } enum_const_value;
//
//      u2 class_info_index;
//
//      annotation annotation_value;
//
//      {   u2            num_values;
//          element_value values[num_values];
//      } array_value;
//  } value;
// }
public protocol ElementValue {
    var tag: UnicodeScalar { get }
}

public struct ConstValueElementValue : ElementValue {
    public let tag: UnicodeScalar
    public let value:Any
    
    init(_ input:DataInputStream, wixthTag tag:UnicodeScalar, reader: ConstantPoolReader) throws {
        self.tag = tag
        let const_value_index = try input.readU2()
        switch tag {
        case "B":
            value = reader.readInteger(Int(const_value_index))
        case "C":
            value = reader.readInteger(Int(const_value_index))
        case "D":
            value = reader.readDouble(Int(const_value_index))
        case "F":
            value = reader.readFloat(Int(const_value_index))
        case "I":
            value = reader.readInteger(Int(const_value_index))
        case "J":
            value = reader.readLong(Int(const_value_index))
        case "S":
            value = reader.readInteger(Int(const_value_index))
        case "Z":
            value = reader.readInteger(Int(const_value_index))
        case "s":
            value = reader.readUtf8(Int(const_value_index))
        default:
            fatalError()
        }
    }
}

public struct EnumConstValueElementValue : ElementValue {
    public let tag: UnicodeScalar = "e"
    
    public let typeName: String
    public let constName: String
    
    init(_ input:DataInputStream, reader: ConstantPoolReader) throws {
        let type_name_index = try input.readU2()
        let const_name_index = try input.readU2()
        
        typeName = reader.readUtf8(Int(type_name_index))
        constName = reader.readUtf8(Int(const_name_index))
    }
}

public struct ClassInfoElementValue : ElementValue {
    public let tag: UnicodeScalar = "c"
    public let classInfo: ReturnDescriptor
    
    init(_ input: DataInputStream, reader: ConstantPoolReader) throws {
        let class_info_index = try input.readU2()
        let descriptor = reader.readUtf8(Int(class_info_index))
        classInfo = try ReturnDescriptor(StringReader(descriptor))
    }
}

public struct AnnonationElementValue : ElementValue {
    public let tag: UnicodeScalar = "@"
    public let annotation: Annotation
    
    init(_ input: DataInputStream, reader: ConstantPoolReader) throws {
        annotation = try Annotation(annotationAttr: try AnnotationAttr(input, reader: reader), reader: reader)
    }
}

public struct ArrayValueElementValue : ElementValue {
    public let tag: UnicodeScalar = "["
    public let values:[ElementValue]
    
    init(_ input:DataInputStream, reader: ConstantPoolReader) throws {
        let num_values = try input.readU2()
        var values = [ElementValue]()
        for _ in 0 ..< num_values {
            let valueReader = ElementValueReader(input)
            values.append(try valueReader.read(reader: reader))
        }
        self.values = values
    }
}

class ElementValueReader {
    private let input: DataInputStream
    init(_ input:DataInputStream) {
        self.input = input
    }
    
    func read(reader: ConstantPoolReader) throws -> ElementValue {
        let tag = try input.readU()
        let ctag = UnicodeScalar(tag)
        switch ctag {
        case "B", "C", "D", "F", "I", "J", "S", "Z", "s":
            return try ConstValueElementValue(input, wixthTag: ctag, reader: reader)
        case "e":
            return try EnumConstValueElementValue(input, reader: reader)
        case "c":
            return try ClassInfoElementValue(input, reader: reader)
        case "@":
            return try AnnonationElementValue(input, reader: reader)
        case "[":
            return try ArrayValueElementValue(input, reader: reader)
        default:
            throw ClassFileReaderError.formatError
        }
    }
}

struct ElementValuePair {
    let name: String
    let value: ElementValue
    
    init(_ input:DataInputStream, reader: ConstantPoolReader) throws {
        let element_name_index = try input.readU2()
        name = reader.readUtf8(Int(element_name_index))
        let valueReader = ElementValueReader(input)
        value = try valueReader.read(reader: reader)
    }
}


// annotation {
//    u2 type_index;
//     u2 num_element_value_pairs;
//    {   u2            element_name_index;
//        element_value value;
//    } element_value_pairs[num_element_value_pairs];
// }

struct AnnotationAttr {
    
    let type_index: UInt16
    let element_value_pairs:[ElementValuePair]
    
    init(_ input: DataInputStream, reader: ConstantPoolReader) throws {
        type_index = try input.readU2()
        let num_element_value_pairs = try input.readU2()
        var element_value_pairs = [ElementValuePair]()
        for _ in 0 ..< num_element_value_pairs {
            element_value_pairs.append(try ElementValuePair(input, reader: reader))
        }
        self.element_value_pairs = element_value_pairs
    }
}

struct ParameterAnnotation {
    let annotations:[AnnotationAttr]
    init(_ input:DataInputStream, reader: ConstantPoolReader) throws {
        let num_annotations = try input.readU2()
        var annotations = [AnnotationAttr]()
        for _ in 0 ..< num_annotations {
            annotations.append(try AnnotationAttr(input, reader: reader))
        }
        self.annotations = annotations
    }
}

struct TypeAnnotation {
    struct type_parameter_target {
        let type_parameter_index: UInt8
        init(_ input: DataInputStream) throws {
            type_parameter_index = try input.readU()
        }
    }
    
    struct supertype_target {
        let supertype_index: UInt16
        init(_ input: DataInputStream) throws {
            supertype_index = try input.readU2()
        }
    }
    
    struct type_parameter_bound_tareget {
        let type_parameter_index: UInt8
        let bound_index: UInt8
        
        init(_ input: DataInputStream) throws {
            type_parameter_index = try input.readU()
            bound_index = try input.readU()
        }
    }
    
    struct empty_target {
    }
    
    struct formal_parameter_target {
        let formal_parameter_index: UInt8
        init(_ input: DataInputStream) throws {
            formal_parameter_index = try input.readU()
        }
    }
    
    struct throws_target {
        let throws_type_index:UInt16
        init(_ input: DataInputStream) throws {
            throws_type_index = try input.readU2()
        }
    }
    
    struct localvar_target {
        
        struct table {
            let start_pc: UInt16
            let length: UInt16
            let index: UInt16
            
            init(_ input: DataInputStream) throws {
                start_pc = try input.readU2()
                length = try input.readU2()
                index = try input.readU2()
            }
        }
        
        let tables: [table]
        
        init(_ input: DataInputStream) throws {
            let table_length = try input.readU2()
            var tables = [table]()
            for _ in 0 ..< table_length {
                tables.append(try table(input))
            }
            self.tables = tables
        }
    }
    
    struct catch_target {
        let exception_table_index: UInt16
        
        init(_ input: DataInputStream) throws {
            exception_table_index = try input.readU2()
        }
    }
    
    struct offset_target {
        let offset: UInt16
        init(_ input: DataInputStream) throws {
            offset = try input.readU2()
        }
    }
    
    struct type_argument_target {
        let offset: UInt16
        let type_argument_index: UInt8
        
        init(_ input: DataInputStream) throws {
            offset = try input.readU2()
            type_argument_index = try input.readU()
        }
    }
    
    struct type_path {
        struct path {
            let type_path_kind: UInt8
            let type_argument_index: UInt8
            
            init(_ input: DataInputStream) throws {
                type_path_kind = try input.readU()
                type_argument_index = try input.readU()
            }
        }
        
        let pathes: [path]
        init(_ input: DataInputStream) throws {
            let path_length = try input.readU()
            var pathes = [path]()
            for _ in 0 ..< path_length {
                pathes.append(try path(input))
            }
            self.pathes = pathes
        }
    }
    
    let target_info: Any
    let target_path: type_path
    let type_index: UInt16
    let element_value_pairs:[ElementValuePair]
    
    init(_ input: DataInputStream, reader: ConstantPoolReader) throws {
        let target_type = try input.readU()
        
        switch target_type {
        case 0x00, 0x01:
            target_info = try type_parameter_target(input)
        case 0x10:
            target_info = try supertype_target(input)
        case 0x11, 0x12:
            target_info = try type_parameter_bound_tareget(input)
        case 0x13, 0x14, 0x15:
            target_info = empty_target()
        case 0x16:
            target_info = try formal_parameter_target(input)
        case 0x17:
            target_info = try throws_target(input)
        case 0x40, 0x41:
            target_info = try localvar_target(input)
        case 0x42:
            target_info = try catch_target(input)
        case 0x43, 0x44, 0x45, 0x46:
            target_info = try offset_target(input)
        case 0x47, 0x48, 0x49, 0x4A, 0x4B:
            target_info = try type_argument_target(input)
        default:
            fatalError()
        }
        
        target_path = try type_path(input)
        
        type_index = try input.readU2()
        let num_element_value_pairs = try input.readU2()
        var element_value_pairs = [ElementValuePair]()
        for _ in 0 ..< num_element_value_pairs {
            element_value_pairs.append(try ElementValuePair(input, reader: reader))
        }
        self.element_value_pairs = element_value_pairs
    }
}
