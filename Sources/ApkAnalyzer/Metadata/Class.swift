//
//  Class.swift
//  DecompileAndroid
//
//  Created by Qing Xu on 2019/10/3.
//

import Foundation

public struct Class {
    
    public let accessflag: AccessFlag
    public let classType: TypeDescriptor
    public let superType: TypeDescriptor
    public let interfaceTypes: [TypeDescriptor]
    
    public let staticFields: [Field]
    public let instanceFields: [Field]
    public let directMethods: [Method]
    public let virtualMethods: [Method]
    
    public let sourceFile:String
    public let annotations: [Annotation]
    public let fieldAnnotations: [Int: [Annotation]]
    public let methodAnnotations: [Int: [Annotation]]
    public let parameterAnnotations: [Int: [[Annotation]?]]
    public let table: Table
    
    public init(accessflag: AccessFlag,
                classType: TypeDescriptor,
                superType: TypeDescriptor,
                interfaceTypes: [TypeDescriptor],
                staticFields:[Field],
                instanceFields:[Field],
                directMethods: [Method],
                virtualMethods: [Method],
                sourceFile:String,
                annotations: [Annotation],
                fieldAnnotations: [Int: [Annotation]],
                methodAnnotations: [Int: [Annotation]],
                parameterAnnotations: [Int: [[Annotation]?]],
                table: Table) {
        
        self.accessflag = accessflag
        self.classType = classType
        self.superType = superType
        self.interfaceTypes = interfaceTypes
        self.staticFields = staticFields
        self.instanceFields = instanceFields
        self.directMethods = directMethods
        self.virtualMethods = virtualMethods
        self.sourceFile = sourceFile
        self.annotations = annotations
        self.fieldAnnotations = fieldAnnotations
        self.methodAnnotations = methodAnnotations
        self.parameterAnnotations = parameterAnnotations
        self.table = table
    }
}
