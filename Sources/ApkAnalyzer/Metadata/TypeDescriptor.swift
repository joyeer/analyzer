//
//  TypeDescriptor.swift
//  DecompileAndroid
//
//  Created by Qing Xu on 2019/10/5.
//

import Foundation
import Common

public enum TypeDescriptorParseError: Error {
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

/// Type Descriptor parser
class TypeDescriptorParser {
    
    var reader: StringReader
    var rawType = ""
    var arrayDimension:Int = 0
    
    init(_ reader:StringReader) throws {
        self.reader = reader
        try parse()
        
        if arrayDimension > 0 {
            for _ in 0 ..< arrayDimension {
                rawType.append("[]")
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
                   throw TypeDescriptorParseError.format
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
            throw TypeDescriptorParseError.format
        }
    }
    
}


public struct TypeDescriptor {
    public let rawValue: String
    public private(set) var type: String?
    public private(set) var package: String?
    public private(set) var shortName: String?
    
    public init(rawValue: String) {
        self.rawValue = rawValue
        
        do {
            let parser = try TypeDescriptorParser(StringReader(self.rawValue))
            type = parser.rawType
            if let components = type?.split(separator: ".") {
                if let lastName = components.last {
                    shortName = String(lastName)
                }
                package = components.dropLast().joined(separator: ".")
                for _ in 0 ..< parser.arrayDimension {
                    type?.append("[]")
                }
            }
        } catch {
            type = nil
            package = nil
            print("parsing the format error")
        }
        
    }
    
}
