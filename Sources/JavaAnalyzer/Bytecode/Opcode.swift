//
//  Opcode.swift
//  JavaDecompiler
//
//  Created by joyeer on 04/03/2018.
//

import Foundation
public let OP_NOP:UInt8 = 0x00
public let OP_ACONST_NULL:UInt8 = 0x01
public let OP_ICONST_M1:UInt8 = 0x02
public let OP_ICONST_0:UInt8 = 0x03
public let OP_ICONST_1:UInt8 = 0x04
public let OP_ICONST_2:UInt8 = 0x05
public let OP_ICONST_3:UInt8 = 0x06
public let OP_ICONST_4:UInt8 = 0x07
public let OP_ICONST_5:UInt8 = 0x08
public let OP_LCONST_0:UInt8 = 0x09
public let OP_LCONST_1:UInt8 = 0x0A
public let OP_FCONST_0:UInt8 = 0x0B
public let OP_FCONST_1:UInt8 = 0x0C
public let OP_FCONST_2:UInt8 = 0x0D
public let OP_DCONST_0:UInt8 = 0x0E
public let OP_DCONST_1:UInt8 = 0x0F
public let OP_BIPUSH:UInt8 = 0x10
public let OP_SIPUSH:UInt8 = 0x11
public let OP_LDC:UInt8 = 0x12
public let OP_LDC_W:UInt8 = 0x13
public let OP_LDC2_W:UInt8 = 0x14
public let OP_ILOAD:UInt8 = 0x15
public let OP_LLOAD:UInt8 = 0x16
public let OP_FLOAD:UInt8 = 0x17
public let OP_DLOAD:UInt8 = 0x18
public let OP_ALOAD:UInt8 = 0x19
public let OP_ILOAD_0:UInt8 = 0x1A
public let OP_ILOAD_1:UInt8 = 0x1B
public let OP_ILOAD_2:UInt8 = 0x1C
public let OP_ILOAD_3:UInt8 = 0x1D
public let OP_LLOAD_0:UInt8 = 0x1E
public let OP_LLOAD_1:UInt8 = 0x1F
public let OP_LLOAD_2:UInt8 = 0x20
public let OP_LLOAD_3:UInt8 = 0x21
public let OP_FLOAD_0:UInt8 = 0x22
public let OP_FLOAD_1:UInt8 = 0x23
public let OP_FLOAD_2:UInt8 = 0x24
public let OP_FLOAD_3:UInt8 = 0x25
public let OP_DLOAD_0:UInt8 = 0x26
public let OP_DLOAD_1:UInt8 = 0x27
public let OP_DLOAD_2:UInt8 = 0x28
public let OP_DLOAD_3:UInt8 = 0x29
public let OP_ALOAD_0:UInt8 = 0x2A
public let OP_ALOAD_1:UInt8 = 0x2B
public let OP_ALOAD_2:UInt8 = 0x2C
public let OP_ALOAD_3:UInt8 = 0x2D
public let OP_IALOAD:UInt8 = 0x2E
public let OP_LALOAD:UInt8 = 0x2F
public let OP_FALOAD:UInt8 = 0x30
public let OP_DALOAD:UInt8 = 0x31
public let OP_AALOAD:UInt8 = 0x32
public let OP_BALOAD:UInt8 = 0x33
public let OP_CALOAD:UInt8 = 0x34
public let OP_SALOAD:UInt8 = 0x35
public let OP_ISTORE:UInt8 = 0x36
public let OP_LSTORE:UInt8 = 0x37
public let OP_FSTORE:UInt8 = 0x38
public let OP_DSTORE:UInt8 = 0x39
public let OP_ASTORE:UInt8 = 0x3A
public let OP_ISTORE_0:UInt8 = 0x3B
public let OP_ISTORE_1:UInt8 = 0x3C
public let OP_ISTORE_2:UInt8 = 0x3D
public let OP_ISTORE_3:UInt8 = 0x3E
public let OP_LSTORE_0:UInt8 = 0x3F
public let OP_LSTORE_1:UInt8 = 0x40
public let OP_LSTORE_2:UInt8 = 0x41
public let OP_LSTORE_3:UInt8 = 0x42
public let OP_FSTORE_0:UInt8 = 0x43
public let OP_FSTORE_1:UInt8 = 0x44
public let OP_FSTORE_2:UInt8 = 0x45
public let OP_FSTORE_3:UInt8 = 0x46
public let OP_DSTORE_0:UInt8 = 0x47
public let OP_DSTORE_1:UInt8 = 0x48
public let OP_DSTORE_2:UInt8 = 0x49
public let OP_DSTORE_3:UInt8 = 0x4A
public let OP_ASTORE_0:UInt8 = 0x4B
public let OP_ASTORE_1:UInt8 = 0x4C
public let OP_ASTORE_2:UInt8 = 0x4D
public let OP_ASTORE_3:UInt8 = 0x4E
public let OP_IASTORE:UInt8 = 0x4F
public let OP_LASTORE:UInt8 = 0x50
public let OP_FASTORE:UInt8 = 0x51
public let OP_DASTORE:UInt8 = 0x52
public let OP_AASTORE:UInt8 = 0x53
public let OP_BASTORE:UInt8 = 0x54
public let OP_CASTORE:UInt8 = 0x55
public let OP_SASTORE:UInt8 = 0x56
public let OP_POP:UInt8 = 0x57
public let OP_POP2:UInt8 = 0x58
public let OP_DUP:UInt8 = 0x59
public let OP_DUP_X1:UInt8 = 0x5A
public let OP_DUP_X2:UInt8 = 0x5B
public let OP_DUP2:UInt8 = 0x5C
public let OP_DUP2_X1:UInt8 = 0x5D
public let OP_DUP2_X2:UInt8 = 0x5E
public let OP_SWAP:UInt8 = 0x5F
public let OP_IADD:UInt8 = 0x60
public let OP_LADD:UInt8 = 0x61
public let OP_FADD:UInt8 = 0x62
public let OP_DADD:UInt8 = 0x63
public let OP_ISUB:UInt8 = 0x64
public let OP_LSUB:UInt8 = 0x65
public let OP_FSUB:UInt8 = 0x66
public let OP_DSUB:UInt8 = 0x67
public let OP_IMUL:UInt8 = 0x68
public let OP_LMUL:UInt8 = 0x69
public let OP_FMUL:UInt8 = 0x6A
public let OP_DMUL:UInt8 = 0x6B
public let OP_IDIV:UInt8 = 0x6C
public let OP_LDIV:UInt8 = 0x6D
public let OP_FDIV:UInt8 = 0x6E
public let OP_DDIV:UInt8 = 0x6F
public let OP_IREM:UInt8 = 0x70
public let OP_LREM:UInt8 = 0x71
public let OP_FREM:UInt8 = 0x72
public let OP_DREM:UInt8 = 0x73
public let OP_INEG:UInt8 = 0x74
public let OP_LNEG:UInt8 = 0x75
public let OP_FNEG:UInt8 = 0x76
public let OP_DNEG:UInt8 = 0x77
public let OP_ISHL:UInt8 = 0x78
public let OP_LSHL:UInt8 = 0x79
public let OP_ISHR:UInt8 = 0x7A
public let OP_LSHR:UInt8 = 0x7B
public let OP_IUSHR:UInt8 = 0x7C
public let OP_LUSHR:UInt8 = 0x7D
public let OP_IAND:UInt8 = 0x7E
public let OP_LAND:UInt8 = 0x7F
public let OP_IOR:UInt8 = 0x80
public let OP_LOR:UInt8 = 0x81
public let OP_IXOR:UInt8 = 0x82
public let OP_LXOR:UInt8 = 0x83
public let OP_IINC:UInt8 = 0x84
public let OP_I2L:UInt8 = 0x85
public let OP_I2F:UInt8 = 0x86
public let OP_I2D:UInt8 = 0x87
public let OP_L2I:UInt8 = 0x88
public let OP_L2F:UInt8 = 0x89
public let OP_L2D:UInt8 = 0x8A
public let OP_F2I:UInt8 = 0x8B
public let OP_F2L:UInt8 = 0x8C
public let OP_F2D:UInt8 = 0x8D
public let OP_D2I:UInt8 = 0x8E
public let OP_D2L:UInt8 = 0x8F
public let OP_D2F:UInt8 = 0x90
public let OP_I2B:UInt8 = 0x91
public let OP_I2C:UInt8 = 0x92
public let OP_I2S:UInt8 = 0x93
public let OP_LCMP:UInt8 = 0x94
public let OP_FCMPL:UInt8 = 0x95
public let OP_FCMPG:UInt8 = 0x96
public let OP_DCMPL:UInt8 = 0x97
public let OP_DCMPG:UInt8 = 0x98
public let OP_IFEQ:UInt8 = 0x99
public let OP_IFNE:UInt8 = 0x9A
public let OP_IFLT:UInt8 = 0x9B
public let OP_IFGE:UInt8 = 0x9C
public let OP_IFGT:UInt8 = 0x9D
public let OP_IFLE:UInt8 = 0x9E
public let OP_IF_ICMPEQ:UInt8 = 0x9F
public let OP_IF_ICMPNE:UInt8 = 0xA0
public let OP_IF_ICMPLT:UInt8 = 0xA1
public let OP_IF_ICMPGE:UInt8 = 0xA2
public let OP_IF_ICMPGT:UInt8 = 0xA3
public let OP_IF_ICMPLE:UInt8 = 0xA4
public let OP_IF_ACMPEQ:UInt8 = 0xA5
public let OP_IF_ACMPNE:UInt8 = 0xA6
public let OP_GETSTATIC:UInt8 = 0xB2
public let OP_PUTSTATIC:UInt8 = 0xB3
public let OP_GETFIELD:UInt8 = 0xB4
public let OP_PUTFIELD:UInt8 = 0xB5
public let OP_INVOKEVIRTUAL:UInt8 = 0xB6
public let OP_INVOKESPECIAL:UInt8 = 0xB7
public let OP_INVOKESTATIC:UInt8 = 0xB8
public let OP_INVOKEINTERFACE:UInt8 = 0xB9
public let OP_INVOKEDYNAMIC:UInt8 = 0xBA
public let OP_NEW:UInt8 = 0xBB
public let OP_NEWARRAY:UInt8 = 0xBC
public let OP_ANEWARRAY:UInt8 = 0xBD
public let OP_ARRAYLENGTH:UInt8 = 0xBE
public let OP_ATHROW:UInt8 = 0xBF
public let OP_CHECKCAST:UInt8 = 0xC0
public let OP_INSTANCEOF:UInt8 = 0xC1
public let OP_MONITORENTER:UInt8 = 0xC2
public let OP_MONITOREXIT:UInt8 = 0xC3
public let OP_GOTO:UInt8 = 0xA7
public let OP_JSR:UInt8 = 0xA8
public let OP_RET:UInt8 = 0xA9
public let OP_TABLESWITCH:UInt8 = 0xAA
public let OP_LOOKUPSWITCH:UInt8 = 0xAB
public let OP_IRETURN:UInt8 = 0xAC
public let OP_LRETURN:UInt8 = 0xAD
public let OP_FRETURN:UInt8 = 0xAE
public let OP_DRETURN:UInt8 = 0xAF
public let OP_ARETURN:UInt8 = 0xB0
public let OP_RETURN:UInt8 = 0xB1
public let OP_WIDE:UInt8 = 0xC4
public let OP_MULTIANEWARRAY:UInt8 = 0xC5
public let OP_IFNULL:UInt8 = 0xC6
public let OP_IFNONNULL:UInt8 = 0xC7
public let OP_GOTO_W:UInt8 = 0xC8
public let OP_JSR_W:UInt8 = 0xC9
public let OP_BREAKPOINT:UInt8 = 0xCA
public let OP_IMPDEP1:UInt8 = 0xFE
public let OP_IMPDEP2:UInt8 = 0xFF

