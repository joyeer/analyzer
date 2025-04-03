//
//  Opcode+Printer.swift
//  Analyzer
//
//  Created by joyeer on 2024/12/14.
//

import Common

extension JOpcode {
    
    func print(printer: CodePrinter, ownerClass:Class) {
        printer.print(opcode: JVM_OPCODE_MAP[code]!)
        switch code {
        case OP_NOP,
             OP_ACONST_NULL,
             OP_ICONST_M1,
             OP_ICONST_0,
             OP_ICONST_1,
             OP_ICONST_2,
             OP_ICONST_3,
             OP_ICONST_4,
             OP_ICONST_5,
             OP_LCONST_0,
             OP_LCONST_1,
             OP_FCONST_0,
             OP_FCONST_1,
             OP_FCONST_2,
             OP_DCONST_0,
             OP_DCONST_1:
            break
        case OP_BIPUSH,
             OP_SIPUSH:
            printer.space()
            printer.print(number: String(value))
        case OP_LDC,
             OP_LDC_W,
             OP_LDC2_W:
            printer.space()
            printValue(printer: printer, index: value, constantPoolReader: ownerClass.reader)
        case OP_ILOAD,
             OP_LLOAD,
             OP_FLOAD,
             OP_DLOAD,
             OP_ALOAD:
            printer.space()
            printer.print(number: String(value))
        case OP_ILOAD_0,
             OP_ILOAD_1,
             OP_ILOAD_2,
             OP_ILOAD_3,
             OP_LLOAD_0,
             OP_LLOAD_1,
             OP_LLOAD_2,
             OP_LLOAD_3,
             OP_FLOAD_0,
             OP_FLOAD_1,
             OP_FLOAD_2,
             OP_FLOAD_3,
             OP_DLOAD_0,
             OP_DLOAD_1,
             OP_DLOAD_2,
             OP_DLOAD_3,
             OP_ALOAD_0,
             OP_ALOAD_1,
             OP_ALOAD_2,
             OP_ALOAD_3:
            break
        case OP_IALOAD,
             OP_LALOAD,
             OP_FALOAD,
             OP_DALOAD,
             OP_AALOAD,
             OP_BALOAD,
             OP_CALOAD,
             OP_SALOAD:
            break
        case OP_ISTORE,
             OP_LSTORE,
             OP_FSTORE,
             OP_DSTORE,
             OP_ASTORE:
            printer.space()
            printer.print(number: String(value))
        case OP_ISTORE_0,
             OP_ISTORE_1,
             OP_ISTORE_2,
             OP_ISTORE_3,
             OP_LSTORE_0,
             OP_LSTORE_1,
             OP_LSTORE_2,
             OP_LSTORE_3,
             OP_FSTORE_0,
             OP_FSTORE_1,
             OP_FSTORE_2,
             OP_FSTORE_3,
             OP_DSTORE_0,
             OP_DSTORE_1,
             OP_DSTORE_2,
             OP_DSTORE_3,
             OP_ASTORE_0,
             OP_ASTORE_1,
             OP_ASTORE_2,
             OP_ASTORE_3:
            break
        case OP_IASTORE,
             OP_LASTORE,
             OP_FASTORE,
             OP_DASTORE,
             OP_AASTORE,
             OP_BASTORE,
             OP_CASTORE,
             OP_SASTORE:
            break
        case OP_POP,
             OP_POP2:
            break
        case OP_DUP,
             OP_DUP_X1,
             OP_DUP_X2,
             OP_DUP2,
             OP_DUP2_X1,
             OP_DUP2_X2:
            break
        case OP_SWAP:
            break
        case OP_IADD,
             OP_LADD,
             OP_FADD,
             OP_DADD,
             OP_ISUB,
             OP_LSUB,
             OP_FSUB,
             OP_DSUB,
             OP_IMUL,
             OP_LMUL,
             OP_FMUL,
             OP_DMUL,
             OP_IDIV,
             OP_LDIV,
             OP_FDIV,
             OP_DDIV,
             OP_IREM,
             OP_LREM,
             OP_FREM,
             OP_DREM,
             OP_INEG,
             OP_LNEG,
             OP_FNEG,
             OP_DNEG,
             OP_ISHL,
             OP_LSHL,
             OP_ISHR,
             OP_LSHR,
             OP_IUSHR,
             OP_LUSHR,
             OP_IAND,
             OP_LAND,
             OP_IOR,
             OP_LOR,
             OP_IXOR,
             OP_LXOR:
            break
        case OP_IINC:
            printer.space()
            printer.print(number: String(value))
            printer.space()
            printer.print(number: String(value2))
        case OP_I2L,
             OP_I2F,
             OP_I2D,
             OP_L2I,
             OP_L2F,
             OP_L2D,
             OP_F2I,
             OP_F2L,
             OP_F2D,
             OP_D2I,
             OP_D2L,
             OP_D2F,
             OP_I2B,
             OP_I2C,
             OP_I2S:
            break
        case OP_LCMP,
             OP_FCMPL,
             OP_FCMPG,
             OP_DCMPL,
             OP_DCMPG:
            break
        case OP_IFEQ,
             OP_IFNE,
             OP_IFLT,
             OP_IFGE,
             OP_IFGT,
             OP_IFLE,
             OP_IF_ICMPEQ,
             OP_IF_ICMPNE,
             OP_IF_ICMPLT,
             OP_IF_ICMPGE,
             OP_IF_ICMPGT,
             OP_IF_ICMPLE,
             OP_IF_ACMPEQ,
             OP_IF_ACMPNE,
             OP_IFNULL,
             OP_IFNONNULL:
            printer.space()
            printer.print(branch: value)
        case OP_GETSTATIC:
            printer.space()
            printField(printer: printer, index: value, constantPoolReader: ownerClass.reader)
        case OP_PUTSTATIC:
            printer.space()
            printField(printer: printer, index: value, constantPoolReader: ownerClass.reader)
        case OP_GETFIELD:
            printer.space()
            printField(printer: printer, index: value, constantPoolReader: ownerClass.reader)
        case OP_PUTFIELD:
            printer.space()
            printField(printer: printer, index: value, constantPoolReader: ownerClass.reader)
        case OP_INVOKEVIRTUAL,
             OP_INVOKESPECIAL,
             OP_INVOKESTATIC,
             OP_INVOKEINTERFACE:
            printer.space()
            printInvokeMethod(printer: printer, index: value, constantPoolReader: ownerClass.reader)
        case OP_INVOKEDYNAMIC:
            printer.space()
            printInvokeDynamicMethod(printer: printer, index: value, constantPoolReader: ownerClass.reader)
        case OP_NEW:
            printer.space()
            printClassOrInterface(printer: printer, index: value, constantPoolReader: ownerClass.reader)
        case OP_NEWARRAY:
            printer.space()
            printAType(printer: printer, atype: value)
        case OP_ANEWARRAY:
            printer.space()
            printClassOrInterface(printer: printer, index: value, constantPoolReader: ownerClass.reader)
        case OP_ARRAYLENGTH:
            break
        case OP_ATHROW:
            break
        case OP_CHECKCAST:
            printer.space()
            printClassOrInterface(printer: printer, index: value, constantPoolReader: ownerClass.reader)
        case OP_INSTANCEOF:
            printer.space()
            printClassOrInterface(printer: printer, index: value, constantPoolReader: ownerClass.reader)
        case OP_MONITORENTER,
             OP_MONITOREXIT:
            break
        case OP_GOTO,
            OP_GOTO_W:
            printer.space()
            printer.print(branch: value)
        case OP_JSR,
             OP_JSR_W:
            printer.space()
            printer.print(branch: value)
        case OP_RET:
            printer.space()
            printer.print(number: String(value))
        case OP_TABLESWITCH:
            break
        case OP_LOOKUPSWITCH:
            break
        case OP_IRETURN,
             OP_LRETURN,
             OP_FRETURN,
             OP_DRETURN,
             OP_ARETURN,
             OP_RETURN:
            break
        case OP_WIDE:
            printer.space()
            printer.print(number: String(value))
        case OP_MULTIANEWARRAY:
            printer.space()
            printer.print(number: String(value))
        case OP_BREAKPOINT:
            break
        case OP_IMPDEP1:
            break
        case OP_IMPDEP2:
            break
        default:
            fatalError()
        }
    }
    
