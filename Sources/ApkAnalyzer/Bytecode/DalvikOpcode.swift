//
//  Opcodes.swift
//  ApkAnalyzer
//
//  Created by Qing Xu on 8/3/19.
//

import Common

enum DalvikOpcode: Int {
    
    // Opcodes for the Dalvik Instructions.
    /**
     * NOP
     */
    case INSN_NOP = 0x0                        // visitInsn
    /**
     * MOVE
     */
    case INSN_MOVE = 0x1                    // visitVarInsn
    /**
     * Move from 16
     */
    case INSN_MOVE_FROM16 = 0x2
    /**
     * Move 16
     */
    case INSN_MOVE_16 = 0x3
    /**
     * Move wide
     */
    case INSN_MOVE_WIDE = 0x4
    /**
     * Move wide from 16
     */
    case INSN_MOVE_WIDE_FROM16 = 0x5
    /**
     * Move wide 16
     */
    case INSN_MOVE_WIDE_16 = 0x6
    /**
     * Move object
     */
    case INSN_MOVE_OBJECT = 0x7
    /**
     * Move object from 16
     */
    case INSN_MOVE_OBJECT_FROM16 = 0x8
    /**
     * Moe object 16
     */
    case INSN_MOVE_OBJECT_16 = 0x9
    /**
     * Move result
     */
    case INSN_MOVE_RESULT = 0xa                // visitIntInsn
    /**
     * Move result wide
     */
    case INSN_MOVE_RESULT_WIDE = 0xb
    /**
     * Move result object
     */
    case INSN_MOVE_RESULT_OBJECT = 0xc
    /**
     * Move exception
     */
    case INSN_MOVE_EXCEPTION = 0xd
    /**
     * Return void
     */
    case INSN_RETURN_VOID = 0xe                // visitInsn
    /**
     * Return
     */
    case INSN_RETURN = 0xf                    // visitIntInsn
    /**
     * Return wide
     */
    case INSN_RETURN_WIDE = 0x10
    /**
     * Return object
     */
    case INSN_RETURN_OBJECT = 0x11
    /**
     * Constant 4
     */
    case INSN_CONST_4 = 0x12                // visitVarInsn
    /**
     * Constant 16
     */
    case INSN_CONST_16 = 0x13
    /**
     * Constant
     */
    case INSN_CONST = 0x14
    /**
     * Constant High 16
     */
    case INSN_CONST_HIGH16 = 0x15
    /**
     * Constant Wide 16
     */
    case INSN_CONST_WIDE_16 = 0x16
    /**
     * Constant Wide 32
     */
    case INSN_CONST_WIDE_32 = 0x17
    /**
     * Constant Wide
     */
    case INSN_CONST_WIDE = 0x18
    /**
     * Constant Wide High 16
     */
    case INSN_CONST_WIDE_HIGH16 = 0x19
    /**
     * Cosntant String
     */
    case INSN_CONST_STRING = 0x1a            // visitStringInsn
    /**
     *
     */
    case INSN_CONST_STRING_JUMBO = 0x1b
    /**
     * Constant Class
     */
    case INSN_CONST_CLASS = 0x1c            // visitTypeInsn
    /**
     * Monitor Enter
     */
    case INSN_MONITOR_ENTER = 0x1d            // visitIntInsn
    /**
     * Monitor Exit
     */
    case INSN_MONITOR_EXIT = 0x1e
    /**
     * Check Cast
     */
    case INSN_CHECK_CAST = 0x1f                // visitTypeInsn
    /**
     * Instance of
     */
    case INSN_INSTANCE_OF = 0x20
    /**
     * Array length
     */
    case INSN_ARRAY_LENGTH = 0x21            // visitArrayLengthInsn
    /**
     * New Instance
     */
    case INSN_NEW_INSTANCE = 0x22            // visitTypeInsn
    /**
     * New array
     */
    case INSN_NEW_ARRAY = 0x23
    /**
     * Filled new array
     */
    case INSN_FILLED_NEW_ARRAY = 0x24        // visitMultiANewArrayInsn
    /**
     * New array range
     */
    case INSN_FILLED_NEW_ARRAY_RANGE = 0x25
    /**
     * Fill array data
     */
    case INSN_FILL_ARRAY_DATA = 0x26        // visitFillArrayDataInsn
    /**
     * Throw
     */
    case INSN_THROW = 0x27                    // visitIntInsn
    /**
     * Goto
     */
    case INSN_GOTO = 0x28                    // visitJumpInsn
    /**
     * Goto 16
     */
    case INSN_GOTO_16 = 0x29
    /**
     * Goto 32
     */
    case INSN_GOTO_32 = 0x2a
    /**
     * Packed Switch
     */
    case INSN_PACKED_SWITCH_INSN = 0x2b        // visitTableSwitchInsn
    /**
     * Sparse switch
     */
    case INSN_SPARSE_SWITCH_INSN = 0x2c        // visitLookupSwitchInsn
    /**
     * Compare Lower Float
     */
    case INSN_CMPL_FLOAT = 0x2d                // visitOperationInsn
    /**
     * Compare Greater Float
     */
    case INSN_CMPG_FLOAT = 0x2e
    /**
     * Compare Lower Double
     */
    case INSN_CMPL_DOUBLE = 0x2f
    /**
     * Compare Greater Double
     */
    case INSN_CMPG_DOUBLE = 0x30
    /**
     * Compare Long
     */
    case INSN_CMP_LONG = 0x31
    /**
     * If eq
     */
    case INSN_IF_EQ = 0x32                    // visitJumpInsn
    /**
     * If not eq
     */
    case INSN_IF_NE = 0x33
    /**
     * If less than
     */
    case INSN_IF_LT = 0x34
    /**
     * If greater or equal
     */
    case INSN_IF_GE = 0x35
    /**
     * If greater
     */
    case INSN_IF_GT = 0x36
    /**
     * If lower or equal
     */
    case INSN_IF_LE = 0x37
    /**
     * If eq zero
     */
    case INSN_IF_EQZ = 0x38
    /**
     * If not zero
     */
    case INSN_IF_NEZ = 0x39
    /**
     * If less than zero
     */
    case INSN_IF_LTZ = 0x3a
    /**
     * If greater or equal to zero
     */
    case INSN_IF_GEZ = 0x3b
    /**
     * If greater than zero
     */
    case INSN_IF_GTZ = 0x3c
    /**
     * If less or equal to zero
     */
    case INSN_IF_LEZ = 0x3d
    