internal let JVM_OPCODE_MAP:[UInt8: String] = [
    0x00: "nop",
    0x01: "aconst_null",
    0x02: "iconst_m1",
    0x03: "iconst_0",
    0x04: "iconst_1",
    0x05: "iconst_2",
    0x06: "iconst_3",
    0x07: "iconst_4",
    0x08: "iconst_5",
    0x09: "lconst_0",
    0x0a: "lconst_1",
    0x0b: "fconst_0",
    0x0c: "fconst_1",
    0x0d: "fconst_2",
    0x0e: "dconst_0",
    0x0f: "dconst_1",
    0x10: "bipush",
    0x11: "sipush",
    0x12: "ldc",
    0x13: "ldc_w",
    0x14: "ldc2_w",
    0x15: "iload",
    0x16: "lload",
    0x17: "fload",
    0x18: "dload",
    0x19: "aload",
    0x1a: "iload_0",
    0x1b: "iload_1",
    0x1c: "iload_2",
    0x1d: "iload_3",
    0x1e: "lload_0",
    0x1f: "lload_1",
    0x20: "lload_2",
    0x21: "lload_3",
    0x22: "fload_0",
    0x23: "fload_1",
    0x24: "fload_2",
    0x25: "fload_3",
    0x26: "dload_0",
    0x27: "dload_1",
    0x28: "dload_2",
    0x29: "dload_3",
    0x2a: "aload_0",
    0x2b: "aload_1",
    0x2c: "aload_2",
    0x2d: "aload_3",
    0x2e: "iaload",
    0x2f: "laload",
    0x30: "faload",
    0x31: "daload",
    0x32: "aaload",
    0x33: "baload",
    0x34: "caload",
    0x35: "saload",
    0x36: "istore",
    0x37: "lstore",
    0x38: "fstore",
    0x39: "dstore",
    0x3a: "astore",
    0x3b: "istore_0",
    0x3c: "istore_1",
    0x3d: "istore_2",
    0x3e: "istore_3",
    0x3f: "lstore_0",
    0x40: "lstore_1",
    0x41: "lstore_2",
    0x42: "lstore_3",
    0x43: "fstore_0",
    0x44: "fstore_1",
    0x45: "fstore_2",
    0x46: "fstore_3",
    0x47: "dstore_0",
    0x48: "dstore_1",
    0x49: "dstore_2",
    0x4a: "dstore_3",
    0x4b: "astore_0",
    0x4c: "astore_1",
    0x4d: "astore_2",
    0x4e: "astore_3",
    0x4f: "iastore",
    0x50: "lastore",
    0x51: "fastore",
    0x52: "dastore",
    0x53: "aastore",
    0x54: "bastore",
    0x55: "castore",
    0x56: "sastore",
    0x57: "pop",
    0x58: "pop2",
    0x59: "dup",
    0x5a: "dup_x1",
    0x5b: "dup_x2",
    0x5c: "dup2",
    0x5d: "dup2_x1",
    0x5e: "dup2_x2",
    0x5f: "swap",
    0x60: "iadd",
    0x61: "ladd",
    0x62: "fadd",
    0x63: "dadd",
    0x64: "isub",
    0x65: "lsub",
    0x66: "fsub",
    0x67: "dsub",
    0x68: "imul",
    0x69: "lmul",
    0x6a: "fmul",
    0x6b: "dmul",
    0x6c: "idiv",
    0x6d: "ldiv",
    0x6e: "fdiv",
    0x6f: "ddiv",
    0x70: "irem",
    0x71: "lrem",
    0x72: "frem",
    0x73: "drem",
    0x74: "ineg",
    0x75: "lneg",
    0x76: "fneg",
    0x77: "dneg",
    0x78: "ishl",
    0x79: "lshl",
    0x7a: "ishr",
    0x7b: "lshr",
    0x7c: "iushr",
    0x7d: "lushr",
    0x7e: "iand",
    0x7f: "land",
    0x80: "ior",
    0x81: "lor",
    0x82: "ixor",
    0x83: "lxor",
    0x84: "iinc",
    0x85: "i2l",
    0x86: "i2f",
    0x87: "i2d",
    0x88: "l2i",
    0x89: "l2f",
    0x8a: "l2d",
    0x8b: "f2i",
    0x8c: "f2l",
    0x8d: "f2d",
    0x8e: "d2i",
    0x8f: "d2l",
    0x90: "d2f",
    0x91: "i2b",
    0x92: "i2c",
    0x93: "i2s",
    0x94: "lcmp",
    0x95: "fcmpl",
    0x96: "fcmpg",
    0x97: "dcmpl",
    0x98: "dcmpg",
    0x99: "ifeq",
    0x9a: "ifne",
    0x9b: "iflt",
    0x9c: "ifge",
    0x9d: "ifgt",
    0x9e: "ifle",
    0x9f: "if_icmpeq",
    0xa0: "if_icmpne",
    0xa1: "if_icmplt",
    0xa2: "if_icmpge",
    0xa3: "if_icmpgt",
    0xa4: "if_icmple",
    0xa5: "if_acmpeq",
    0xa6: "if_acmpne",
    0xb2: "getstatic",
    0xb3: "putstatic",
    0xb4: "getfield",
    0xb5: "putfield",
    0xb6: "invokevirtual",
    0xb7: "invokespecial",
    0xb8: "invokestatic",
    0xb9: "invokeinterface",
    0xba: "invokedynamic",
    0xbb: "new",
    0xbc: "newarray",
    0xbd: "anewarray",
    0xbe: "arraylength",
    0xbf: "athrow",
    0xc0: "checkcast",
    0xc1: "instanceof",
    0xc2: "monitorenter",
    0xc3: "monitorexit",
    0xa7: "goto",
    0xa8: "jsr",
    0xa9: "ret",
    0xaa: "tableswitch",
    0xab: "lookupswitch",
    0xac: "ireturn",
    0xad: "lreturn",
    0xae: "freturn",
    0xaf: "dreturn",
    0xb0: "areturn",
    0xb1: "return",
    0xc4: "wide",
    0xc5: "multianewarray",
    0xc6: "ifnull",
    0xc7: "ifnonnull",
    0xc8: "goto_w",
    0xc9: "jsr_w",
    0xca: "breakpoint",
    0xfe: "impdep1",
    0xff: "impdep2"
]