    private func printAType(printer: CodePrinter, atype: Int) {
        switch atype {
        case 4:
            printer.print(type: "Boolean")
        case 5:
            printer.print(type: "Char")
        case 6:
            printer.print(type: "Float")
        case 7:
            printer.print(type: "Double")
        case 8:
            printer.print(type: "Byte")
        case 9:
            printer.print(type: "Short")
        case 10:
            printer.print(type: "Integer")
        case 11:
            printer.print(type: "Long")
        default:
            break
        }
    }
    
    private func printValue(printer: CodePrinter, index: Int, constantPoolReader: ConstantPoolReader) {
        let info = constantPoolReader.read(index)
        if info is CONSTANT_String_info  {
            let stringValue = constantPoolReader.readString(index)
            printer.print(string: stringValue)
            return
        }
        
        if info is CONSTANT_Integer_info {
            let intValue = constantPoolReader.readInteger(index)
            printer.print(number: String(intValue))
            return
        }
        
        if info is CONSTANT_Double_info {
            let doubleValue = constantPoolReader.readDouble(index)
            printer.print(number: String(doubleValue))
            return
        }
        
        if info is CONSTANT_Class_info, let classValue = try? constantPoolReader.readClassInfo(index) {
            printer.print(type: classValue.descriptor)
            printer.print(text: ".")
            printer.print(keyword: "class")
            return
        }
        
        if info is CONSTANT_Long_info {
            let longValue = constantPoolReader.readLong(index)
            printer.print(number: String(longValue))
            return
        }
        
        if info is CONSTANT_Float_info {
            let floatValue = constantPoolReader.readFloat(index)
            printer.print(number: String(floatValue))
            return
        }
        
        fatalError()
    }
    