    /**
     * Array get
     */
    case INSN_AGET = 0x44                    // visitArrayOperationInsn
    /**
     * Array get wide
     */
    case INSN_AGET_WIDE = 0x45
    /**
     * Array get object
     */
    case INSN_AGET_OBJECT = 0x46
    /**
     * Array get boolean
     */
    case INSN_AGET_BOOLEAN = 0x47
    /**
     * Array get byte
     */
    case INSN_AGET_BYTE = 0x48
    /**
     * Array get char
     */
    case INSN_AGET_CHAR = 0x49
    /**
     * Array get short
     */
    case INSN_AGET_SHORT = 0x4a
    /**
     * Array put
     */
    case INSN_APUT = 0x4b
    /**
     * Array put wide
     */
    case INSN_APUT_WIDE = 0x4c
    /**
     * Array put object
     */
    case INSN_APUT_OBJECT = 0x4d
    /**
     * Array put boolean
     */
    case INSN_APUT_BOOLEAN = 0x4e
    /**
     * Array put byte
     */
    case INSN_APUT_BYTE = 0x4f
    /**
     * Array put char
     */
    case INSN_APUT_CHAR = 0x50
    /**
     * Arrray put short
     */
    case INSN_APUT_SHORT = 0x51
    
    /**
     * Instance field get
     */
    case INSN_IGET = 0x52                    // visitFieldInsn
    /**
     * Instance field get wide
     */
    case INSN_IGET_WIDE = 0x53
    /**
     * Instance field get object
     */
    case INSN_IGET_OBJECT = 0x54
    /**
     * Instance field get boolean
     */
    case INSN_IGET_BOOLEAN = 0x55
    /**
     * Instance field get byte
     */
    case INSN_IGET_BYTE = 0x56
    /**
     * Instance field get char
     */
    case INSN_IGET_CHAR = 0x57
    /**
     * Instance field get short
     */
    case INSN_IGET_SHORT = 0x58
    /**
     * Instance field put
     */
    case INSN_IPUT = 0x59
    /**
     * Instance field put wide
     */
    case INSN_IPUT_WIDE = 0x5a
    /**
     * Instance field put object
     */
    case INSN_IPUT_OBJECT = 0x5b
    /**
     * Instance field put boolean
     */
    case INSN_IPUT_BOOLEAN = 0x5c
    /**
     * Instance field put byte
     */
    case INSN_IPUT_BYTE = 0x5d
    /**
     * Instance field put char
     */
    case INSN_IPUT_CHAR = 0x5e
    /**
     * Instance field put short
     */
    case INSN_IPUT_SHORT = 0x5f

