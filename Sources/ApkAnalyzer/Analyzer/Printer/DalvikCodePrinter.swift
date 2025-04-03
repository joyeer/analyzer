//
//  DalvikCodeGenerator.swift
//  CodeAnalyzer
//
//  Created by Joyeer on 2019/11/26.
//  Copyright © 2019 decompile.io. All rights reserved.
//
import Foundation
import Common

public class DalvikCodeCreator: CodePrinter {
    
    var table: Table!
    var curMethod: Method? = nil
    
    public func render(_ `class`: Class) -> String {
        self.table = `class`.table
        print(comment: "#class declaration")
        newLine()
        render(header: `class`)
        render(super: `class`)
        if !`class`.sourceFile.isEmpty {
            render(source: `class`)
        }
        render(interfaces: `class`)
        render(classAnnotations: `class`.annotations)
        render(fields: `class`)
        render(methods: `class`)
        return output.joined()
    }
    
    
    // MARK:- Rendering
    // render the header
    func render(header `class`:Class) {
        
        print(keyword: ".class")
        space()
        if !`class`.accessflag.description.isEmpty {
            print(keyword: `class`.accessflag.description)
            space()
        }
        print(identifier: `class`.classType.rawValue)
        newLine()
    }
    
    func render(super `class`:Class) {
        print(keyword: ".super")
        space()
        print(identifier: `class`.superType.rawValue)
        newLine()
    }
    
    func render(source `class`:Class) {
        print(keyword: ".source")
        space()
        print(string: `class`.sourceFile)
        newLine()
    }
    
    func render(interfaces `class`: Class) {
        if `class`.interfaceTypes.count > 0 {
            newLine()
            print(comment: "# interfaces")
            newLine()
            for interface in `class`.interfaceTypes {
                print(keyword: ".implements")
                space()
                print(identifier: interface.rawValue)
                newLine()
            }
        }
    }
    
    func render(classAnnotations: [Annotation]) {
        if classAnnotations.count > 0 {
            newLine()
            print(comment: "# annotations")
            newLine()
            
            for annotation in classAnnotations {
                annotation.print(printer: self, table: table)
                newLine()
            }
        }
    }
    
    // MARK:- Field
    func render(fields `class`: Class) {
        if `class`.staticFields.count > 0 {
            newLine()
            print(comment: "# static fields")
            newLine()
            _ = `class`.staticFields.map { field in
                render(field: field, class: `class`)
            }
        }
        
        if `class`.instanceFields.count > 0 {
            newLine()
            print(comment: "# instance fields")
            newLine()
            _ = `class`.instanceFields.map { field in
                render(field: field, class:`class`)
            }
        }
    }
    
    func render(field: Field, `class`:Class) {
        print(keyword: ".field")
        space()
        print(keyword: field.accessFlag.description)
        space()
        print(identifier: field.name)
        print(identifier: ":")
        print(identifier: field.type)
        newLine()
        if let annotations = `class`.fieldAnnotations[field.index] {
            
            incTab()
            for annotation in annotations {
                annotation.print(printer: self, table: table)
            }
            decTab()
            print(keyword: ".end field")
            newLine()
        }
        newLine()
    }
    
    // MARK:- Method
    func render(methods `class`: Class) {
        if `class`.directMethods.count > 0 {
            newLine()
            print(comment: "# direct methods")
            newLine()
            _ = `class`.directMethods.map { method in
                render(method: method, class: `class`)
                newLine()
            }
        }
        
        if `class`.virtualMethods.count > 0 {
            newLine()
            print(comment: "# virtual methods")
            newLine()
            _ = `class`.virtualMethods.map { method in
                render(method: method, class: `class`)
                newLine()
            }
        }
    }
    
    func render(method: Method, `class`:Class) {
        curMethod = method
        print(keyword: ".method")
        space()
        print(keyword: method.accessFlag.description)
        space()
        if method.accessFlag.isConstructor {
            print(keyword: "constructor")
            space()
        }
        print(identifier: method.name)
        print(identifier: ":")
        space()
        print(identifier: "(")
        for param in method.parameters {
            print(identifier: param)
        }
        print(identifier: ")")
        print(identifier: method.returnType)
        newLine()
        
        if let annotations = `class`.methodAnnotations[method.index] {
            // print the method annotations
            incTab()
            for annotation in annotations {
                annotation.print(printer: self, table: table)
            }
            decTab()
            newLine()
        }
        
        var paramIndex = method.accessFlag.isStatic ? 0 : 1
        
        for (index, parameter) in method.parameterNames.enumerated() {
            incTab()
            if !parameter.isEmpty {
                print(keyword: ".param")
                space()
                print(identifier: "p\(paramIndex)")
                comma()
                print(string: parameter)
                newLine()
                
                if let paramAnnotationsDict = `class`.parameterAnnotations[method.index],
                    paramAnnotationsDict.count > index,
                    let paramAnnotations = paramAnnotationsDict[index],
                    paramAnnotations.count > 0 {
                    incTab()
                    paramAnnotations.forEach { annotation in
                        annotation.print(printer: self, table: table)
                    }
                    decTab()
                    print(keyword: ".end param")
                    newLine()
                
                }
            }
            
            paramIndex += 1
            decTab()
        }
        
        
        if let code = method.code {
            incTab()
            // print the register
            print(keyword: ".registers")
            space()
            print(identifier: "\(code.registers)")
            newLine()
            newLine()
            print(keyword: ".prologue")
            newLine()
            
            for instruction in code.instructions {
                instruction.print(printer: self, table: table, method: method)
            }
            newLine()
            decTab()
        }
        
        print(keyword: ".end method")
        newLine()
    }

}
