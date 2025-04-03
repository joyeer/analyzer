//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/2.
//

import Foundation


enum InstructionFormat {
    case Format_10x                                                                 // ØØ|op
    case Format_12x, Format_11n                                                     // B|A|op
    case Format_11x, Format_10t                                                     // AA|op
    case Format_20t                                                                 // ØØ|op AAAA
    case Format_20bc, Format_22x, Format_21t, Format_21s, Format_21h, Format_21c    // AA|op BBBB
    case Format_23x, Format_22b                                                     // AA|op CC|BB
    case Format_22t, Format_22s, Format_22c, Format_22cs                            // B|A|op CCCC
    case Format_30t                                                                 // ØØ|op AAAAlo AAAAhi
    case Format_32x                                                                 // ØØ|op AAAA BBBB
    case Format_31i, Format_31t, Format_31c                                         // AA|op BBBBlo BBBBhi
    case Format_35c, Format_35ms, Format_35mi                                       // A|G|op BBBB F|E|D|C
    case Format_3rc, Format_3rms, Format_3rmi                                       // AA|op BBBB CCCC
    case Format_45cc                                                                // A|G|op BBBB F|E|D|C HHHH
    case Format_4rcc                                                                // AA|op BBBB CCCC HHHH
    case Format_51l                                                                 // AA|op BBBBlo BBBB BBBB BBBBhi
}

extension InstructionFormat {
    func length() -> Int {
        switch self {
        case .Format_10x, .Format_12x, .Format_11n, .Format_11x, .Format_10t:
            return 2
        case .Format_20t, .Format_20bc, .Format_22x, .Format_21t, .Format_21s, .Format_21h, .Format_21c,
             .Format_23x, .Format_22b,
             .Format_22t, .Format_22s, .Format_22c, .Format_22cs:
            return 4
        case .Format_30t,
             .Format_32x,
             .Format_31i, .Format_31t, .Format_31c,
             .Format_35c, .Format_35ms, .Format_35mi,
             .Format_3rc, .Format_3rms, .Format_3rmi:
            return 6
        case .Format_45cc, .Format_4rcc:
            return 8
        case .Format_51l:
            return 10
        }
    }
    