    /**
     * Static get
     */
    case INSN_SGET = 0x60
    /**
     * Static get wide
     */
    case INSN_SGET_WIDE = 0x61
    /**
     * Static get object
     */
    case INSN_SGET_OBJECT = 0x62
    /**
     * Static get boolean
     */
    case INSN_SGET_BOOLEAN = 0x63
    /**
     * Static get byte
     */
    case INSN_SGET_BYTE = 0x64
    /**
     * Static get char
     */
    case INSN_SGET_CHAR = 0x65
    /**
     * Static get short
     */
    case INSN_SGET_SHORT = 0x66
    /**
     * Static put
     */
    case INSN_SPUT = 0x67
    /**
     * Static put wide
     */
    case INSN_SPUT_WIDE = 0x68
    /**
     * Static put object
     */
    case INSN_SPUT_OBJECT = 0x69
    /**
     * Static put boolean
     */
    case INSN_SPUT_BOOLEAN = 0x6a
    /**
     * Static put byte
     */
    case INSN_SPUT_BYTE = 0x6b
    /**
     * Static put char
     */
    case INSN_SPUT_CHAR = 0x6c
    /**
     * Static put short
     */
    case INSN_SPUT_SHORT = 0x6d
    
    /**
     * Invoke virtual
     */
    case INSN_INVOKE_VIRTUAL = 0x6e            // visitMethodInsn
    /**
     * Invoke super
     */
    case INSN_INVOKE_SUPER = 0x6f
    /**
     * Invoke direct
     */
    case INSN_INVOKE_DIRECT = 0x70
    /**
     * Invoke static
     */
    case INSN_INVOKE_STATIC = 0x71
    /**
     * Invoke interface
     */
    case INSN_INVOKE_INTERFACE = 0x72
    
    /**
     * Invoke virtual range
     */
    case INSN_INVOKE_VIRTUAL_RANGE = 0x74
    /**
     * Invoke super range
     */
    case INSN_INVOKE_SUPER_RANGE = 0x75
    /**
     * Invoke direct range
     */
    case INSN_INVOKE_DIRECT_RANGE = 0x76
    /**
     * Invoke static range
     */
    case INSN_INVOKE_STATIC_RANGE = 0x77
    /**
     * Invoke interface range
     */
    case INSN_INVOKE_INTERFACE_RANGE = 0x78
    
    /**
     * Invoke neg range
     */
    case INSN_NEG_INT = 0x7b                // visitOperationInsn
    /**
     * Not integer
     */
    case INSN_NOT_INT = 0x7c
    /**
     * Neg long
     */
    case INSN_NEG_LONG = 0x7d
    /**
     * Not long
     */
    case INSN_NOT_LONG = 0x7e
    /**
     * Neg float
     */
    case INSN_NEG_FLOAT = 0x7f
    /**
     * Neg double
     */
    case INSN_NEG_DOUBLE = 0x80
    /**
     * Int to long
     */
    case INSN_INT_TO_LONG = 0x81
    /**
     * Int to float
     */
    case INSN_INT_TO_FLOAT = 0x82
    /**
     * Int to double
     */
    case INSN_INT_TO_DOUBLE = 0x83
    /**
     * Long to int
     */
    case INSN_LONG_TO_INT = 0x84
    /**
     * Long to float
     */
    case INSN_LONG_TO_FLOAT = 0x85
    /**
     * Long to double
     */
    case INSN_LONG_TO_DOUBLE = 0x86
    /**
     * Float to int
     */
    case INSN_FLOAT_TO_INT = 0x87
    /**
     * Float to long
     */
    case INSN_FLOAT_TO_LONG = 0x88
    /**
     * Float to double
     */
    case INSN_FLOAT_TO_DOUBLE = 0x89
    /**
     * Double to int
     */
    case INSN_DOUBLE_TO_INT = 0x8a
    /**
     * Double to long
     */
    case INSN_DOUBLE_TO_LONG = 0x8b
    /**
     * Double to float
     */
    case INSN_DOUBLE_TO_FLOAT = 0x8c
    /**
     * Int to byte
     */
    case INSN_INT_TO_BYTE = 0x8d
    /**
     * Int to char
     */
    case INSN_INT_TO_CHAR = 0x8e
    /**
     * Int to short
     */
    case INSN_INT_TO_SHORT = 0x8f
    
    /**
     * Add int
     */
    case INSN_ADD_INT = 0x90
    /**
     * Substract int
     */
    case INSN_SUB_INT = 0x91
    /**
     * Multiply int
     */
    case INSN_MUL_INT = 0x92
    /**
     * Divide int
     */
    case INSN_DIV_INT = 0x93
    /**
     * Remainder int
     */
    case INSN_REM_INT = 0x94
    /**
     * And int
     */
    case INSN_AND_INT = 0x95
    /**
     * Or int
     */
    case INSN_OR_INT = 0x96
    /**
     * Xor int
     */
    case INSN_XOR_INT = 0x97
    /**
     * Shift left int
     */
    case INSN_SHL_INT = 0x98
    /**
     * Sifht right int
     */
    case INSN_SHR_INT = 0x99
    /**
     * Unsigned Shift right int
     */
    case INSN_USHR_INT = 0x9a
    /**
     * Add long
     */
    case INSN_ADD_LONG = 0x9b
    /**
     * Subtract long
     */
    case INSN_SUB_LONG = 0x9c
    /**
     * Multiply long
     */
    case INSN_MUL_LONG = 0x9d
    /**
     * Divide long
     */
    case INSN_DIV_LONG = 0x9e
    /**
     * Remainder long
     */
    case INSN_REM_LONG = 0x9f
    /**
     * And long
     */
    case INSN_AND_LONG = 0xa0
    /**
     * Or long
     */
    case INSN_OR_LONG = 0xa1
    /**
     * Xor long
     */
    case INSN_XOR_LONG = 0xa2
    /**
     * Shift left long
     */
    case INSN_SHL_LONG = 0xa3
    /**
     * Shift right long
     */
    case INSN_SHR_LONG = 0xa4
    /**
     * Unsigned shift right long
     */
    case INSN_USHR_LONG = 0xa5
    