let JVM_NAME_OPCODE_MAP:[String:UInt8] = {
    var mapping = [String:UInt8]()
    
    for (key, value) in JVM_OPCODE_MAP {
        mapping[value] = key
    }
    
    return mapping
}()

enum OpcodeKind {
    case nop
    case load
    case const
    case store
    case `throw`
    case push
    case checkcast
    case dup
    case getfield
    case getstatic
    case putfield
    case putstatic
    case pop
    case goto
    case `if`
    case inc
    case instanceof
    case invoke
    case unary
    case binary
    case jump_subroutine
    case load_constant
    case `return`
    case monitor
    case new
    case arraylength
    case swap
    case `switch`
}

typealias Pair = (match:Int, jump: Int)

public struct JOpcode {
    let kind: OpcodeKind
    let code: UInt8
    let offset: Int
    let value: Int
    let value2: Int
    let pairs: [Pair]
}


class OpcodeDecoder {
    
    private let code: [UInt8]
    var scan = -1
    init(_ code: [UInt8]) {
        self.code = code
    }
    
    func decode() throws -> [JOpcode] {
        var result = [JOpcode]()
        while hasNext() {
            let code = next()
            let kind: OpcodeKind
            let offset = scan
            var value: Int = 0
            var value2: Int = 0
            var pairs: [Pair] = []
            switch (code) {
            case OP_NOP:
                kind = .nop
            case OP_AALOAD, OP_FALOAD, OP_IALOAD, OP_SALOAD, OP_BALOAD, OP_CALOAD, OP_LALOAD, OP_DALOAD:
                kind = .load
            case OP_LLOAD:
                kind = .load
                value = Int(next())
            case OP_LLOAD_0:
                kind = .load
                value = 0
            case OP_LLOAD_1:
                kind = .load
                value = 1
            case OP_LLOAD_2:
                kind = .load
                value = 2
            case OP_LLOAD_3:
                kind = .load
                value = 3
            case OP_ILOAD:
                kind = .load
                value = Int(next())
            case OP_ILOAD_0:
                kind = .load
                value = 0
            case OP_ILOAD_1:
                kind = .load
                value = 1
            case OP_ILOAD_2:
                kind = .load
                value = 2
            case OP_ILOAD_3:
                kind = .load
                value = 3
            case OP_ALOAD:
                kind = .load
                value = Int(next())
            case OP_ALOAD_0:
                kind = .load
                value = 0
            case OP_ALOAD_1:
                kind = .load
                value = 1
            case OP_ALOAD_2:
                kind = .load
                value = 2
            case OP_ALOAD_3:
                kind = .load
                value = 3
            case OP_DLOAD:
                kind = .load
                value = Int(next())
            case OP_DLOAD_0:
                kind = .load
                value = 0
            case OP_DLOAD_1:
                kind = .load
                value = 1
            case OP_DLOAD_2:
                kind = .load
                value = 2
            case OP_DLOAD_3:
                kind = .load
                value = 3
            case OP_FLOAD:
                kind = .load
                value = Int(next())
            case OP_FLOAD_0:
                kind = .load
                value = 0
            case OP_FLOAD_1:
                kind = .load
                value = 1
            case OP_FLOAD_2:
                kind = .load
                value = 2
            case OP_FLOAD_3:
                kind = .load
                value = 3
            case OP_ACONST_NULL:
                kind = .const
                value = 0
            case OP_DCONST_0:
                kind = .const
                value = 0
            case OP_DCONST_1:
                kind = .const
                value = 1
            case OP_ICONST_0:
                kind = .const
                value = 0
            case OP_ICONST_1:
                kind = .const
                value = 1
            case OP_ICONST_2:
                kind = .const
                value = 2
            case OP_ICONST_3:
                kind = .const
                value = 3
            case OP_ICONST_4:
                kind = .const
                value = 4
            case OP_ICONST_5:
                kind = .const
                value = 5
            case OP_ICONST_M1:
                kind = .const
                value = -1
            case OP_FCONST_0:
                kind = .const
                value = 0
            case OP_FCONST_1:
                kind = .const
                value = 1
            case OP_FCONST_2:
                kind = .const
                value = 2
            case OP_LCONST_0:
                kind = .const
                value = 0
            case OP_LCONST_1:
                kind = .const
                value = 0
            case OP_BASTORE, OP_IASTORE,OP_SASTORE,OP_CASTORE,OP_FASTORE,OP_AASTORE,OP_LASTORE,OP_DASTORE:
                kind = .store
            case OP_ASTORE:
                kind = .store
                value = Int(next())
            case OP_ASTORE_0:
                kind = .store
                value = 0
            case OP_ASTORE_1:
                kind = .store
                value = 1
            case OP_ASTORE_2:
                kind = .store
                value = 2
            case OP_ASTORE_3:
                kind = .store
                value = 3
            case OP_DSTORE:
                kind = .store
                value = Int(next())
            case OP_DSTORE_0:
                kind = .store
                value = 0
            case OP_DSTORE_1:
                kind = .store
                value = 1
            case OP_DSTORE_2:
                kind = .store
                value = 2
            case OP_DSTORE_3:
                kind = .store
                value = 3
            case OP_ISTORE:
                kind = .store
                value = Int(next())
            case OP_ISTORE_0:
                kind = .store
                value = 0
            case OP_ISTORE_1:
                kind = .store
                value = 1
            case OP_ISTORE_2:
                kind = .store
                value = 2
            case OP_ISTORE_3:
                kind = .store
                value = 3
            case OP_LSTORE:
                kind = .store
                value = Int(next())
            case OP_LSTORE_0:
                kind = .store
                value = 0
            case OP_LSTORE_1:
                kind = .store
                value = 1
            case OP_LSTORE_2:
                kind = .store
                value = 2
            case OP_LSTORE_3:
                kind = .store
                value = 3
            case OP_FSTORE:
                kind = .store
                value = Int(next())
            case OP_FSTORE_0:
                kind = .store
                value = 0
            case OP_FSTORE_1:
                kind = .store
                value = 1
            case OP_FSTORE_2:
                kind = .store
                value = 2
            case OP_FSTORE_3:
                kind = .store
                value = 3
            case OP_ATHROW:
                kind = .throw
            case OP_BIPUSH:
                kind = .push
                value = Int(next())
            case OP_SIPUSH:
                kind = .push
                value = Int(nextInt16())
            case OP_CHECKCAST:
                kind = .checkcast
                value = Int(nextInt16())
            case OP_I2L,OP_I2F,OP_I2D,OP_L2I,OP_L2F,OP_L2D,OP_F2I,OP_F2L,OP_F2D,OP_D2I,OP_D2L,OP_D2F,OP_I2B,OP_I2C,OP_I2S:
                kind = .checkcast
            case OP_DNEG,OP_LNEG,OP_FNEG,OP_INEG:
                kind = .unary
            case OP_DUP,OP_DUP_X1,OP_DUP_X2,OP_DUP2,OP_DUP2_X1,OP_DUP2_X2:
                kind = .dup
            case OP_GETFIELD:
                kind = .getfield
                value = nextInt16()
            case OP_GETSTATIC:
                kind = .getstatic
                value = nextInt16()
            case OP_GOTO:
                kind = .goto
                value = nextInt16()
            case OP_GOTO_W:
                kind = .goto
                value = nextInt()
            case OP_IF_ACMPEQ,OP_IF_ACMPNE,OP_IF_ICMPEQ,OP_IF_ICMPNE,OP_IF_ICMPLT,OP_IF_ICMPGE,OP_IF_ICMPGT,OP_IF_ICMPLE,OP_IFEQ,OP_IFNE,OP_IFLT,OP_IFGE,OP_IFGT,OP_IFLE,OP_IFNONNULL,OP_IFNULL:
                kind = .`if`
                value = nextInt16()
                break
            case OP_IINC:
                kind = .inc
                value = Int(next())
                value2 = Int(next())
                break
            case OP_INSTANCEOF:
                kind = .instanceof
                value = nextInt16()
            case OP_INVOKEDYNAMIC:
                kind = .invoke
                value = nextInt16()
                let value3 = next()
                let value4 = next()
                assert(value3 == 0)
                assert(value4 == 0)
            case OP_INVOKESPECIAL,OP_INVOKEVIRTUAL,OP_INVOKESTATIC:
                kind = .invoke
                value = nextInt16()
            case OP_INVOKEINTERFACE:
                kind = .invoke
                value = nextInt16()
                value2 = Int(next())
                let value3 = next()
                assert(value3 == 0)
            case OP_IOR,OP_LOR,OP_IXOR,OP_LXOR,OP_DDIV,OP_LDIV,OP_FDIV,OP_IDIV,OP_DMUL,OP_FMUL,OP_LMUL,OP_IMUL,OP_DREM,OP_FREM,OP_IREM,OP_LREM,OP_DSUB,OP_FSUB,OP_ISUB,OP_LSUB,OP_IADD,OP_DADD,OP_FADD,OP_LADD,OP_IAND,OP_LAND,OP_ISHL,OP_LSHL,OP_ISHR,OP_IUSHR,OP_LSHR,OP_LUSHR,OP_DCMPG,OP_DCMPL,OP_FCMPG,OP_FCMPL,OP_LCMP:
                kind = .binary
            case OP_JSR:
                kind = .jump_subroutine
                value = nextInt16()
            case OP_JSR_W:
                kind = .jump_subroutine
                value = nextInt()
            case OP_LDC:
                kind = .load_constant
                value = Int(next())
            case OP_LDC_W,OP_LDC2_W:
                kind = .load_constant
                value = nextInt16()
            case OP_LRETURN,OP_RETURN,OP_ARETURN,OP_DRETURN,OP_FRETURN,OP_IRETURN:
                kind = .return
            case OP_RET:
                kind = .return
                value = Int(next())
            case OP_MONITORENTER,OP_MONITOREXIT:
                kind = .monitor
            case OP_MULTIANEWARRAY:
                kind = .new
                value = nextInt16()
                value2 = Int(next())
            case OP_NEW,OP_ANEWARRAY:
                kind = .new
                value = nextInt16()
            case OP_NEWARRAY:
                kind = .new
                value = Int(next())
            case OP_POP,OP_POP2:
                kind = .pop
            case OP_PUTFIELD:
                kind = .putfield
                value = nextInt16()
            case OP_PUTSTATIC:
                kind = .putstatic
                value = nextInt16()
            case OP_SWAP:
                kind = .swap
            case OP_TABLESWITCH,OP_LOOKUPSWITCH:
                kind = .`switch`
                scan += 1
                let padding = scan % 4
                if(padding > 0) {
                    scan = scan  + ( 4 - padding)
                }
                scan -= 1
                value = nextInt()
                switch(code) {
                case OP_TABLESWITCH:
                    let low = nextInt()
                    let high = nextInt()
                    var _pairs = [Pair]()
                    for index in low ... high {
                        let jump = nextInt()
                        _pairs.append(Pair(match:index, jump:jump))
                    }
                    pairs = _pairs
                    
                case OP_LOOKUPSWITCH:
                    let npair = nextInt()
                    var _pairs = [Pair]()
                    for _ in 0 ..< npair {
                        let match = nextInt()
                        let jump = nextInt()
                        _pairs.append(Pair(match, jump))
                    }
                    pairs = _pairs
                default:
                    fatalError()
                }
            case OP_ARRAYLENGTH:
                kind = .arraylength
            default:
                fatalError()
            }
            
            result.append(JOpcode(kind: kind, code: code, offset: offset, value: value, value2: value2, pairs: pairs))
        }
        
        return result
    }
    