    // Opcode format
    static func getFormat(opcode: DalvikOpcode) -> InstructionFormat {
        switch opcode {
        case DalvikOpcode.INSN_NOP:
            return .Format_10x
        case DalvikOpcode.INSN_MOVE:
            return .Format_12x
        case DalvikOpcode.INSN_MOVE_FROM16:
            return .Format_22x
        case DalvikOpcode.INSN_MOVE_16:
            return .Format_32x
        case DalvikOpcode.INSN_MOVE_WIDE:
            return .Format_12x
        case DalvikOpcode.INSN_MOVE_WIDE_FROM16:
            return .Format_22x
        case DalvikOpcode.INSN_MOVE_WIDE_16:
            return .Format_32x
        case DalvikOpcode.INSN_MOVE_OBJECT:
            return .Format_12x
        case DalvikOpcode.INSN_MOVE_OBJECT_FROM16:
            return .Format_22x
        case DalvikOpcode.INSN_MOVE_OBJECT_16:
            return .Format_32x
        case DalvikOpcode.INSN_MOVE_RESULT:
            return .Format_11x
        case DalvikOpcode.INSN_MOVE_RESULT_WIDE:
            return .Format_11x
        case DalvikOpcode.INSN_MOVE_RESULT_OBJECT:
            return .Format_11x
        case DalvikOpcode.INSN_MOVE_EXCEPTION:
            return .Format_11x
        case DalvikOpcode.INSN_RETURN_VOID:
            return .Format_10x
        case DalvikOpcode.INSN_RETURN:
            return .Format_11x
        case DalvikOpcode.INSN_RETURN_WIDE:
            return .Format_11x
        case DalvikOpcode.INSN_RETURN_OBJECT:
            return .Format_11x
        case DalvikOpcode.INSN_CONST_4:
            return .Format_11n
        case DalvikOpcode.INSN_CONST_16:
            return .Format_21s
        case DalvikOpcode.INSN_CONST:
            return .Format_31i
        case DalvikOpcode.INSN_CONST_HIGH16:
            return .Format_21h
        case DalvikOpcode.INSN_CONST_WIDE_16:
            return .Format_21s
        case DalvikOpcode.INSN_CONST_WIDE_32:
            return .Format_31i
        case DalvikOpcode.INSN_CONST_WIDE:
            return .Format_51l
        case DalvikOpcode.INSN_CONST_WIDE_HIGH16:
            return .Format_21h
        case DalvikOpcode.INSN_CONST_STRING:
            return .Format_21c
        case DalvikOpcode.INSN_CONST_STRING_JUMBO:
            return .Format_31c
        case DalvikOpcode.INSN_CONST_CLASS:
            return .Format_21c
        case DalvikOpcode.INSN_MONITOR_ENTER:
            return .Format_11x
        case DalvikOpcode.INSN_MONITOR_EXIT:
            return .Format_11x
        case DalvikOpcode.INSN_CHECK_CAST:
            return .Format_21c
        case DalvikOpcode.INSN_INSTANCE_OF:
            return .Format_22c
        case DalvikOpcode.INSN_ARRAY_LENGTH:
            return .Format_12x
        case DalvikOpcode.INSN_NEW_INSTANCE:
            return .Format_21c
        case DalvikOpcode.INSN_NEW_ARRAY:
            return .Format_22c
        case DalvikOpcode.INSN_FILLED_NEW_ARRAY:
            return .Format_35c
        case DalvikOpcode.INSN_FILLED_NEW_ARRAY_RANGE:
            return .Format_3rc
        case DalvikOpcode.INSN_FILL_ARRAY_DATA:
            return .Format_31t
        case DalvikOpcode.INSN_THROW:
            return .Format_11x
        case DalvikOpcode.INSN_GOTO:
            return .Format_10t
        case DalvikOpcode.INSN_GOTO_16:
            return .Format_20t
        case DalvikOpcode.INSN_GOTO_32:
            return .Format_30t
        case DalvikOpcode.INSN_PACKED_SWITCH_INSN:
            return .Format_31t
        case DalvikOpcode.INSN_SPARSE_SWITCH_INSN:
            return .Format_31t
        case DalvikOpcode.INSN_CMPL_FLOAT,
             DalvikOpcode.INSN_CMPG_FLOAT,
             DalvikOpcode.INSN_CMPL_DOUBLE,
             DalvikOpcode.INSN_CMPG_DOUBLE,
             DalvikOpcode.INSN_CMP_LONG:
            return .Format_23x
        case DalvikOpcode.INSN_IF_EQ,
             DalvikOpcode.INSN_IF_NE,
             DalvikOpcode.INSN_IF_LT,
             DalvikOpcode.INSN_IF_GE,
             DalvikOpcode.INSN_IF_GT,
             DalvikOpcode.INSN_IF_LE:
            return .Format_22t
        case DalvikOpcode.INSN_IF_EQZ,
             DalvikOpcode.INSN_IF_NEZ,
             DalvikOpcode.INSN_IF_LTZ,
             DalvikOpcode.INSN_IF_GEZ,
             DalvikOpcode.INSN_IF_GTZ,
             DalvikOpcode.INSN_IF_LEZ:
            return .Format_21t
        case DalvikOpcode.INSN_AGET,
             DalvikOpcode.INSN_AGET_WIDE,
             DalvikOpcode.INSN_AGET_OBJECT,
             DalvikOpcode.INSN_AGET_BOOLEAN,
             DalvikOpcode.INSN_AGET_BYTE,
             DalvikOpcode.INSN_AGET_CHAR,
             DalvikOpcode.INSN_AGET_SHORT,
             DalvikOpcode.INSN_APUT,
             DalvikOpcode.INSN_APUT_WIDE,
             DalvikOpcode.INSN_APUT_OBJECT,
             DalvikOpcode.INSN_APUT_BOOLEAN,
             DalvikOpcode.INSN_APUT_BYTE,
             DalvikOpcode.INSN_APUT_CHAR,
             DalvikOpcode.INSN_APUT_SHORT:
            return .Format_23x
        case DalvikOpcode.INSN_IGET,
             DalvikOpcode.INSN_IGET_WIDE,
             DalvikOpcode.INSN_IGET_OBJECT,
             DalvikOpcode.INSN_IGET_BOOLEAN,
             DalvikOpcode.INSN_IGET_BYTE,
             DalvikOpcode.INSN_IGET_CHAR,
             DalvikOpcode.INSN_IGET_SHORT,
             DalvikOpcode.INSN_IPUT,
             DalvikOpcode.INSN_IPUT_WIDE,
             DalvikOpcode.INSN_IPUT_OBJECT,
             DalvikOpcode.INSN_IPUT_BOOLEAN,
             DalvikOpcode.INSN_IPUT_BYTE,
             DalvikOpcode.INSN_IPUT_CHAR,
             DalvikOpcode.INSN_IPUT_SHORT:
            return .Format_22c
        case DalvikOpcode.INSN_SGET,
             DalvikOpcode.INSN_SGET_WIDE,
             DalvikOpcode.INSN_SGET_OBJECT,
             DalvikOpcode.INSN_SGET_BOOLEAN,
             DalvikOpcode.INSN_SGET_BYTE,
             DalvikOpcode.INSN_SGET_CHAR,
             DalvikOpcode.INSN_SGET_SHORT,
             DalvikOpcode.INSN_SPUT,
             DalvikOpcode.INSN_SPUT_WIDE,
             DalvikOpcode.INSN_SPUT_OBJECT,
             DalvikOpcode.INSN_SPUT_BOOLEAN,
             DalvikOpcode.INSN_SPUT_BYTE,
             DalvikOpcode.INSN_SPUT_CHAR,
             DalvikOpcode.INSN_SPUT_SHORT:
            return .Format_21c
        case DalvikOpcode.INSN_INVOKE_VIRTUAL,
             DalvikOpcode.INSN_INVOKE_SUPER,
             DalvikOpcode.INSN_INVOKE_DIRECT,
             DalvikOpcode.INSN_INVOKE_STATIC,
             DalvikOpcode.INSN_INVOKE_INTERFACE:
            return .Format_35c
        case DalvikOpcode.INSN_INVOKE_VIRTUAL_RANGE,
             DalvikOpcode.INSN_INVOKE_SUPER_RANGE,
             DalvikOpcode.INSN_INVOKE_DIRECT_RANGE,
             DalvikOpcode.INSN_INVOKE_STATIC_RANGE,
             DalvikOpcode.INSN_INVOKE_INTERFACE_RANGE:
            return .Format_3rc
        case DalvikOpcode.INSN_NEG_INT,
             DalvikOpcode.INSN_NOT_INT,
             DalvikOpcode.INSN_NEG_LONG,
             DalvikOpcode.INSN_NOT_LONG,
             DalvikOpcode.INSN_NEG_FLOAT,
             DalvikOpcode.INSN_NEG_DOUBLE,
             DalvikOpcode.INSN_INT_TO_LONG,
             DalvikOpcode.INSN_INT_TO_FLOAT,
             DalvikOpcode.INSN_INT_TO_DOUBLE,
             DalvikOpcode.INSN_LONG_TO_INT,
             DalvikOpcode.INSN_LONG_TO_FLOAT,
             DalvikOpcode.INSN_LONG_TO_DOUBLE,
             DalvikOpcode.INSN_FLOAT_TO_INT,
             DalvikOpcode.INSN_FLOAT_TO_LONG,
             DalvikOpcode.INSN_FLOAT_TO_DOUBLE,
             DalvikOpcode.INSN_DOUBLE_TO_INT,
             DalvikOpcode.INSN_DOUBLE_TO_LONG,
             DalvikOpcode.INSN_DOUBLE_TO_FLOAT,
             DalvikOpcode.INSN_INT_TO_BYTE,
             DalvikOpcode.INSN_INT_TO_CHAR,
             DalvikOpcode.INSN_INT_TO_SHORT:
            return .Format_12x
        case DalvikOpcode.INSN_ADD_INT,
             DalvikOpcode.INSN_SUB_INT,
             DalvikOpcode.INSN_MUL_INT,
             DalvikOpcode.INSN_DIV_INT,
             DalvikOpcode.INSN_REM_INT,
             DalvikOpcode.INSN_AND_INT,
             DalvikOpcode.INSN_OR_INT,
             DalvikOpcode.INSN_XOR_INT,
             DalvikOpcode.INSN_SHL_INT,
             DalvikOpcode.INSN_SHR_INT,
             DalvikOpcode.INSN_USHR_INT,
             DalvikOpcode.INSN_ADD_LONG,
             DalvikOpcode.INSN_SUB_LONG,
             DalvikOpcode.INSN_MUL_LONG,
             DalvikOpcode.INSN_DIV_LONG,
             DalvikOpcode.INSN_REM_LONG,
             DalvikOpcode.INSN_AND_LONG,
             DalvikOpcode.INSN_OR_LONG,
             DalvikOpcode.INSN_XOR_LONG,
             DalvikOpcode.INSN_SHL_LONG,
             DalvikOpcode.INSN_SHR_LONG,
             DalvikOpcode.INSN_USHR_LONG,
             DalvikOpcode.INSN_ADD_FLOAT,
             DalvikOpcode.INSN_SUB_FLOAT,
             DalvikOpcode.INSN_MUL_FLOAT,
             DalvikOpcode.INSN_DIV_FLOAT,
             DalvikOpcode.INSN_REM_FLOAT,
             DalvikOpcode.INSN_ADD_DOUBLE,
             DalvikOpcode.INSN_SUB_DOUBLE,
             DalvikOpcode.INSN_MUL_DOUBLE,
             DalvikOpcode.INSN_DIV_DOUBLE,
             DalvikOpcode.INSN_REM_DOUBLE:
            return .Format_23x
        case DalvikOpcode.INSN_ADD_INT_2ADDR,
             DalvikOpcode.INSN_SUB_INT_2ADDR,
             DalvikOpcode.INSN_MUL_INT_2ADDR,
             DalvikOpcode.INSN_DIV_INT_2ADDR,
             DalvikOpcode.INSN_REM_INT_2ADDR,
             DalvikOpcode.INSN_AND_INT_2ADDR,
             DalvikOpcode.INSN_OR_INT_2ADDR,
             DalvikOpcode.INSN_XOR_INT_2ADDR,
             DalvikOpcode.INSN_SHL_INT_2ADDR,
             DalvikOpcode.INSN_SHR_INT_2ADDR,
             DalvikOpcode.INSN_USHR_INT_2ADDR,
             DalvikOpcode.INSN_ADD_LONG_2ADDR,
             DalvikOpcode.INSN_SUB_LONG_2ADDR,
             DalvikOpcode.INSN_MUL_LONG_2ADDR,
             DalvikOpcode.INSN_DIV_LONG_2ADDR,
             DalvikOpcode.INSN_REM_LONG_2ADDR,
             DalvikOpcode.INSN_AND_LONG_2ADDR,
             DalvikOpcode.INSN_OR_LONG_2ADDR,
             DalvikOpcode.INSN_XOR_LONG_2ADDR,
             DalvikOpcode.INSN_SHL_LONG_2ADDR,
             DalvikOpcode.INSN_SHR_LONG_2ADDR,
             DalvikOpcode.INSN_USHR_LONG_2ADDR,
             DalvikOpcode.INSN_ADD_FLOAT_2ADDR,
             DalvikOpcode.INSN_SUB_FLOAT_2ADDR,
             DalvikOpcode.INSN_MUL_FLOAT_2ADDR,
             DalvikOpcode.INSN_DIV_FLOAT_2ADDR,
             DalvikOpcode.INSN_REM_FLOAT_2ADDR,
             DalvikOpcode.INSN_ADD_DOUBLE_2ADDR,
             DalvikOpcode.INSN_SUB_DOUBLE_2ADDR,
             DalvikOpcode.INSN_MUL_DOUBLE_2ADDR,
             DalvikOpcode.INSN_DIV_DOUBLE_2ADDR,
             DalvikOpcode.INSN_REM_DOUBLE_2ADDR:
            return .Format_12x
        case DalvikOpcode.INSN_ADD_INT_LIT16,
             DalvikOpcode.INSN_RSUB_INT_LIT16,
             DalvikOpcode.INSN_MUL_INT_LIT16,
             DalvikOpcode.INSN_DIV_INT_LIT16,
             DalvikOpcode.INSN_REM_INT_LIT16,
             DalvikOpcode.INSN_AND_INT_LIT16,
             DalvikOpcode.INSN_OR_INT_LIT16,
             DalvikOpcode.INSN_XOR_INT_LIT16:
            return .Format_22s
        case DalvikOpcode.INSN_ADD_INT_LIT8,
             DalvikOpcode.INSN_RSUB_INT_LIT8,
             DalvikOpcode.INSN_MUL_INT_LIT8,
             DalvikOpcode.INSN_DIV_INT_LIT8,
             DalvikOpcode.INSN_REM_INT_LIT8,
             DalvikOpcode.INSN_AND_INT_LIT8,
             DalvikOpcode.INSN_OR_INT_LIT8,
             DalvikOpcode.INSN_XOR_INT_LIT8,
             DalvikOpcode.INSN_SHL_INT_LIT8,
             DalvikOpcode.INSN_SHR_INT_LIT8,
             DalvikOpcode.INSN_USHR_INT_LIT8:
            return .Format_22b
        case DalvikOpcode.INSN_INVOKE_POLYMORPHIC:
            return .Format_45cc
        case DalvikOpcode.INSN_INVOKE_POLYMORPHIC_RANGE:
            return .Format_4rcc
        case DalvikOpcode.INSN_INVOKE_CUSTOM:
            return .Format_35c
        case DalvikOpcode.INSN_INVOKE_CUSTOM_RANGE:
            return .Format_3rc
        case DalvikOpcode.INSN_CONST_METHOD_HANDLE:
            return .Format_21c
        case DalvikOpcode.INSN_CONST_METHOD_TYPE:
            return .Format_21c
        }
    }
}