    /**
     * Add float
     */
    case INSN_ADD_FLOAT = 0xa6
    /**
     * Substract float
     */
    case INSN_SUB_FLOAT = 0xa7
    /**
     * Multiply float
     */
    case INSN_MUL_FLOAT = 0xa8
    /**
     * Divide float
     */
    case INSN_DIV_FLOAT = 0xa9
    /**
     * Remainder float
     */
    case INSN_REM_FLOAT = 0xaa
    /**
     * Add double
     */
    case INSN_ADD_DOUBLE = 0xab
    /**
     * Substract double
     */
    case INSN_SUB_DOUBLE = 0xac
    /**
     * Multiply double
     */
    case INSN_MUL_DOUBLE = 0xad
    /**
     * Divide double
     */
    case INSN_DIV_DOUBLE = 0xae
    /**
     * Remainder double
     */
    case INSN_REM_DOUBLE = 0xaf
    
    /**
     * Add integer two addresses
     */
    case INSN_ADD_INT_2ADDR = 0xb0
    /**
     * Sub integer two addresses
     */
    case INSN_SUB_INT_2ADDR = 0xb1
    /**
     * Multiply integer two addresses
     */
    case INSN_MUL_INT_2ADDR = 0xb2
    /**
     * Divide integer two addresses
     */
    case INSN_DIV_INT_2ADDR = 0xb3
    /**
     * Remainder integer two addresses
     */
    case INSN_REM_INT_2ADDR = 0xb4
    /**
     * And integer two addresses
     */
    case INSN_AND_INT_2ADDR = 0xb5
    /**
     * Or integer two addresses
     */
    case INSN_OR_INT_2ADDR = 0xb6
    /**
     * Xor integer two addresses
     */
    case INSN_XOR_INT_2ADDR = 0xb7
    /**
     * Shift left integer two addresses
     */
    case INSN_SHL_INT_2ADDR = 0xb8
    /**
     * Shift right integer two addresses
     */
    case INSN_SHR_INT_2ADDR = 0xb9
    /**
     * Unsigned shift right integer two addresses
     */
    case INSN_USHR_INT_2ADDR = 0xba
    
    /**
     * Add long two addresses
     */
    case INSN_ADD_LONG_2ADDR = 0xbb
    /**
     * substract long two addresses
     */
    case INSN_SUB_LONG_2ADDR = 0xbc
    /**
     * multiply long two addresses
     */
    case INSN_MUL_LONG_2ADDR = 0xbd
    /**
     * divide long two addresses
     */
    case INSN_DIV_LONG_2ADDR = 0xbe
    /**
     * Remainder long two addresses
     */
    case INSN_REM_LONG_2ADDR = 0xbf
    /**
     * And long two addresses
     */
    case INSN_AND_LONG_2ADDR = 0xc0
    /**
     * Or long two addresses
     */
    case INSN_OR_LONG_2ADDR = 0xc1
    /**
     * Exclusive or long two addresses
     */
    case INSN_XOR_LONG_2ADDR = 0xc2
    /**
     * Shift left long two addresses
     */
    case INSN_SHL_LONG_2ADDR = 0xc3
    /**
     * Shift right long two addresses
     */
    case INSN_SHR_LONG_2ADDR = 0xc4
    /**
     * Unsigned shift right long two addresses
     */
    case INSN_USHR_LONG_2ADDR = 0xc5
    
    /**
     * Add float two addresses
     */
    case INSN_ADD_FLOAT_2ADDR = 0xc6
    /**
     * Substract float two addresses
     */
    case INSN_SUB_FLOAT_2ADDR = 0xc7
    /**
     * Multiply float two addresses
     */
    case INSN_MUL_FLOAT_2ADDR = 0xc8
    /**
     * Divide float two addresses
     */
    case INSN_DIV_FLOAT_2ADDR = 0xc9
    /**
     * Remainder float two addresses
     */
    case INSN_REM_FLOAT_2ADDR = 0xca
    /**
     * Add double two addresses
     */
    case INSN_ADD_DOUBLE_2ADDR = 0xcb
    /**
     * Substract double two addresses
     */
    case INSN_SUB_DOUBLE_2ADDR = 0xcc
    /**
     * Multiply double two addresses
     */
    case INSN_MUL_DOUBLE_2ADDR = 0xcd
    /**
     * Divide double two addresses
     */
    case INSN_DIV_DOUBLE_2ADDR = 0xce
    /**
     * Remainder double two addresses
     */
    case INSN_REM_DOUBLE_2ADDR = 0xcf
    
