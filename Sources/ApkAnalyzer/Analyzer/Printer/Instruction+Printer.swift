//
//  Instruction+Printer.swift
//  
//
//  Created by Joyeer on 2019/12/4.
//

import Foundation
import Common

extension Instruction {
    public func print(printer: CodePrinter, table:Table, method: Method) {
        if let opcode = DalvikOpcode(rawValue: self.opcode) {
            printer.print(lineNumber: offset)
            
            if opcode == .INSN_NOP, let payload = payload {
                print(payload: payload, printer: printer)
                return
            }
            
            printer.print(opcode: opcode.description)
            printer.space()
            
            switch getFormat() {
            case .Format_10x:
                break
            case .Format_12x:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                print(register: vB, method: method, printer: printer)
            case .Format_11n:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                printer.print(number: "\(vB.getHexString())")
            case .Format_11x:
                print(register: vA, method: method, printer: printer)
            case .Format_10t:    // goto
                printer.print(branch: offset + vA * 2)
            case .Format_20t:   // goto/16
                printer.print(branch: offset + vA * 2)
            case .Format_30t:   // goto/32
                printer.print(branch: offset + vA * 2)
            case .Format_20bc:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                printer.print(text: "kind@\(vB)") //TODO: improve the output
                fatalError()
            case .Format_22x:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                print(register: vB, method: method, printer: printer)
            case .Format_21t:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                switch opcode {
                case .INSN_IF_EQZ,
                     .INSN_IF_NEZ,
                     .INSN_IF_LTZ,
                     .INSN_IF_GEZ,
                     .INSN_IF_GTZ,
                     .INSN_IF_LEZ:
                    
                    printer.print(branch: offset + vB * 2 )
                default:
                    fatalError()
                }
                
            case .Format_21s:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                printer.print(number: "\(vB.getHexString())")
            case .Format_21h:                   // TODO: improve the output format
                print(register: vA, method: method, printer: printer)
                printer.comma()
                switch opcode {
                case .INSN_CONST_HIGH16:
                    printer.print(number: "\(vB.getHexString())0000")
                case .INSN_CONST_WIDE_HIGH16:
                    printer.print(number: "\(vB.getHexString())000000000000")
                default:
                    fatalError()
                }
                
            case .Format_21c:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                switch opcode {
                case .INSN_NEW_INSTANCE:
                    printer.print(text: "\(table.types[vB])")
                case .INSN_CONST_STRING:
                    printer.print(string: (table.strings[vB]))
                case .INSN_SGET,
                     .INSN_SGET_WIDE,
                     .INSN_SGET_OBJECT,
                     .INSN_SGET_BOOLEAN,
                     .INSN_SGET_BYTE,
                     .INSN_SGET_CHAR,
                     .INSN_SGET_SHORT,
                     .INSN_SPUT,
                     .INSN_SPUT_WIDE,
                     .INSN_SPUT_OBJECT,
                     .INSN_SPUT_BOOLEAN,
                     .INSN_SPUT_BYTE,
                     .INSN_SPUT_CHAR,
                     .INSN_SPUT_SHORT:
                    let field = table.fields[vB]
                    printer.print(text: "\(field.definer)->\(field.name):\(field.type)")
                case .INSN_CHECK_CAST:
                    let type = table.types[vB]
                    printer.print(text: type)
                case .INSN_CONST_CLASS:
                    let type = table.types[vB]
                    printer.print(text: type)
                default:
                    fatalError()
                }
                
            case .Format_23x:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                print(register: vB, method: method, printer: printer)
                printer.comma()
                print(register: vC, method: method, printer: printer)
            case .Format_22b:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                print(register: vB, method: method, printer: printer)
                printer.comma()
                printer.print(number: "\(vC.getHexString())")
            case .Format_22t:
                // if-test vA, vB, +CCCC
                // 32: if-eq
                // 33: if-ne
                // 34: if-lt
                // 35: if-ge
                // 36: if-gt
                // 37: if-le
                
                print(register: vA, method: method, printer: printer)
                printer.comma()
                print(register: vB, method: method, printer: printer)
                printer.comma()
                printer.print(branch: offset + vC * 2)
            case .Format_22s:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                print(register: vB, method: method, printer: printer)
                printer.comma()
                printer.print(number: "\(vC.getHexString())")
            case .Format_22c:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                print(register: vB, method: method, printer: printer)
                printer.comma()
                
                switch opcode {
                case .INSN_IGET,
                     .INSN_IGET_WIDE,
                     .INSN_IGET_OBJECT,
                     .INSN_IGET_BOOLEAN,
                     .INSN_IGET_BYTE,
                     .INSN_IGET_CHAR,
                     .INSN_IGET_SHORT,
                     .INSN_IPUT,
                     .INSN_IPUT_WIDE,
                     .INSN_IPUT_OBJECT,
                     .INSN_IPUT_BOOLEAN,
                     .INSN_IPUT_BYTE,
                     .INSN_IPUT_CHAR,
                     .INSN_IPUT_SHORT:
                    let type = table.fields[vC]
                    printer.print(text: "\(type.definer)->\(type.name):\(type.type)")
                case .INSN_NEW_ARRAY,
                     .INSN_INSTANCE_OF:
                    let type = table.types[vC]
                    printer.print(text: "\(type)")
                    
                default:
                    fatalError()
                }
                
            case .Format_22cs:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                print(register: vB, method: method, printer: printer)
                printer.comma()
                printer.print(text: "fieldoff@\(vC)") //TODO: improve the format
                fatalError()
            case .Format_32x:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                print(register: vB, method: method, printer: printer)
            case .Format_31i:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                printer.print(number: vB.getHexString())
            case .Format_31t:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                printer.print(branch: vB * 2 + offset)
            case .Format_35c:
                let argCount  = vA
                printer.print(text: "{")
                if argCount > 0 {
                    print(register: vC, method: method, printer: printer)
                }
                if argCount > 1 {
                    printer.comma()
                    print(register: vD, method: method, printer: printer)
                }
                if argCount > 2 {
                    printer.comma()
                    print(register: vE, method: method, printer: printer)
                }
                if argCount > 3 {
                    printer.comma()
                    print(register: vF, method: method, printer: printer)
                }
                if argCount > 4 {
                    printer.comma()
                    print(register: vG, method: method, printer: printer)
                }
                printer.print(text: "}")
                printer.comma()
                switch opcode {
                case .INSN_INVOKE_DIRECT,
                    .INSN_INVOKE_VIRTUAL,
                    .INSN_INVOKE_SUPER,
                    .INSN_INVOKE_STATIC,
                    .INSN_INVOKE_INTERFACE:
                    
                    let method = table.methods[vB]
                    printer.print(text: method.classType)
                    printer.print(text: "->")
                    printer.print(text: method.name)
                    printer.print(text: "(")
                    for parameter in method.proto.parameterTypes {
                        printer.print(text: parameter)
                    }
                    printer.print(text: ")")
                    printer.print(text: method.proto.returnType)
                case .INSN_FILLED_NEW_ARRAY:
                    let type = table.types[vB]
                    printer.print(text: "\(type)")
                default:
                    fatalError()
                }
            case .Format_35ms:// TODO:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                fatalError()
            case .Format_35mi:// TODO:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                fatalError()
            case .Format_3rc:// TODO:
                switch opcode {
                case .INSN_INVOKE_VIRTUAL_RANGE,
                     .INSN_INVOKE_DIRECT_RANGE,
                     .INSN_INVOKE_SUPER_RANGE,
                     .INSN_INVOKE_STATIC_RANGE,
                     .INSN_INVOKE_INTERFACE_RANGE:
                    printer.print(text: "{")
                    print(register: vC, method: method, printer: printer)
                    printer.print(text: " .. ")
                    print(register: vA + vC - 1, method: method, printer: printer)
                    printer.print(text: "}")
                    printer.comma()
                    
                    let method = table.methods[vB]
                    printer.print(text: "\(method.classType)->\(method.name)->\(method.proto.description)")
                    
                case .INSN_FILLED_NEW_ARRAY_RANGE:
                    printer.print(text: "{")
                    print(register: vC, method: method, printer: printer)
                    printer.print(text: " .. ")
                    print(register: vA + vC - 1, method: method, printer: printer)
                    printer.print(text: "}")
                    printer.comma()
                   
                    let type = table.types[vB]
                    printer.print(text: "\(type)")
                default:
                    fatalError()
                }
            case .Format_3rms:// TODO:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                fatalError()
            case .Format_3rmi:// TODO:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                fatalError()
            case .Format_45cc:// TODO:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                fatalError()
            case .Format_4rcc:// TODO:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                fatalError()
            case .Format_51l:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                printer.print(number: vB.getHexString())
            case .Format_31c:
                print(register: vA, method: method, printer: printer)
                printer.comma()
                printer.print(string: table.strings[vB])
                fatalError()
            }
        }
        printer.newLine()
    }
    
