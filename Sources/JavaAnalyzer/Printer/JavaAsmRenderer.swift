//
//  AsmRenderer.swift
//  Analyzer
//
//  Created by joyeer on 2024/12/12.
//

import Foundation
import Common

public class JavaAsmPrinter : CodePrinter {
    private var code:Class
    
    public init(_ class:Class) {
        code = `class`
    }
    
    public func generate() -> String {
        printJDKInfo()
        printSourceDebug()
        printEnclosingMethod()
        printInnerClasses()
        printClass()
        if let signautre = code.signature {
            print(classSignature: signautre)
        } else {
            printSuperClass()
            printInterfaces()
        }
        
        print(text: " {")
        newLine()
        resetTab(count: 1)
        printFields()
        printMethods()
        if code.fields.count == 0 && code.methods.count == 0 {
            newLine()
        }
        newLine()
        decTab()
        print(text: "}")
        newLine()
        return output.joined()
    }
        
    private func printClass() {
        
        if let signature = code.signature {
            print(comment: "# class signature: \(signature.signature)")
            newLine()
        }
        
        //print the annotation
        if code.annotations.count > 0 {
            print(annotations: code.annotations)
            newLine()
        }
        
        // print class name
        let accessFlag = code.accessFlags.description
        if accessFlag.count > 0 {
            print(keyword: accessFlag)
            space()
        }
        if code.accessFlags.isInterface {
            print(keyword: "interface")
        } else if code.accessFlags.isEnum {
            print(keyword: "enum")
        } else if code.accessFlags.isAnnotation {
            print(keyword: "@interface")
        } else {
            print(keyword: "class")
        }
        
        space()
        print(text: code.name)
    }
    
    // print the super class information
    private func printSuperClass() {
        if code.accessFlags.isInterface || code.accessFlags.isEnum || code.accessFlags.isAnnotation {
            return
        }
        newLine()
        incTab()
        print(keyword: "extends")
        space()
        print(type: "L\(code.superclass);")
    }
    
    // print the interfaces information
    private func printInterfaces() {
        if code.interfaces.count > 0 {
            newLine()
            if code.accessFlags.isInterface || code.accessFlags.isEnum || code.accessFlags.isAnnotation {
                incTab()
                print(keyword: "extends")
            } else {
                print(keyword: "implements")
            }
            
            for (index, interface) in code.interfaces.enumerated() {
                if index == 0 {
                    space()
                    print(type: "L\(interface);")
                } else {
                    print(text: ",")
                    newLine()
                    resetTab(count: 2)
                    print(type: "L\(interface);")
                }
            }
            space()
        }
    }
    
    //MARK:- Fields
    private func printFields() {
        if code.fields.count > 0 {
            for field in code.fields {
                newLine()
                printField(field)
            }
        }
    }
    
    private func printField(_ field:Field) {
        if let signature = field.signature {
            print(comment: "# field signature: \(signature.signature)")
            newLine()
        }
        if field.annotations.count > 0 {
            print(annotations: field.annotations)
            newLine()
        }
        print(keyword: field.accessFlags.description)
        space()
        if let signature = field.signature {
            print(typeWithTypeParams: signature.type)
        } else {
            print(type: field.type.descriptor)
        }
        
        space()
        print(text: field.name)
        
        if let constantValue = field.constantValue {
            space()
            print(text: "=")
            space()
            switch field.type.fullDescription  {
            case "java.lang.String", "String":
                print(string: constantValue)
            default:
                print(text: constantValue)
            }
        }
        newLine()
    }
    
    //MARK:- Methods
    private func printMethods() {
        if code.methods.count > 0 {
            newLine()
            for method in code.methods {
                newLine()
                printMethod(method)
            }
        }
    }
    