    private func printField(printer: CodePrinter, index:Int, constantPoolReader: ConstantPoolReader) {
        guard let info = try? constantPoolReader.readFieldInfo(index) else {
            fatalError()
        }
        
        printer.print(type: "L\(info.ownerClass.descriptor);")
        printer.print(text: ".")
        printer.print(type: info.fieldName)
    }
    
    private func printClassOrInterface(printer: CodePrinter, index:Int, constantPoolReader: ConstantPoolReader) {
        guard let info = try? constantPoolReader.readClassInfo(index) else {
            fatalError()
        }
           
        printer.print(type: "L\(info.descriptor);")
    }
    
    private func printInvokeMethod(printer: CodePrinter, index:Int, constantPoolReader:ConstantPoolReader) {
        
        if let info = try? constantPoolReader.readMethodInfo(index) {
            printer.print(type: "L\(info.ownerClass.descriptor);")
            printer.print(text: ".")
            printer.print(text: info.methodName)
            printer.print(text: " (")
            
            for (index, param) in info.descriptor.parameters.enumerated() {
                if index > 0 {
                    printer.print(text: ", ")
                }
                printer.print(type: param.descriptor)
            }
            printer.print(text: ")")
        }
    }

    private func printInvokeDynamicMethod(printer: CodePrinter, index: Int, constantPoolReader: ConstantPoolReader) {
        
        let methodInfo = constantPoolReader.read(index) as! CONSTANT_InvokeDynamic_info
        
        let nameAndType = constantPoolReader.readNameAndTypeInfo(methodInfo.name_and_type_index)
        
        printer.print(text: nameAndType.name)
        printer.print(text: nameAndType.typeDescriptor)
    }
}
