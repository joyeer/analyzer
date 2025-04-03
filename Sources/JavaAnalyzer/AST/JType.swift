//
//  Type.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/8/7.
//

import Foundation

// an identifer that specifies a generic type
public class TypeArgument : CustomStringConvertible {
    /// The indicator could be *, + , -
    public internal(set) var indicator:Character?;
    public internal(set) var parameter:JType?
    
    init(indicator:Character?) {
        self.indicator = indicator
    }
    
    public var descriptor: String {
        if indicator == "*" {
            return "?"
        }
        
        if indicator == "-" {
            return "? super " + parameter!.descriptor
        }
        
        if indicator == "+" {
            return "? extends " + parameter!.descriptor
        }
        
        return parameter!.descriptor
    }

    public var description:String {
        if indicator == "*" {
            return "?"
        }
        
        if indicator == "-" {
            return "? super " + parameter!.description
        }
        
        if indicator == "+" {
            return "? extends " + parameter!.description
        }
        
        return parameter!.description
    }
    
    var fullDescription: String {
        if indicator == "*" {
            return "?"
        }
        
        if indicator == "-" {
            return "? super " + parameter!.fullDescription
        }
        
        if indicator == "+" {
            return "? extends " + parameter!.fullDescription
        }
        
        return parameter!.fullDescription
    }
}

public class TypeVariable: JType {
    private let identifier: String
    
    init(identifier: String) {
        self.identifier = identifier
        super.init(type: identifier, descriptor: identifier)
    }
    
    public override var description: String {
        return identifier
    }
}


public class JType : CustomStringConvertible, Equatable {
    static let TEXT_Integer = "int"
    static let TEXT_Short = "short"
    static let TEXT_Char = "char"
    static let TEXT_Float = "float"
    static let TEXT_Double = "double"
    static let TEXT_Long = "long"
    static let TEXT_Boolean = "boolean"
    static let TEXT_Byte = "byte"
    static let TEXT_Null = "null"
    static let TEXT_Void = "void"
    static let TEXT_Top = "top" // used for verification type checker
    
    nonisolated(unsafe) public static let Integer = JType(raw: "I")
    nonisolated(unsafe) public static let Short = JType(raw: "S")
    nonisolated(unsafe) public static let Char = JType(raw: "C")
    nonisolated(unsafe) public static let Float = JType(raw: "F")
    nonisolated(unsafe) public static let Double = JType(raw: "D")
    nonisolated(unsafe) public static let Long = JType(raw: "J")
    nonisolated(unsafe) public static let Boolean = JType(raw: "Z")
    nonisolated(unsafe) public static let Byte = JType(raw: "B")
    nonisolated(unsafe) public static let Null = JType(type: "null", descriptor: "null")
    nonisolated(unsafe) public static let Void = JType(raw: "V")
    nonisolated(unsafe) public static let Top = JType(type: "top", descriptor: "top")
    
    public let type:String
    public var descriptor: String
    
    public init(raw: Character) {
        descriptor = String(raw)
        switch raw {
        case "B":
            type = JType.TEXT_Byte
        case "C":
            type = JType.TEXT_Char
        case "D":
            type = JType.TEXT_Double
        case "F":
            type = JType.TEXT_Float
        case "I":
            type = JType.TEXT_Integer
        case "J":
            type = JType.TEXT_Long
        case "S":
            type = JType.TEXT_Short
        case "Z":
            type = JType.TEXT_Boolean
        case "V":
            type = JType.TEXT_Void
        default:
            fatalError()
        }
    }
    
    public init(type: String, descriptor: String) {
        self.type = type
        self.descriptor = descriptor
    }
    
    public var description: String {
        return type
    }
    
    public var fullDescription: String {
        return type
    }
}

public func == (lhs: JType, rhs: JType) -> Bool {
    return lhs.type == rhs.type
}

public func != (lhs: JType, rhs: JType) -> Bool {
    return lhs.type != rhs.type
}