    private func hasNext() -> Bool {
        return (scan + 1) < code.count
    }
    
    private func next() -> UInt8 {
        scan += 1
        return code[scan]
    }
    
    private func nextInt8() -> Int8 {
        let result = next()
        return Int8(bitPattern: result)
    }
    
    private func nextInt16() -> Int {
        let indexbyte1 = next()
        let indexbyte2 = next()
        return Int(UInt16(indexbyte1) << 8 | UInt16(indexbyte2))
    }
    
    private func nextInt() -> Int {
        let byte1 = next()
        let byte2 = next()
        let byte3 = next()
        let byte4 = next()
        
        return Int(Int32(byte1) << 24 | Int32(byte2) << 16 | Int32(byte3) << 8 | Int32(byte4))
    }
    
    private func nextUInt() -> UInt {
        let byte1 = next()
        let byte2 = next()
        let byte3 = next()
        let byte4 = next()
        return UInt(UInt32(byte1) << 24 | UInt32(byte2) << 16 | UInt32(byte3) << 8 | UInt32(byte4))
    }
    
    private func cur() -> UInt8 {
        return code[scan]
    }

}

extension String {
    
    fileprivate func formatAsOpcode(text: String) -> String {
        return String(format: "%@ %@", padding(toLength: 20, withPad: " ", startingAt: 0), text)
    }
    
    // format the opcode with reference index
    // e.g. opcode         #20
    fileprivate func formatAsOpcode(reference: Int) -> String {
        return String(format: "%@ #%d", padding(toLength: 20, withPad: " ", startingAt: 0), reference)
    }
    
    // Format the opcode with index number
    // e.g. opcode      10
    fileprivate func formatAsOpcode(index: Int)  -> String {
        return String(format: "%@ %d", padding(toLength: 20, withPad: " ", startingAt: 0), index)
    }
    
    // Format the opcode with reference and index number
    // e.g. opcode      #10,    10
    fileprivate func formatAsOpcode(reference: Int, index: Int) -> String {
        return String(format: "%@ #%d,  %d", padding(toLength: 20, withPad: " ", startingAt: 0), reference, index)
    }
    
    // Format the opcode with index and index number
    // e.g. opcode      10,     10
    fileprivate func formatAsOpcode(firstIndex: Int, secondIndex: Int) -> String {
        return String(format: "%@ %d,  %d", padding(toLength: 20, withPad: " ", startingAt: 0), firstIndex, secondIndex)
    }
}
