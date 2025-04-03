//
//  ClassSignature.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/7/18.
//

import Common


public class TypeParameter {
    public var identifier: String
    public var classBound: JType?
    public var interfaceBounds: [JType]
    
    init(identifier: String, classBound:JType?, interfaceBounds:[JType] ) {
        self.identifier = identifier
        self.classBound = classBound
        self.interfaceBounds = interfaceBounds
    }
    
    public var description: String {
        var classes = [String]()
        if classBound != nil && classBound!.description != "java.lang.Object" {
            classes.append(classBound!.description)
        }
        
        for interface in interfaceBounds {
            classes.append(interface.description)
        }
        
        if classes.count > 0 {
            return identifier + " extends " + classes.joined(separator: " & ")
        } else {
            return identifier
        }
    }
    
}

public class ClassSignature  {
    
    public let signature: String
    public let typeParameters :[TypeParameter]
    public let superclass: JType
    public let interfaces: [ClassType]
    
    init(signature: String, typeParamters: [TypeParameter], superclass:JType, interfaces:[ClassType]) {
        self.typeParameters = typeParamters
        self.superclass = superclass
        self.interfaces = interfaces
        self.signature = signature
    }
    
    public var genericDescription: String? {
        return ClassSignature.formatTypeParameters(typeParameters: typeParameters)
    }
    
    public class func formatTypeParameters(typeParameters: [TypeParameter]) -> String? {
        var result = [String]()
        for typeParameter in typeParameters {
            result.append(typeParameter.description)
        }
        if result.count > 0 {
            return "<" + result.joined(separator: ", ") + ">"
        } else {
            return nil
        }
    }
}