public class ClassType : JType {
    public let package: PackageSpecifier?
    public let simpleType: SimpleClassType
    public let suffixes: [SimpleClassType]
    
    public init(package: PackageSpecifier?, type: SimpleClassType, suffixes: [SimpleClassType]) {
        self.package = package
        self.simpleType = type
        self.suffixes = suffixes
        super.init(type: "", descriptor: "")
    }
    
    public override var description: String {
        var result = [String]()
        
        if let package = package {
            result.append(package.description)
            result.append(".")
        }
        
        result.append(simpleType.description)
        
        for suffix in suffixes {
            result.append(".")
            result.append(suffix.description)
        }
        
        return result.joined()
    }
    
    public override var descriptor: String {
        get {
            var result = [String]()
            result.append("L")
            if let package = package {
                result.append(package.descriptor)
                result.append("/")
            }
            
            result.append(simpleType.descriptor)
            
            for suffix in suffixes {
                result.append("$")
                result.append(suffix.descriptor)
            }
            result.append(";")
            return result.joined()
        }
        set {
            fatalError("descriptor is never be setted")
        }
    }
}


public class ObjectType : JType {
    nonisolated(unsafe) public static let String = ObjectType(package: "java.lang", type: "String", displayType: "String")
    nonisolated(unsafe) public static let StringBuilder = ObjectType(package: "java.lang", type: "StringBuilder", displayType: "StringBuilder")
    nonisolated(unsafe) public static let Object = ObjectType(package: "java.lang", type: "Object", displayType: "Object")
    nonisolated(unsafe) public static let Deprecated = ObjectType(package: "java.lang", type: "Deprecated", displayType: "Deprecated")
    
    public let package: String
    public let shortType: String
    
    // This is for displaying in the source code, it could be a full class name ( including package) or a short class name
    public var displayType: String?
    
    public var typeParams = [TypeArgument]()
    
    public init(package: String, type: String) {
        self.package = package
        self.shortType = type
        if package.count > 0 {
            super.init(type: "\(package).\(type)", descriptor: "L\(package.replacingOccurrences(of: ".", with: "/"))/\(shortType);")
        } else {
            super.init(type: "\(type)", descriptor: "L\(package.replacingOccurrences(of: ".", with: "/"))/\(shortType);")
        }
        
    }
    
    private convenience init(package: String, type: String, displayType: String) {
        self.init(package: package, type: type)
        self.displayType = displayType
    }
    
    
    public convenience init(package: String, type:String, typeParams:[TypeArgument] ) {
        self.init(package: package, type: type)
        self.typeParams = typeParams
    }
    
    public convenience init(classType: String) {
        var shortType = classType
        var package = ""
        if let index = classType.lastIndex(of: ".") {
            package = Swift.String(classType[classType.startIndex..<index])
            shortType = Swift.String(classType[classType.index(after: index)...])
        }
        self.init(package: package, type: shortType)
    }
    
    public convenience init(type: String, typeParams:[TypeArgument]) {
        self.init(classType: type)
        self.typeParams = typeParams
    }
    
    public override var description: String {
        
        var printType:String
        if displayType != nil {
            printType = displayType!
        } else {
            printType = type
        }
        
        var result = [Swift.String]()
        
        for param in typeParams {
            result.append(param.description)
        }
        
        if result.count > 0 {
            let params = result.joined(separator: ", ")
            return "\(printType)<\(params)>"
        } else {
            return printType
        }
    }
    
    public override var fullDescription: String {
        var result = [Swift.String]()
        
        for param in typeParams {
            result.append(param.fullDescription)
        }
        
        if result.count > 0 {
            let params = result.joined(separator: ", ")
            return "\(type)<\(params)>"
        } else {
            return type
        }
    }

}

public class ArrayType : JType {
    private let baseType: JType
    
    init(type: JType) {
        self.baseType = type
        super.init(type: type.description + "[]", descriptor: "[\(type.descriptor)")
    }
    
    public override var description: String {
        return type
    }
}
