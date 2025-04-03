//
//  File.swift
//  
//
//  Created by Joyeer on 2019/11/30.
//
import Foundation
import Common

class OpcodeAnalyzer {
    
    private(set) var instructions = [Instruction]()
    
    func analyze(codeItem: CodeItem) throws {
        let reader = DataInputStream(Data(bytes: codeItem.insns, count: codeItem.insns.count), litteEndian: true)
        
        while reader.hasBytesAvailable {
            let position = reader.position
            let byte = try reader.readU()
            guard let opcode = DalvikOpcode(rawValue: Int(byte)) else {
                continue
            }
            
            if opcode == .INSN_NOP {
                if reader.hasBytesAvailable == false {
                    break
                }
                var payload: Any? = nil
                switch try reader.readU() {
                case 1:
                    payload = try PackedSwitchPayload(reader)
                case 2:
                    payload = try SparseSwitchPayload(reader)
                case 3:
                    payload = try FillArrayDataPayload(reader)
                default:
                    reader.previous()        
                }
                
                if payload != nil {
                    let payloadInstruction = Instruction(offset: position, opcode: Int(byte), raws: [], payload: payload)
                    instructions.append(payloadInstruction)
                    continue
                }
            }
            
            reader.previous()
            let rows = try reader.readBytes(InstructionFormat.getFormat(opcode: opcode).length())
            let instruction = Instruction(offset: position, opcode: Int(byte), raws: rows)
            instructions.append(instruction)
        }
    }
}