    /// print the method disassemble information
    private func printMethod(_ method: Method) {
        
        if let methodSignature = method.signature {
            print(comment: "# method signature: \(methodSignature.signature)")
            newLine()
        }
        
        // print the annotations
        if method.annotations.count > 0 {
            print(annotations: method.annotations)
            newLine()
        }
        
        if method.accessFlags.description.count > 0 {
            print(keyword:  method.accessFlags.description)
            space()
        }
        
        if let signature = method.signature {
            // print the generic information
            if signature.typeParameters.count > 0 {
                print(text: "<")
                for typeParameter in signature.typeParameters {
                    print(typeParameter: typeParameter)
                }
                print(text: ">")
                space()
            }
        }
 
        // print the method 's return type, and Constructor will ignore it
        if code.name != method.name {
            if let signature = method.signature {
                print(typeWithTypeParams: signature.result)
            }  else {
                print(type: method.return.descriptor)
            }
            space()
        }
        print(text: method.name)
        print(text: "(")
        
        /// Parameters parts
        if let signaure = method.signature {
            for (index, parameter) in signaure.parameters.enumerated() {
                if index > 0 {
                    print(text: ", ")
                }
                print(typeWithTypeParams: parameter)
            }
        } else {
            // print the method's parameters information
            for (index, parameter) in method.parameters.enumerated() {
                if index > 0 {
                    print(text: ", ")
                }
                print(type: parameter.type.descriptor)
            }
        }
        
        print(text: ")")
        
        if method.throws.count > 0 {
            print(keyword: " throws ")
            
            for (index, `throw`) in method.throws.enumerated() {
                if index > 0 {
                    print(text: ", ")
                }
                print(type: "L\(`throw`.descriptor);")
            }
        }
        print(text: ";")
        
        // If the method is not abstract method, we will have the code body
        if !method.accessFlags.isAbstract && !method.accessFlags.isNative {
            newLine()
            incTab()
            print(keyword: ".code")
            newLine()
            decTab()
            
            // TODO: refine the code logic
            for opcode in method.code!.opcodes {
                incTab()
                print(lineNumber: opcode.offset)
                space()
                // For printing the lookupswitch
                if opcode.code == OP_LOOKUPSWITCH || opcode.code == OP_TABLESWITCH {
                    
                    print(opcode: JVM_OPCODE_MAP[opcode.code]!)
                    space()
                    print(text: " { ")
                    print(comment: "// " + String(opcode.pairs.count))
                    newLine()
                    incTab()
                    for pair in opcode.pairs {
                        
                        var match = String(String(pair.match).reversed()).padding(toLength: 8, withPad: " ", startingAt: 0)
                        match = String(match.reversed())
                        print(text: String(match))
                        space()
                        print(branch: pair.jump)
                        newLine()
                    }
                    
                    // default
                    var offset = String(String("default").reversed()).padding(toLength: 8, withPad: " ", startingAt: 0)
                    offset = String(offset.reversed())
                    print(keyword: offset)
                    print(branch: opcode.value)
                    
                    newLine()
                    decTab()
                    print(text: "}")
                } else {
                    opcode.print(printer: self, ownerClass: code)
                }
                newLine()
                decTab()
            }
        }
        newLine()
    }
    
    
    /// MARK:- Annotation
    func print(annotations: [Annotation]) {
        for (index, annotation) in annotations.enumerated() {
            if index > 0 {
                newLine()
            }
            print(annotation: annotation)
        }
    }
    
    func print(annotation: Annotation) {
        print(text: "@")
        print(type: annotation.type.descriptor)
        if annotation.values.count > 0 {
            print(text: "(" )
            newLine()
            incTab()
            
            for (index, elementValuePair) in annotation.values.enumerated() {
                if index > 0 {
                    print(text: ",")
                    newLine()
                }
                print(name: elementValuePair.name, value: elementValuePair.value)
            }
            
            newLine()
            decTab()
            print(text: ")")
        }
    }
    
    func print(name: String , value: ElementValue) {
        print(text: name)
        print(text: " = ")
        print(value: value)
    }
    
    func print(value: ElementValue) {
        switch value {
        case let value as ConstValueElementValue:
            switch value.tag {
            case "B", "C", "I", "S":
                print(number: String(value.value as! Int32))
            case "J":
                print(number: String(value.value as! Int64))
            case "D":
                print(number: String(value.value as! Double))
            case "F":
                print(number: String(value.value as! Float))
            case "Z":
                print(keyword: value.value as! Int32 == 0 ? "false": "true")
            case "s":
                print(string: value.value as! String)
            default:
                fatalError()
            }
        case let value as EnumConstValueElementValue:
            print(type: value.typeName)
            print(text: ".")
            print(text: value.constName)
        case let value as ClassInfoElementValue:
            print(type: value.classInfo.descriptor)
            print(text: ".")
            print(keyword: "class")
        case let value as ArrayValueElementValue:
            print(text: "{")
            if value.values.count > 0 {
                newLine()
                incTab()
                for (index, element) in value.values.enumerated() {
                    if index > 0 {
                        print(text: ",")
                        newLine()
                    }
                    print(value: element)
                }
                newLine()
                decTab()
            }
            print(type: "}")
        case let value as AnnonationElementValue:
            print(annotation: value.annotation)
        default:
            break
        }
    }
    
    public override func print(type: String) {
        switch type {
        case "void", "boolean", "false", "true", "int", "float", "double":
            super.print(keyword: type)
        default:
            super.print(type: type)
        }
    }
    
    public func print(classSignature: ClassSignature) {
        for typeParameter in classSignature.typeParameters {
            print(typeParameter: typeParameter)
        }
        newLine()
        print(keyword: "extends")
        space()
        print(typeWithTypeParams: classSignature.superclass)
        resetTab(count: 1)
        
        if classSignature.interfaces.count > 0 {
            
            newLine()
            if code.accessFlags.isInterface || code.accessFlags.isAnnotation {
                print(keyword: "extends")
            } else {
                print(keyword: "implements")
            }
            
            for (index, interface) in classSignature.interfaces.enumerated() {
                if index == 0 {
                    space()
                    print(typeWithTypeParams: interface)
                    resetTab(count: 1)
                } else {
                    print(text: ",")
                    newLine()
                    resetTab(count: 2)
                    print(typeWithTypeParams: interface)
                }
            }
        }
        
        space()
        
    }
    