    func print(register: Int, method: Method, printer: CodePrinter) {
        guard  let code = method.code else {
            fatalError()
        }
        let parameterCount = method.accessFlag.isStatic ? method.parameters.count : (method.parameters.count + 1)
        if register <  (code.registers - parameterCount) {
            printer.print(register: "v\(register)")
        } else {
            printer.print(register: "p\(register - (code.registers - parameterCount))")
        }
    
    }
    
    public func print(payload:Any, printer: CodePrinter) {
        switch payload {
        case let payload as SparseSwitchPayload:
            printer.print(keyword: ".sparse-switch")
            printer.newLine()
            printer.incTab()
            printer.incTab()
            printer.incTab()
            
            for (index,target) in payload.targets.enumerated() {
                let key = payload.keys[index]
                printer.print(number: Int(key).getHexString())
                printer.space()
                printer.print(text: "->")
                printer.space()
                printer.print(branch: Int(target) * 2)
                printer.newLine()
            }

            printer.print(keyword: ".end sparse-switch")
        case let payload as PackedSwitchPayload:
            printer.print(keyword: ".packed-switch")
            printer.space()
            printer.print(number: Int(payload.firstKey).getHexString())
            printer.newLine()
            printer.incTab()
            printer.incTab()
            printer.incTab()
            for branch in payload.targets {
                printer.print(branch: Int(branch) * 2)
                printer.newLine()
            }
            printer.print(keyword: ".end packed-switch")
        case let payload as FillArrayDataPayload:
            printer.print(keyword: ".array-data")
            printer.newLine()
            printer.incTab()
            printer.incTab()
            printer.incTab()
            let reader = DataInputStream(Data(payload.data), litteEndian: true)
            for _ in 0 ..< payload.size {
                do {
                    switch payload.elementWidth {
                    case 1:
                        printer.print(number: Int(try reader.readU()).getHexString())
                    case 2:
                        printer.print(number: Int(try reader.readU2()).getHexString())
                    case 4:
                        printer.print(number: Int(try reader.readU4()).getHexString())
                    default:
                        fatalError()
                    }
                    printer.newLine()
                } catch {
                    fatalError()
                }
            }
            printer.print(keyword: ".end array-data")
        default:
            break
        }
        printer.decTab()
        printer.newLine()
        printer.decTab()
        printer.decTab()
    }
}