    /**
     * Add integer literal 16
     */
    case INSN_ADD_INT_LIT16 = 0xd0
    /**
     * Reverse substract integer literal 16
     */
    case INSN_RSUB_INT_LIT16 = 0xd1
    /**
     * Multiply integer literal 16
     */
    case INSN_MUL_INT_LIT16 = 0xd2
    /**
     * Divide integer literal 16
     */
    case INSN_DIV_INT_LIT16 = 0xd3
    /**
     * Remainder integer literal 16
     */
    case INSN_REM_INT_LIT16 = 0xd4
    /**
     * And integer literal 16
     */
    case INSN_AND_INT_LIT16 = 0xd5
    /**
     * Or integer literal 16
     */
    case INSN_OR_INT_LIT16 = 0xd6
    /**
     * Exclusive Or integer literal 16
     */
    case INSN_XOR_INT_LIT16 = 0xd7
    
    /**
     * Add integer literal 8
     */
    case INSN_ADD_INT_LIT8 = 0xd8
    /**
     * Reverve substract integer literal 8
     */
    case INSN_RSUB_INT_LIT8 = 0xd9
    /**
     * Multiply integer literal 8
     */
    case INSN_MUL_INT_LIT8 = 0xda
    /**
     * Divide integer literal 8
     */
    case INSN_DIV_INT_LIT8 = 0xdb
    /**
     * Remainder integer literal 8
     */
    case INSN_REM_INT_LIT8 = 0xdc
    /**
     * And integer literal 8
     */
    case INSN_AND_INT_LIT8 = 0xdd
    /**
     * Or integer literal 8
     */
    case INSN_OR_INT_LIT8 = 0xde
    /**
     * Exclusive or integer literal 8
     */
    case INSN_XOR_INT_LIT8 = 0xdf
    /**
     * Shift left integer literal 8
     */
    case INSN_SHL_INT_LIT8 = 0xe0
    /**
     * Shift right integer literal 8
     */
    case INSN_SHR_INT_LIT8 = 0xe1
    /**
     * Unsigned shift right integer literal 8
     */
    case INSN_USHR_INT_LIT8 = 0xe2
    
    case INSN_INVOKE_POLYMORPHIC = 0xfa
    
    case INSN_INVOKE_POLYMORPHIC_RANGE = 0xfb
    
    case INSN_INVOKE_CUSTOM = 0xfc
    
    case INSN_INVOKE_CUSTOM_RANGE = 0xfd
    
    case INSN_CONST_METHOD_HANDLE = 0xfe
    
    case INSN_CONST_METHOD_TYPE = 0xff
    
}

