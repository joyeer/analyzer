//
//  Descriptor.swift
//  JavaDecompiler
//
//  Created by Qing Xu on 26/02/2018.
//

import Common

public enum ParseDescriptorError: Error {
    case format
}

private let TYPE_DESCRIPTOR_MAP = [
    "byte": "B",
    "char": "C",
    "double": "D",
    "float": "F",
    "int": "I",
    "long": "J",
    "short": "S",
    "boolean": "Z",
    "void": "V"
]

fileprivate class FieldTypeParser {
    
    var reader: StringReader
    var rawType = ""
    public private(set) var javaType = ""
    var arrayDimension:Int = 0
    
    init(_ reader:StringReader) throws {
        self.reader = reader
        try parse()
        
        javaType = rawType
        if arrayDimension > 0 {
            for _ in 0 ..< arrayDimension {
                javaType.append("[]")
            }
        }
    }
    
    private func parse() throws {
        let type = reader.next()!
        switch type {
        case "B":
            rawType = "byte"
        case "C":
            rawType = "char"
        case "D":
            rawType = "double"
        case "F":
            rawType = "float"
        case "I":
            rawType = "int"
        case "J":
            rawType = "long"
        case "S":
            rawType = "short"
        case "Z":
            rawType = "boolean"
        case "V":
            rawType = "void"
        case "L":
            let startAt = reader.pos
            while true {
                let token = reader.next()
                if token == nil {
                   throw ParseDescriptorError.format
                }
                
                if token == ";" {
                    break
                }
            }
            let endAt = reader.pos
            rawType = reader.substring(startAt: startAt + 1, endAt: endAt - 1).replacingOccurrences(of: "/", with: ".")
        case "[":
            arrayDimension += 1
            try parse()
        default:
            throw ParseDescriptorError.format
        }
    }
    
}

public class Descriptor {
    static func formatAsDescriptor(_ type:String, withDim dim:Int) -> String {
        var result:String = ""
        for _ in 0 ..< dim {
            result += "["
        }
        
        var descriptor =  TYPE_DESCRIPTOR_MAP[type];
        if descriptor == nil {
            descriptor = "L" + type.replacingOccurrences(of: ".", with: "/") + ";"
        }
        
        return result + descriptor!
    }

    fileprivate let reader:StringReader
    let rawDescriptor:String
    
    public init(_ descriptor:String) throws {
        rawDescriptor = descriptor
        reader = StringReader(descriptor)
        if rawDescriptor.count > 0 {
            try parse()
        }
    }
    
    fileprivate func parse() throws {
    }
}


public class FieldDescritpor : Descriptor {
    public private(set) var javaType = ""
    
    public override init(_ descriptor: String) throws {
        try super.init(descriptor)
    }
    
    init(withType type:String, withDim dim:Int) throws {
        try super.init(Descriptor.formatAsDescriptor(type, withDim: dim))
    }
    
    override func parse() throws {
        let parser = try FieldTypeParser(reader)
        javaType = parser.javaType
    }
}


// This is the Parameter Descritpor
public class ParameterDescriptor {
    public private(set) var javaType = ""
    public private(set) var descriptor = ""
    init(withJavaType type:String) {
        javaType = type
    }
    
    fileprivate init(_ reader:StringReader) throws {
        let startAt = reader.pos
        let parser = try FieldTypeParser(reader)
        let endAt = reader.pos
        javaType = parser.javaType
        descriptor = reader.substring(startAt: startAt + 1, endAt: endAt)
    }
}

public class ReturnDescriptor {
    public private(set) var javaType = ""
    public private(set) var descriptor = ""
    
    internal init(_ type:String, withDim dim:Int) throws {
        let descriptor = Descriptor.formatAsDescriptor(type, withDim: dim)
        let parser = try FieldTypeParser(StringReader(descriptor))
        javaType = parser.javaType
    }
    
    internal init(_ reader:StringReader) throws {
        let startAt = reader.pos
        let parser = try FieldTypeParser(reader)
        let endAt = reader.pos
        javaType = parser.javaType
        descriptor = reader.substring(startAt: startAt + 1, endAt: endAt)
    }
    
    var type: JType {
        return  JType(type: javaType, descriptor: descriptor)
    }
}

// This is the method descriptor
public class MethodDescriptor: Descriptor {
    public internal(set) var parameters = [ParameterDescriptor]()
    public private(set) var returnType: ReturnDescriptor?
    
    public override init(_ descriptor: String) throws {
        try super.init(descriptor)
    }
    
    init(_ parameterTypes:[ParameterDescriptor], andReturnType returnType:ReturnDescriptor?) throws {
        try super.init("")
        self.parameters = parameterTypes
        self.returnType = returnType
    }
    
    override func parse() throws {
        let leftBracket = reader.next()
        if leftBracket != "(" {
            throw ParseDescriptorError.format
        }
        
        while true {
            let rightBracket = reader.next()
            if rightBracket == ")" {
                break
            }
            _ = reader.prevous()
            let param = try ParameterDescriptor(reader)
            parameters.append(param)
        }
        
        returnType = try ReturnDescriptor(reader)
    }
}