    private func print(typeParameter: TypeParameter) {
        print(text: "<")
        print(text: typeParameter.identifier)
        
        if let classBound = typeParameter.classBound {
            space()
            print(keyword: "extends")
            space()
            print(typeWithTypeParams: classBound)
        }
        
        for (index, interfaceBound) in typeParameter.interfaceBounds.enumerated() {
            if index == 0 {
                if typeParameter.classBound != nil {
                    print(text: " & ")
                } else {
                    space()
                    print(keyword: "extends")
                    space()
                }
            } else {
                print(text: " & ")
            }
            
            print(typeWithTypeParams: interfaceBound)
        }
        print(text: ">")
    }
    
    private func printEnclosingMethod() {
        if let enclosingMethod = code.enclosingMethodDecl {
            print(comment: ".EnclosingMethod:  ")
            print(type:"L\(enclosingMethod.enclosingClass);")
            
            if let methodName = enclosingMethod.enclosingMethod {
                print(comment: ".\(methodName)")
            }
            
            if let descriptor = enclosingMethod.enclosingMethodDescriptor {
                print(text: "(")
                for (index, param) in descriptor.parameters.enumerated() {
                    if index > 0 {
                        print(text: ", ")
                    }
                    print(type: param.descriptor)
                }
                print(text: ")")
            }
            
            newLine()
            newLine()
        }
    }
    
    
    private func printInnerClasses() {
        if code.innerClasses.count > 0 {
            print(comment: ".InnerClasses:  ")
            print(text: "[")
            newLine()
            incTab()
            
            for (index, innerClass) in code.innerClasses.enumerated() {
                if index > 0 {
                    print(text: ",")
                    newLine()
                }
                print(text: "{")
                newLine()
                incTab()
                
                if let outerClass = innerClass.outerClass {
                    print(text: "outer-class: ")
                    print(type: "L\(outerClass.descriptor);")
                    newLine()
                }
                
                if let innerClass = innerClass.innerClass {
                    print(text: "inner-class: ")
                    print(type: "L\(innerClass.descriptor);")
                    newLine()
                }
                
                if innerClass.innerClassName.isEmpty == false {
                    print(text: "name: ")
                    print(type: innerClass.innerClassName)
                    newLine()
                }
                
                if innerClass.innerClassAccessFlags.description.isEmpty == false {
                    print(text: "access-flags: ")
                    print(type: innerClass.innerClassAccessFlags.description)
                    newLine()
                }
                
                decTab()
                print(type: "}")
            }
            newLine()
            decTab()
            print(text: "]")
            newLine()
            newLine()
        }
    }
    
    private func printSourceDebug() {
        if let sourceDebugInfo = code.sourceDebugInfo {
            print(comment: "# debug info: \(sourceDebugInfo)")
            newLine()
        }
    }
    
    ///MARK:- JDK info
    private func printJDKInfo() {
        print(comment: "# class version \(code.classfile.major_version).\(code.classfile.minor_version)")
        newLine()
        
        switch
        code.classfile.major_version {
        case 45:
            print(comment: "# JDK 1.0.2 or JDK 1.1")
        case 46:
            print(comment: "# JDK 1.2")
        case 47:
            print(comment: "# JDK 1.3")
        case 48:
            print(comment: "# JDK 1.4")
        case 49:
            print(comment: "# JDK 5.0")
        case 50:
            print(comment: "# JDK 6")
        case 51:
            print(comment: "# JDK 7")
        case 52:
            print(comment: "# JDK 8")
        case 53:
            print(comment: "# JDK 9")
        case 54:
            print(comment: "# JDK 10")
        case 55:
            print(comment: "# JDK 11")
        case 56:
            print(comment: "# JDK 12")
        case 57:
            print(comment: "# JDK 13")
        default:
            print(comment: "# JDK unknown")
        }
        
        if let sourcefile = code.sourcefile {
            newLine()
            print(comment: "# Compiled from: \(sourcefile)")
        }
        newLine()
        newLine()
    }
    
    func print(typeWithTypeParams: JType) {
        switch typeWithTypeParams {
        case let objectType as ObjectType:
            print(type: typeWithTypeParams.descriptor)
            if objectType.typeParams.count > 0 {
                print(text: "<")
                for (index, typeParam) in objectType.typeParams.enumerated() {
                    if index > 0 {
                        print(text: ", ")
                    }
                    
                    if typeParam.indicator == "*" {
                        print(text: "?")
                    } else if typeParam.indicator == "-" {
                        print(text: "?")
                        print(keyword: "super")
                        space()
                        print(typeWithTypeParams: typeParam.parameter!)
                    } else if typeParam.indicator == "+" {
                        print(text: "?")
                        print(keyword: "super")
                        space()
                        print(typeWithTypeParams: typeParam.parameter!)
                    } else {
                        print(typeWithTypeParams: typeParam.parameter!)
                    }
                }
                print(text: ">")
            }
        case let classType as ClassType:
            print(type: classType.descriptor)
        default:
            print(type: typeWithTypeParams.descriptor)
        }
    }
    
}
 
