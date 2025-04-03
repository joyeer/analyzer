//
//  JavaTypeSignature.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/7/18.
//

import Common

public class SignatureParser {
    internal static let Chars:Set<Character> = {
            var chars = Set<Character>()
            for ch in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$0123456789" {
                chars.insert(ch)
            }
            return chars
        }();
    
    let reader: StringReader
    let signature: String
    public init(signature:String) {
        self.signature = signature
        reader = StringReader(signature)
    }
    
    public func tryParseJavaType() throws -> JType {
        if let result = tryParseBaseType() {
            return result
        }
        
        if let result = try tryParseReferenceTypeSignature() {
            return result
        }
        
        throw IOError.format
    }
    
    /**
     * BaseType:
     *   (one of)
     *   B C D F I J S Z
     */
    func tryParseBaseType() -> JType? {
        if reader.hasNext() {
            let ch = reader.next()!
            switch ch {
            case "B", "C", "D", "F", "I", "J", "S", "Z":
                return JType(raw: ch)
            default:
                _ = reader.prevous()
                return nil
            }
        }
        return nil
    }

    /**
     *  ReferenceTypeSignature:
     *  ClassTypeSignature
     *  TypeVariableSignature
     *  ArrayTypeSignature
     */
    func tryParseReferenceTypeSignature() throws -> JType? {
        if let result = try tryParseClassTypeSignature() {
            return result
        }
        if let result = try tryParseTypeVariableSignature() {
            return result
        }
        if let result = try tryParseArrayTypeSignature()  {
            return result
        }
        
        return nil
    }
    
    func tryParseArrayTypeSignature() throws -> JType? {
        let ch = reader.next()!
        if ch == "[" {
            let type = try tryParseJavaType()
            return ArrayType(type: type)
        }
        _ = reader.prevous()
        return nil
    }
    
    /**
     * TypeVariableSignature:
     *  T Identifier ;
     */
    func tryParseTypeVariableSignature() throws -> JType? {
        let ch = reader.next()!
        if ch == "T" {
            let identifier = tryParseIdentifier()
            if identifier == nil {
                throw IOError.format
            }
            if reader.next()! != ";" {
                throw IOError.format
            }
            return TypeVariable(identifier: identifier!)
        }
        _ = reader.prevous()
        return nil
    }
    
    /**
     *  ClassTypeSignature:
     *      L [PackageSpecifier] SimpleClassTypeSignature {ClassTypeSignatureSuffix} ;
     */
    func tryParseClassTypeSignature() throws -> ClassType? {
        let ch = reader.next()!
        if ch == "L" {
            
            let packageSpecifier = tryParsePackageSpecifier()
            let simpleClassType = try tryParseSimpleClassTypeSignature()
            let suffixes = try tryParseClassTypeSignatureSuffixes()
            
            
            if reader.next() != ";" {
                return nil
            }
            
            return ClassType(package: packageSpecifier, type: simpleClassType, suffixes: suffixes)
            
        }
        _ = reader.prevous()
        return nil
    }
    
    func tryParseClassTypeSignatureSuffixes() throws -> [SimpleClassType] {
        var suffixes = [SimpleClassType]()
        while let suffix = try tryParseClassTypeSignatureSuffix() {
            suffixes.append(suffix)
            continue
        }
        
        return suffixes
    }
    func tryParseClassTypeSignatureSuffix() throws -> SimpleClassType? {
        if tryEat(char: ".") {
            return try tryParseSimpleClassTypeSignature()
        }
        return nil
    }
    
    /**
     *  SimpleClassTypeSignature:
     *     Identifier [TypeArguments]
     */
    func tryParseSimpleClassTypeSignature() throws -> SimpleClassType {
        let identifier = tryParseIdentifier()
        if identifier == nil {
            throw IOError.format
        }
        let arguments = try tryParseTypeArguments()
        
        return SimpleClassType(identifier: identifier!, arguments: arguments)

    }
    
    func tryParsePackageSpecifier() -> PackageSpecifier? {
        
        var identifiers = [String]()
        while reader.hasNext() {
            let startAt = reader.pos
            if let identifier = tryParseIdentifier() {
                if tryEat(char: "/") {
                    identifiers.append(identifier)
                    continue
                }
            }
            reader.pos = startAt
            break
        }
        
        if identifiers.count == 0 {
            return nil
        }
        
        return PackageSpecifier(identifiers: identifiers)
    }
    
    
    func tryParseTypeArguments() throws -> [TypeArgument] {
        var result = [TypeArgument]()
        if reader.hasNext() {
            let ch = reader.next()
            if ch == "<" {
                var isSuccess = false
                while reader.hasNext() {
                    if reader.next()! == ">" {
                        break
                    }
                    
                    _ = reader.prevous()
                    let argument = try tryParseTypeArgument()
                    if argument  != nil {
                        isSuccess = true
                        result.append(argument!)
                    }
                }
                
                if isSuccess == false {
                    throw IOError.format
                }
            } else {
                _ = reader.prevous()
            }
            
        }
        return result
    }
    
    func tryParseTypeArgument() throws -> TypeArgument? {
        if reader.hasNext() {
            var ch = reader.next()
            if ch == "*" {
                return TypeArgument(indicator: ch)
            } else {
                if ch != "+" && ch != "-"  {
                    _ = reader.prevous()
                    ch = nil
                }
                
                let type = try tryParseReferenceTypeSignature()
                if type == nil {
                    if ch != nil {
                        throw IOError.format
                    }
                    return nil
                }
                let result = TypeArgument(indicator: ch)
                result.parameter = type
                return result
            }
        }
        return nil
    }
    
    
    func tryParseIdentifiers() -> String? {
        var identifiers = [String]()
        while reader.hasNext() {
            let identifier = tryParseIdentifier()
            if identifier != nil {
                identifiers.append(identifier!)
                if reader.hasNext() {
                    let ch = reader.next()!
                    if ch == "/" {
                        continue
                    } else {
                        _ = reader.prevous()
                    }
                }
            }
            break
        }
        if identifiers.count == 0 {
            return nil
        } else {
            return identifiers.joined(separator: ".")
        }
    }
    
    func tryEat(char:Character) -> Bool {
        if reader.hasNext() {
            let ch = reader.next()!
            if ch == char {
                return true
            }
            _ = reader.prevous()
        }
        return false
    }
    
    // try to parse a identifier
    func tryParseIdentifier() -> String? {
        let startAt = reader.pos
        
        outerLoop: while reader.hasNext() {
            let ch = reader.next()!
            if Self.Chars.contains(ch) {
                continue
            } else {
                _ = reader.prevous()
                break outerLoop
            }
        }
        
        if reader.pos > startAt {
            return reader.substring(startAt: startAt + 1, endAt: reader.pos )
        } else {
            return nil
        }
    }
    
    
    /**
     * TypeParameter:
     *   Identifier ClassBound {InterfaceBound}
     *
     * ClassBound:
     *  : [ReferenceTypeSignature]
     *
     * InterfaceBound:
     *  : ReferenceTypeSignature
     */
    func tryParseTypeParameter() throws -> TypeParameter {
        let identifier = tryParseIdentifier()
        if identifier == nil {
            throw IOError.format
        }
        
        let classBound = try tryParseBound()
        var interfaceBounds = [JType]()
        while reader.hasNext() {
            if tryEat(char: ":") {
                _ = reader.prevous()
                let interfaceBound = try tryParseBound()
                if interfaceBound != nil {
                    interfaceBounds.append(interfaceBound!)
                    continue
                }
            }
            break
        }
        return TypeParameter(identifier: identifier!, classBound: classBound, interfaceBounds: interfaceBounds)
    }
    
    /**
     * TypeParameters:
     *   < TypeParameter {TypeParameter} >
     */
    func tryParseTypeParameters() throws -> [TypeParameter] {
        var result = [TypeParameter]()
        if tryEat(char: "<") {
            let typeParameter = try tryParseTypeParameter()
            result.append(typeParameter)
            while reader.hasNext() {
                if tryEat(char: ">") {
                    break
                }
                let typeParameter = try tryParseTypeParameter()
                result.append(typeParameter)
            }
        }
        return result
    }
    
    func tryParseBound() throws -> JType? {
        if tryEat(char: ":") {
            let type = try tryParseReferenceTypeSignature()
            if type != nil {
                return type
            }
        }
        return nil
    }
}

