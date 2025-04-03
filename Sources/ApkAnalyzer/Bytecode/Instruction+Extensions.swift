//
//  Instruction.swift
//
//
//  Created by Joyeer on 2019/12/2.
//

import Common

extension Instruction {
    
    fileprivate func getByte(position:Int) -> Int {
        return Int(raws[position])
    }
    
    fileprivate func getSByte(position: Int) -> Int {
        return Int(Int8(bitPattern: raws[position]))
    }
    
    fileprivate func getSByte(position: Int, lowOrHigh: Bool) -> Int {
        let byte = Int8(bitPattern: raws[position])
        if lowOrHigh {
            return Int((byte << 4) >> 4)
        } else {
            return Int(byte >> 4)
        }
    }
    
    fileprivate func getByte(position:Int, lowOrHigh: Bool) -> Int {
        let byte = raws[position]
        if lowOrHigh {
            return Int((byte << 4) >> 4)
        } else {
            return Int(byte >> 4)
        }
    }
    
    fileprivate func getInt16(position:Int) -> Int {
        return Int(Int16(bitPattern: (UInt16(raws[position + 1]) << 8) | UInt16(raws[position])))
    }
    
    fileprivate func getUInt16(position:Int) -> Int {
        return Int((UInt16(raws[position + 1]) << 8) | UInt16(raws[position]))
    }
    
    fileprivate func getInt32(position: Int) -> Int {
        let b1 = UInt32(raws[position])
        let b2 = UInt32(raws[position + 1])
        let b3 = UInt32(raws[position + 2])
        let b4 = UInt32(raws[position + 3])
        return Int(Int32(bitPattern:(b4 << 24 | b3 << 16 | b2 << 8 | b1)))
    }
    
    fileprivate func getUInt32(position: Int) -> Int {
       let b1 = UInt32(raws[position])
       let b2 = UInt32(raws[position + 1])
       let b3 = UInt32(raws[position + 2])
       let b4 = UInt32(raws[position + 3])
       return Int(b4 << 24 | b3 << 16 | b2 << 8 | b1)
   }
    
    fileprivate func getLong(position: Int) -> Int {
        let low = getUInt32(position: position)
        let high = getUInt32(position: position + 4)
        return Int(high << 32 | low)
    }
    
    func getFormat() -> InstructionFormat {
        let dalvikOpcode = DalvikOpcode(rawValue: opcode)
        return InstructionFormat.getFormat(opcode: dalvikOpcode!)
    }
}


extension Instruction {
    
    var vA: Int {
        switch getFormat() {
        case .Format_12x, .Format_11n:
            return getByte(position: 1, lowOrHigh: true)
        case .Format_11x, .Format_10x:
            return getByte(position: 1)
        case .Format_20t:
            return getInt16(position: 2)
        case .Format_20bc, .Format_22x, .Format_21t, .Format_21s, .Format_21h, .Format_21c:
            return getByte(position: 1)
        case .Format_23x, .Format_22b:
            return getByte(position: 1)
        case .Format_22t, .Format_22s, .Format_22c, .Format_22cs:
            return getByte(position: 1, lowOrHigh: true)
        case .Format_30t:
            return getInt32(position: 2)
        case .Format_32x:
            return getInt16(position: 3)
        case .Format_31i, .Format_31t, .Format_31c:
            return getByte(position: 1)
        case .Format_35c, .Format_35ms, .Format_35mi:
            return getByte(position: 1, lowOrHigh: false)
        case .Format_3rc, .Format_3rms, .Format_3rmi:
            return getByte(position: 1)
        case .Format_45cc:
            return getByte(position: 1, lowOrHigh: true)
        case .Format_4rcc:
            return getByte(position: 1)
        case .Format_51l:
            return getByte(position: 1)
        case .Format_10t:
            return getSByte(position: 1)
        }
    }
    
    var vB: Int {
        switch getFormat() {
        case .Format_12x:
            return getByte(position: 1, lowOrHigh: false)
        case .Format_11n:
            return getSByte(position: 1, lowOrHigh: false)
        case .Format_20bc,
             .Format_22x,
             .Format_21t,
             .Format_21s,
             .Format_21h:
            return getInt16(position: 2)
        case .Format_21c:
            return getUInt16(position: 2)
        case .Format_23x:
            return getByte(position: 2)
        case .Format_22b:
            return getByte(position: 2)
        case .Format_22t, .Format_22s, .Format_22c, .Format_22cs:
            return getByte(position: 1, lowOrHigh: false)
        case .Format_32x:
            return getInt16(position: 4)
        case .Format_31t:
            return getInt32(position: 2)
        case .Format_31c:
            return getUInt32(position: 2)
        case .Format_31i:
            return getUInt32(position: 2)
        case .Format_35ms, .Format_35mi, .Format_3rms, .Format_3rmi, .Format_45cc, .Format_4rcc:
            return getInt16(position: 2)
        case .Format_35c:
            return getUInt16(position: 2)
        case .Format_3rc:
            return getUInt16(position: 2)
        case .Format_51l:
            return getLong(position: 2)
        default:
            fatalError()
        }
    }
    
    var vC: Int {
        switch getFormat() {
        case .Format_23x:
            return getByte(position: 3)
        case .Format_22b:
            return getSByte(position: 3)
        case .Format_22s:
            return getInt16(position: 2)
        case .Format_22c, .Format_22cs:
            return getUInt16(position: 2)
        case .Format_22t:
            return getInt16(position: 2)
        case .Format_35ms, .Format_35mi:
            return getByte(position: 4, lowOrHigh: true)
        case .Format_35c:
            return getByte(position: 4, lowOrHigh: true)
        case .Format_3rc, .Format_3rms, .Format_3rmi:
            return getInt16(position: 4)
        case .Format_45cc:
            return getByte(position: 4, lowOrHigh: true)
        case .Format_4rcc:
            return getInt16(position: 4)
        default:
            fatalError()
        }
    }
    
    var vD: Int {
        switch getFormat() {
        case .Format_35ms, .Format_35mi:
            return getByte(position: 4, lowOrHigh: false)
        case .Format_35c:
            return getByte(position: 4, lowOrHigh: false)
        case .Format_45cc:
            return getByte(position: 4, lowOrHigh: false)
        default:
            fatalError()
        }
    }
    
    var vE: Int {
        switch getFormat() {
        case .Format_35ms, .Format_35mi:
            return getByte(position: 5, lowOrHigh: true)
        case .Format_35c:
            return getByte(position: 5, lowOrHigh: true)
        case .Format_45cc:
            return getByte(position: 5, lowOrHigh: true)
        default:
            fatalError()
        }
    }
    
    var vF: Int {
        switch getFormat() {
        case .Format_35ms, .Format_35mi:
            return getByte(position: 5, lowOrHigh: false)
        case .Format_35c:
            return getByte(position: 5, lowOrHigh: false)
        case .Format_45cc:
            return getByte(position: 5, lowOrHigh: true)
        default:
            fatalError()
        }
    }
    
    var vG: Int {
        switch getFormat() {
        case .Format_45cc, .Format_4rcc:
            return getInt16(position: 6)
        case .Format_35c:
            return getByte(position: 1, lowOrHigh: true)
        default:
            fatalError()
        }
    }
    
}
