//
//  File.swift
//  
//
//  Created by Joyeer on 2020/1/4.
//

import Foundation
import Common

extension Value {
    func print(printer: CodePrinter, table: Table) {
        switch UInt8(type) {
        case EncodedValue.VALUE_BYTE,
             EncodedValue.VALUE_SHORT,
             EncodedValue.VALUE_CHAR,
             EncodedValue.VALUE_INT,
             EncodedValue.VALUE_LONG:
            let intValue = Int("\(value!)")!
            printer.print(number: intValue.getHexString())
        case EncodedValue.VALUE_FLOAT:
            guard let floatValue = value as? Float  else {
                fatalError()
            }
            printer.print(number: "\(floatValue)")
        case EncodedValue.VALUE_DOUBLE:
            guard let doubleValue = value as? Double else {
                fatalError()
            }
            printer.print(number: "\(doubleValue)")
        case EncodedValue.VALUE_STRING:
            let index = Int("\(value!)")!
            printer.print(string: table.strings[index])
        case EncodedValue.VALUE_ARRAY:
            guard let valueArray = value as? [Value] else {
                fatalError()
            }
            
            printer.print(text: "{")
            printer.newLine()
            printer.incTab()
            for v in valueArray {
                v.print(printer: printer, table: table)
                printer.newLine()
            }
            printer.decTab()
            printer.print(text: "}")
        case EncodedValue.VALUE_TYPE:
            let index = Int("\(value!)")!
            printer.print(text: table.types[index])
        case EncodedValue.VALUE_ENUM:
            let index = Int("\(value!)")!
            printer.print(keyword: ".enum")
            printer.space()
            let field = table.fields[index]
            printer.print(text: "\(field.definer)->\(field.name):\(field.type)")
        case EncodedValue.VALUE_METHOD:
            let index = Int("\(value!)")!
            let method = table.methods[index]
            printer.print(text: method.classType)
            printer.print(text: "->")
            printer.print(text: method.name)
            printer.print(text: "(")
            for parameter in method.proto.parameterTypes {
                printer.print(text: parameter)
            }
            printer.print(text: ")")
            printer.print(text: method.proto.returnType)
        case EncodedValue.VALUE_NULL:
            printer.print(keyword: "null")
        case EncodedValue.VALUE_ANNOTATION:
            guard let subAnnotation = value as? Annotation else {
                fatalError()
            }
            
            printer.newLine()
            printer.incTab()
            subAnnotation.print(printer: printer, table: table)
            printer.decTab()
            
        case EncodedValue.VALUE_BOOLEAN:
            printer.print(keyword: "\(value!)")
        case EncodedValue.VALUE_METHOD_TYPE:
            fatalError()
        case EncodedValue.VALUE_METHOD_HANDLE:
            fatalError()
        default:
            fatalError()
        }
    }
}