/**
 * A field signature encodes the (possibly parameterized) type of a field, formal parameter, or local variable declaration.
 */
public class FieldSignatureParser : SignatureParser {
    
    public func parse() throws -> JType {
        return try tryParseReferenceTypeSignature()!
    }
}

public class ClassSignatureParser : SignatureParser {
    
    public func parse() throws -> ClassSignature {
        let typeParameters = try tryParseTypeParameters()
        let superClass = try tryParseClassTypeSignature()
        var interfaces = [ClassType]()
        while reader.hasNext() {
            let interfaceType = try tryParseClassTypeSignature()
            interfaces.append(interfaceType!)
        }
        
        return ClassSignature(signature: signature,typeParamters: typeParameters, superclass: superClass!, interfaces: interfaces)
    }
}

// A method signature encodes type information about a (possibly generic) method declaration. It describes any type parameters of the method; the (possibly parameterized) types of any formal parameters; the (possibly parameterized) return type, if any; and the types of any exceptions declared in the method's throws clause.

public class MethodSignatureParser : SignatureParser {
    
    /**
     * MethodSignature:
     * [TypeParameters] ( {JavaTypeSignature} ) Result {ThrowsSignature}
     */
    public func parse() throws -> MethodSignature {
        let typeParameters = try tryParseTypeParameters()
        if tryEat(char: "(") == false {
            throw IOError.format
        }
        
        var parameters = [JType]()
        while reader.hasNext() {
            if tryEat(char: ")") {
                break
            }
            
            let type = try tryParseJavaType()
            parameters.append(type)
        }
        
        let result = try tryParseResult()
        
        let `throws` = try tryParseThrows()
        
        return MethodSignature(signature: signature, typeParameters: typeParameters, parameters: parameters, result: result, throws: `throws`)
    }
    
    /**
     * Result:
     *  JavaTypeSignature
     *  VoidDescriptor
     */
    func tryParseResult() throws -> JType {
        if tryEat(char: "V") {
            return JType(raw: "V")
        } else {
            return try tryParseJavaType()
        }
    }
    
    func tryParseThrows() throws -> [JType] {
        var `throws` = [JType]()
        while tryEat(char: "^") {
            if let result = try tryParseTypeVariableSignature() {
                `throws`.append(result)
                continue
            }
            
            if let result = try tryParseClassTypeSignature() {
                `throws`.append(result)
                continue
            }
            
            throw IOError.format
        }
        return `throws`
    }
}