extension DalvikOpcode {
    var description: String {
        switch self {
        case .INSN_NOP:
            return "nop"
        case .INSN_MOVE:
            return "move"
        case .INSN_MOVE_FROM16:
            return "move/from16"
        case .INSN_MOVE_16:
            return "move/16"
        case .INSN_MOVE_WIDE:
            return "move-wide"
        case .INSN_MOVE_WIDE_FROM16:
            return "move-wide/from16"
        case .INSN_MOVE_WIDE_16:
            return "move-wide/16"
        case .INSN_MOVE_OBJECT:
            return "move-object"
        case .INSN_MOVE_OBJECT_FROM16:
            return "move-object/from16"
        case .INSN_MOVE_OBJECT_16:
            return "move-object/16"
        case .INSN_MOVE_RESULT:
            return "move-result"
        case .INSN_MOVE_RESULT_WIDE:
            return "move-result-wide"
        case .INSN_MOVE_RESULT_OBJECT:
            return "move-result-object"
        case .INSN_MOVE_EXCEPTION:
            return "move-exception"
        case .INSN_RETURN_VOID:
            return "return-void"
        case .INSN_RETURN_WIDE:
            return "return-wide"
        case .INSN_RETURN_OBJECT:
            return "return-object"
        case .INSN_CONST_4:
            return "const/4"
        case .INSN_CONST_16:
            return "const/16"
        case .INSN_CONST:
            return "const"
        case .INSN_CONST_HIGH16:
            return "const/high16"
        case .INSN_CONST_WIDE_16:
            return "const-wide/16"
        case .INSN_CONST_WIDE_32:
            return "const-wide/32"
        case .INSN_CONST_WIDE_HIGH16:
            return "const-wide/high16"
        case .INSN_CONST_STRING:
            return "const-string"
        case .INSN_CONST_STRING_JUMBO:
            return "const-string/jumbo"
        case .INSN_CONST_CLASS:
            return "const-class"
        case .INSN_MONITOR_ENTER:
            return "monitor-enter"
        case .INSN_MONITOR_EXIT:
            return "monitor-exit"
        case .INSN_CHECK_CAST:
            return "check-cast"
        case .INSN_INSTANCE_OF:
            return "instance-of"
        case .INSN_ARRAY_LENGTH:
            return "array-length"
        case .INSN_NEW_INSTANCE:
            return "new-instance"
        case .INSN_NEW_ARRAY:
            return "new-array"
        case .INSN_FILLED_NEW_ARRAY:
            return "filled-new-array"
        case .INSN_FILLED_NEW_ARRAY_RANGE:
            return "filled-new-array/range"
        case .INSN_FILL_ARRAY_DATA:
            return "fill-array-data"
        case .INSN_THROW:
            return "throw"
        case .INSN_GOTO_16:
            return "goto/16"
        case .INSN_GOTO:
            return "goto"
        case .INSN_GOTO_32:
            return "goto/32"
        case .INSN_PACKED_SWITCH_INSN:
            return "packed-switch"
        case .INSN_SPARSE_SWITCH_INSN:
            return "sparse-switch"
        case .INSN_CMPL_FLOAT:
            return "cmpl-float"
        case .INSN_CMPG_FLOAT:
            return "cmpg-float"
        case .INSN_CMPL_DOUBLE:
            return "cmpl-double"
        case .INSN_CMPG_DOUBLE:
            return "cmpg-double"
        case .INSN_CMP_LONG:
            return "cmp_long"
        case .INSN_IF_EQ:
            return "if-eq"
        case .INSN_IF_NE:
            return "if-ne"
        case .INSN_IF_LT:
            return "if-lt"
        case .INSN_IF_GE:
            return "if-ge"
        case .INSN_IF_GT:
            return "if-gt"
        case .INSN_IF_LE:
            return "if-le"
        case .INSN_IF_EQZ:
            return "if-eqz"
        case .INSN_IF_NEZ:
            return "if-nez"
        case .INSN_IF_LTZ:
            return "if-ltz"
        case .INSN_IF_GEZ:
            return "if-gez"
        case .INSN_IF_GTZ:
            return "if-gtz"
        case .INSN_IF_LEZ:
            return "if-lez"
        case .INSN_AGET:
            return "aget"
        case .INSN_AGET_WIDE:
            return "aget-wide"
        case .INSN_AGET_OBJECT:
            return "aget-object"
        case .INSN_AGET_BOOLEAN:
            return "aget-boolean"
        case .INSN_AGET_BYTE:
            return "aget-byte"
        case .INSN_AGET_CHAR:
            return "aget-char"
        case .INSN_AGET_SHORT:
            return "aget-short"
        case .INSN_APUT:
            return "aput"
        case .INSN_APUT_WIDE:
            return "aput-wide"
        case .INSN_APUT_OBJECT:
            return "aput-object"
        case .INSN_APUT_BOOLEAN:
            return "aput-boolean"
        case .INSN_APUT_BYTE:
            return "aput-byte"
        case .INSN_APUT_CHAR:
            return "aput-char"
        case .INSN_APUT_SHORT:
            return "aput-short"
        case .INSN_IGET:
            return "iget"
        case .INSN_IGET_WIDE:
            return "iget-wide"
        case .INSN_IGET_OBJECT:
            return "iget-object"
        case .INSN_IGET_BOOLEAN:
            return "iget-boolean"
        case .INSN_IGET_BYTE:
            return "iget-byte"
        case .INSN_IGET_CHAR:
            return "iget-char"
        case .INSN_IGET_SHORT:
            return "iget-short"
        case .INSN_IPUT:
            return "iput"
        case .INSN_IPUT_WIDE:
            return "iput-wide"
        case .INSN_IPUT_OBJECT:
            return "iput-object"
        case .INSN_IPUT_BOOLEAN:
            return "iput-boolean"
        case .INSN_IPUT_BYTE:
            return "iput-byte"
        case .INSN_IPUT_CHAR:
            return "iput-char"
        case .INSN_IPUT_SHORT:
            return "iput-short"
        case .INSN_SGET:
            return "sget"
        case .INSN_SGET_WIDE:
            return "sget-wide"
        case .INSN_SGET_OBJECT:
            return "sget-object"
        case .INSN_SGET_BOOLEAN:
            return "sget-boolean"
        case .INSN_SGET_BYTE:
            return "sget-byte"
        case .INSN_SGET_CHAR:
            return "sget-char"
        case .INSN_SGET_SHORT:
            return "sget-short"
        case .INSN_SPUT:
            return "sput"
        case .INSN_SPUT_WIDE:
            return "sput-wide"
        case .INSN_SPUT_OBJECT:
            return "sput-object"
        case .INSN_SPUT_BOOLEAN:
            return "sput-boolean"
        case .INSN_SPUT_BYTE:
            return "sput-byte"
        case .INSN_SPUT_CHAR:
            return "sput-char"
        case .INSN_SPUT_SHORT:
            return "sput-short"
        case .INSN_INVOKE_VIRTUAL:
            return "invoke-virtual"
        case .INSN_INVOKE_SUPER:
            return "invoke-super"
        case .INSN_INVOKE_DIRECT:
            return "invoke-direct"
        case .INSN_INVOKE_STATIC:
            return "invoke-static"
        case .INSN_INVOKE_INTERFACE:
            return "invoke-interface"
        case .INSN_INVOKE_VIRTUAL_RANGE:
            return "invoke-virtual/range"
        case .INSN_INVOKE_SUPER_RANGE:
            return "invoke-super/range"
        case .INSN_INVOKE_DIRECT_RANGE:
            return "invoke-direct/range"
        case .INSN_INVOKE_STATIC_RANGE:
            return "invoke-static/range"
        case .INSN_INVOKE_INTERFACE_RANGE:
            return "invoke-interface/range"
        case .INSN_NEG_INT:
            return "neg-int"
        case .INSN_NOT_INT:
            return "not-int"
        case .INSN_NEG_LONG:
            return "neg-long"
        case .INSN_NOT_LONG:
            return "not-long"
        case .INSN_NEG_FLOAT:
            return "neg-float"
        case .INSN_NEG_DOUBLE:
            return "neg-double"
        case .INSN_INT_TO_LONG:
            return "int-to-long"
        case .INSN_INT_TO_FLOAT:
            return "int-to-float"
        case .INSN_INT_TO_DOUBLE:
            return "int-to-double"
        case .INSN_LONG_TO_INT:
            return "long-to-int"
        case .INSN_LONG_TO_FLOAT:
            return "long-to-float"
        case .INSN_LONG_TO_DOUBLE:
            return "long-to-double"
        case .INSN_FLOAT_TO_INT:
            return "float-to-int"
        case .INSN_FLOAT_TO_LONG:
            return "float-to-long"
        case .INSN_FLOAT_TO_DOUBLE:
            return "float-to-double"
        case .INSN_INT_TO_BYTE:
            return "int-to-byte"
        case .INSN_INT_TO_CHAR:
            return "int-to-char"
        case .INSN_INT_TO_SHORT:
            return "int-to-short"
        case .INSN_ADD_INT:
            return "add-int"
        case .INSN_SUB_INT:
            return "sub-int"
        case .INSN_MUL_INT:
            return "mul-int"
        case .INSN_DIV_INT:
            return "div-int"
        case .INSN_REM_INT:
            return "rem-int"
        case .INSN_AND_INT:
            return "and-int"
        case .INSN_OR_INT:
            return "or-int"
        case .INSN_XOR_INT:
            return "xor-int"
        case .INSN_SHL_INT:
            return "shl-int"
        case .INSN_SHR_INT:
            return "shr-int"
        case .INSN_USHR_INT:
            return "ushr-int"
        case .INSN_ADD_LONG:
            return "add-long"
        case .INSN_SUB_LONG:
            return "sub-long"
        case .INSN_MUL_LONG:
            return "mul-long"
        case .INSN_DIV_LONG:
            return "div-long"
        case .INSN_REM_LONG:
            return "rem-long"
        case .INSN_AND_LONG:
            return "and-long"
        case .INSN_OR_LONG:
            return "or-long"
        case .INSN_XOR_LONG:
            return "xor-long"
        case .INSN_SHL_LONG:
            return "shl-long"
        case .INSN_SHR_LONG:
            return "shr-long"
        case .INSN_USHR_LONG:
            return "ushr-long"
        case .INSN_ADD_FLOAT:
            return "add-float"
        case .INSN_SUB_FLOAT:
            return "sub-float"
        case .INSN_MUL_FLOAT:
            return "mul-float"
        case .INSN_DIV_FLOAT:
            return "div-float"
        case .INSN_REM_FLOAT:
            return "rem-float"
        case .INSN_ADD_DOUBLE:
            return "add-double"
        case .INSN_SUB_DOUBLE:
            return "sub-double"
        case .INSN_MUL_DOUBLE:
            return "mul-double"
        case .INSN_DIV_DOUBLE:
            return "div-double"
        case .INSN_REM_DOUBLE:
            return "rem-double"
        case .INSN_ADD_INT_2ADDR:
            return "add-int/2addr"
        case .INSN_SUB_INT_2ADDR:
            return "sub-int/2addr"
        case .INSN_MUL_INT_2ADDR:
            return "mul-int/2addr"
        case .INSN_DIV_INT_2ADDR:
            return "div-int/2addr"
        case .INSN_REM_INT_2ADDR:
            return "rem-int/2addr"
        case .INSN_AND_INT_2ADDR:
            return "and-int/2addr"
        case .INSN_OR_INT_2ADDR:
            return "or-int/2addr"
        case .INSN_XOR_INT_2ADDR:
            return "xor-int/2addr"
        case .INSN_SHL_INT_2ADDR:
            return "shl-int/2addr"
        case .INSN_SHR_INT_2ADDR:
            return "shr-int/2addr"
        case .INSN_USHR_INT_2ADDR:
            return "ushr-int/2addr"
        case .INSN_ADD_LONG_2ADDR:
            return "add-long/2addr"
        case .INSN_SUB_LONG_2ADDR:
            return "sub-long/2addr"
        case .INSN_MUL_LONG_2ADDR:
            return "mul-long/2addr"
        case .INSN_DIV_LONG_2ADDR:
            return "div-long/2addr"
        case .INSN_REM_LONG_2ADDR:
            return "rem-long/2addr"
        case .INSN_AND_LONG_2ADDR:
            return "and-long/2addr"
        case .INSN_OR_LONG_2ADDR:
            return "or-long/2addr"
        case .INSN_XOR_LONG_2ADDR:
            return "xor-long/2addr"
        case .INSN_SHL_LONG_2ADDR:
            return "shl-long/2addr"
        case .INSN_SHR_LONG_2ADDR:
            return "shr-long/2addr"
        case .INSN_USHR_LONG_2ADDR:
            return "ushr-long/2addr"
        case .INSN_ADD_FLOAT_2ADDR:
            return "add-float/2addr"
        case .INSN_SUB_FLOAT_2ADDR:
            return "sub-float/2addr"
        case .INSN_MUL_FLOAT_2ADDR:
            return "mul-float/2addr"
        case .INSN_DIV_FLOAT_2ADDR:
            return "div-float/2addr"
        case .INSN_REM_FLOAT_2ADDR:
            return "rem-float/2addr"
        case .INSN_ADD_DOUBLE_2ADDR:
            return "add-double/2addr"
        case .INSN_SUB_DOUBLE_2ADDR:
            return "sub-double/2addr"
        case .INSN_MUL_DOUBLE_2ADDR:
            return "mul-double/2addr"
        case .INSN_DIV_DOUBLE_2ADDR:
            return "div-double/2addr"
        case .INSN_REM_DOUBLE_2ADDR:
            return "rem-double/2addr"
        case .INSN_ADD_INT_LIT16:
            return "add-int/lit16"
        case .INSN_RSUB_INT_LIT16:
            return "rsub-int"
        case .INSN_MUL_INT_LIT16:
            return "mul-int/lit16"
        case .INSN_DIV_INT_LIT16:
            return "div-int/lit16"
        case .INSN_REM_INT_LIT16:
            return "rem-int/lit16"
        case .INSN_AND_INT_LIT16:
            return "and-int/lit16"
        case .INSN_OR_INT_LIT16:
            return "or-int/lit16"
        case .INSN_XOR_INT_LIT16:
            return "xor-int/lit16"
        case .INSN_ADD_INT_LIT8:
            return "add-int/lit8"
        case .INSN_RSUB_INT_LIT8:
            return "rsub-int/lit8"
        case .INSN_MUL_INT_LIT8:
            return "mul-int/lit8"
        case .INSN_DIV_INT_LIT8:
            return "div-int/lit8"
        case .INSN_REM_INT_LIT8:
            return "rem-int/lit8"
        case .INSN_AND_INT_LIT8:
            return "and-int/lit8"
        case .INSN_OR_INT_LIT8:
            return "or-int/lit8"
        case .INSN_XOR_INT_LIT8:
            return "xor-int/lit8"
        case .INSN_SHL_INT_LIT8:
            return "shl-int/lit8"
        case .INSN_SHR_INT_LIT8:
            return "shr-int/lit8"
        case .INSN_USHR_INT_LIT8:
            return "ushr-int/lit8"
        case .INSN_INVOKE_POLYMORPHIC:
            return "invoke-polymorphic"
        case .INSN_INVOKE_POLYMORPHIC_RANGE:
            return "invoke-polymorphic/range"
        case .INSN_INVOKE_CUSTOM:
            return "invoke-custom"
        case .INSN_INVOKE_CUSTOM_RANGE:
            return "invoke-custom/range"
        case .INSN_CONST_METHOD_HANDLE:
            return "const-method-handle"
        case .INSN_CONST_METHOD_TYPE:
            return "const-method-type"
        case .INSN_RETURN:
            return "return"
        case .INSN_CONST_WIDE:
            return "const-wide"
        case .INSN_DOUBLE_TO_INT:
            return "double-to-int"
        case .INSN_DOUBLE_TO_LONG:
            return "double-to-long"
        case .INSN_DOUBLE_TO_FLOAT:
            return "double-to-float"
        }
    }
}
