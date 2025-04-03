//
//  AttributeInfo.swift
//  JavaDecompiler
//
//  Created by Qing Xu on 23/01/2018.
//

import Common

// MARK: - Attributes
protocol AttributeInfo {
    var name: String { get }
}

struct CustomAttributeInfo : AttributeInfo {
    let name: String
    init(_ input:DataInputStream, attributeName:String, attributeLength:Int) throws {
        name = attributeName
        _ = try input.readBytes(attributeLength)
    }
}

// MARK: - Code attribute
// Code_attribute {
//      u2 attribute_name_index;
//      u4 attribute_length;
//      u2 max_stack;
//      u2 max_locals;
//      u4 code_length;
//      u1 code[code_length];
//      u2 exception_table_length;
//      {   u2 start_pc;
//          u2 end_pc;
//          u2 handler_pc;
//          u2 catch_type;
//      } exception_table[exception_table_length];
//      u2 attributes_count;
//      attribute_info attributes[attributes_count];
//  }
struct CodeAttributeInfo : AttributeInfo {
    
    struct ExceptionTable {
        let start_pc: Int
        let end_pc: Int
        let handler_pc: Int
        let catch_type: Int
        
        init(_ input: DataInputStream) throws {
            start_pc = Int(try input.readU2())
            end_pc = Int(try input.readU2())
            handler_pc = Int(try input.readU2())
            catch_type = Int(try input.readU2())
        }
    }
    
    let name = AttributeReader.Code
    let max_stack: UInt16
    let max_locals: UInt16
    let code: [UInt8]
    let exceptions: [ExceptionTable]
    let attributes: [AttributeInfo]
    
    init(_ input:DataInputStream, constant reader: ConstantPoolReader) throws {
        max_stack = try input.readU2()
        max_locals = try input.readU2()
        let code_length = try input.readU4()
        code = try input.readBytes(Int(code_length))
        
        let exception_table_length = try input.readU2()
        var exception_table = [ExceptionTable]()
        
        for _ in 0 ..< exception_table_length {
            let table = try ExceptionTable(input)
            exception_table.append(table)
        }
        self.exceptions = exception_table
        
        let attribute_count = try input.readU2()
        var attributes = [AttributeInfo]()
        for _ in 0 ..< attribute_count {
            let attributeReader = AttributeReader(input, constant:reader)
            let attribute = try attributeReader.read()
            attributes.append(attribute)
        }
        self.attributes = attributes
    }
}

//  ConstantValue_attribute {
//      u2 attribute_name_index;
//      u4 attribute_length;
//      u2 constantvalue_index;
//  }
struct ConstantValueAttributeInfo : AttributeInfo {
    let name = AttributeReader.ConstantValue
    let constantvalue_index: Int
    
    init(_ input:DataInputStream) throws {
        constantvalue_index = Int(try input.readU2())
    }
}

// StackMapTable_attribute {
//    u2              attribute_name_index;
//    u4              attribute_length;
//    u2              number_of_entries;
//    stack_map_frame entries[number_of_entries];
// }
struct StackMapTableAttributeInfo : AttributeInfo {
    
    // union verification_type_info {
    //  Top_variable_info;
    //  Integer_variable_info;
    //  Float_variable_info;
    //  Long_variable_info;
    //  Double_variable_info;
    //  Null_variable_info;
    //  UninitializedThis_variable_info;
    //  Object_variable_info;
    //  Uninitialized_variable_info;
    // }

    enum VerificationTypeInfo {
        static let ITEM_Top:UInt8 = 0
        static let ITEM_Integer:UInt8 = 1
        static let ITEM_Float:UInt8 = 2
        static let ITEM_Double:UInt8 = 3
        static let ITEM_Long:UInt8 = 4
        static let ITEM_Null:UInt8 =  5
        static let ITEM_UninitializedThis:UInt8 = 6
        static let ITEM_Object: UInt8 = 7
        static let ITEM_Uninitialized: UInt8 = 8
        
        struct TopVariableInfo {
            let tag = ITEM_Top;
        }
        
        struct IntegerVariableInfo {
            let tag = ITEM_Integer
        }
        
        struct FloatVariableInfo {
            let tag = ITEM_Float
        }
        
        struct NullVariableInfo {
            let tag = ITEM_Null
        }
        
        struct UninitializedThisVariableInfo {
            let tag = ITEM_UninitializedThis
        }
        
        struct ObjectVariableInfo {
            let tag = ITEM_Object
            let cpool_index: UInt16
        }
        
        struct UninitializedVariableInfo {
            let tag = ITEM_Uninitialized
            let offset: UInt16
        }
        
        struct LongVariableInfo {
            let tag = ITEM_Long
        }
        
        struct DoubleVariableInfo {
            let tag = ITEM_Double
        }
        
        case Top_variable_info(TopVariableInfo)
        case Integer_variable_info(IntegerVariableInfo)
        case Float_variable_info(FloatVariableInfo)
        case Null_variable_info(NullVariableInfo)
        case UninitializedThis_variable_info(UninitializedThisVariableInfo)
        case Object_variable_info(ObjectVariableInfo)
        case Uninitialized_variable_info(UninitializedVariableInfo)
        case Long_variable_info(LongVariableInfo)
        case Double_variable_info(DoubleVariableInfo)

    }
    
    internal static func readVerificationTypeInfo(_ input:DataInputStream) throws -> VerificationTypeInfo{
        let tag = try input.readU()
        switch tag {
        case VerificationTypeInfo.ITEM_Top:
            return VerificationTypeInfo.Top_variable_info(VerificationTypeInfo.TopVariableInfo())
        case VerificationTypeInfo.ITEM_Integer:
            return VerificationTypeInfo.Integer_variable_info(VerificationTypeInfo.IntegerVariableInfo())
        case VerificationTypeInfo.ITEM_Float:
            return VerificationTypeInfo.Float_variable_info(VerificationTypeInfo.FloatVariableInfo())
        case VerificationTypeInfo.ITEM_Null:
            return VerificationTypeInfo.Null_variable_info(VerificationTypeInfo.NullVariableInfo())
        case VerificationTypeInfo.ITEM_UninitializedThis:
            return VerificationTypeInfo.UninitializedThis_variable_info(VerificationTypeInfo.UninitializedThisVariableInfo())
        case VerificationTypeInfo.ITEM_Object:
            let cpool_index = try input.readU2()
            return VerificationTypeInfo.Object_variable_info(VerificationTypeInfo.ObjectVariableInfo(cpool_index:cpool_index))
        case VerificationTypeInfo.ITEM_Uninitialized:
            let offset = try input.readU2()
            return VerificationTypeInfo.Uninitialized_variable_info(VerificationTypeInfo.UninitializedVariableInfo(offset: offset))
        case VerificationTypeInfo.ITEM_Long:
            return VerificationTypeInfo.Long_variable_info(VerificationTypeInfo.LongVariableInfo())
        case VerificationTypeInfo.ITEM_Double:
            return VerificationTypeInfo.Double_variable_info(VerificationTypeInfo.DoubleVariableInfo())
        default:
            throw ClassFileReaderError.formatError
        }
    }
    
    // union stack_map_frame {
    //  same_frame;
    //  same_locals_1_stack_item_frame;
    //  same_locals_1_stack_item_frame_extended;
    //  chop_frame;
    //  same_frame_extended;
    //  append_frame;
    // full_frame;
    // }
    enum StackMapFrame {
        
        // same_frame {
        //  u1 frame_type = SAME; /* 0-63 */
        // }
        struct SameFrame {
            let frame_type: UInt8
            init(_ frame_type: UInt8) {
                self.frame_type = frame_type
            }
            
            func getOffsetDelta() -> Int {
                return Int(frame_type)
            }
        }
        
        // same_locals_1_stack_item_frame {
        //  u1 frame_type = SAME_LOCALS_1_STACK_ITEM; /* 64-127 */
        //  verification_type_info stack[1];
        // }
        struct SameLocals1StackItemFrame {
            let frame_type: UInt8
            let stack: VerificationTypeInfo
            
            func getOffsetDelta() -> Int {
                return Int(frame_type) - 64
            }
        }
        
        // same_locals_1_stack_item_frame {
        //  u1 frame_type = SAME_LOCALS_1_STACK_ITEM; /* 64-127 */
        //  verification_type_info stack[1];
        // }
        struct SameLocals1StackItemFrameExtended {
            let frame_type: UInt8
            let offset_delta: UInt16
            let stack: VerificationTypeInfo
            
            func getOffsetDelta() -> Int {
                return Int(offset_delta)
            }
        }
        
        // chop_frame {
        //  u1 frame_type = CHOP; /* 248-250 */
        //  u2 offset_delta;
        // }
        struct ChopFrame {
            let frame_type: UInt8
            let offset_delta: UInt16
            
            func getOffsetDelta() -> Int {
                return Int(offset_delta)
            }
        }
        
        // same_frame_extended {
        //  u1 frame_type = SAME_FRAME_EXTENDED; /* 251 */
        //  u2 offset_delta;
        // }
        struct SameFrameExtended {
            let frame_type: UInt8
            let offset_delta: UInt16
            
            func getOffsetDelta() -> Int {
                return Int(offset_delta)
            }
        }
        
        // append_frame {
        //  u1 frame_type = APPEND; /* 252-254 */
        //  u2 offset_delta;
        //  verification_type_info locals[frame_type - 251];
        // }
        struct AppendFrame {
            let frame_type : UInt8
            let offset_delta: UInt16
            let locals:[VerificationTypeInfo]
            
            func getOffsetDelta() -> Int {
                return Int(offset_delta)
            }
        }
        
        // full_frame {
        //  u1 frame_type = FULL_FRAME; /* 255 */
        //  u2 offset_delta;
        //  u2 number_of_locals;
        //  verification_type_info locals[number_of_locals];
        //  u2 number_of_stack_items;
        //  verification_type_info stack[number_of_stack_items];
        // }
        struct FullFrame {
            let frame_type :UInt8
            let offset_delta: UInt16
            let locals:[VerificationTypeInfo]
            let stack:[VerificationTypeInfo]
            
            func getOffsetDelta() -> Int {
                return Int(offset_delta)
            }
        }
        
        case same_frame(SameFrame)
        case same_locals_1_stack_item_frame(SameLocals1StackItemFrame)
        case same_locals_1_stack_item_frame_extended(SameLocals1StackItemFrameExtended)
        case chop_frame(ChopFrame)
        case same_frame_extended(SameFrameExtended)
        case append_frame(AppendFrame)
        case full_frame(FullFrame)
        
        var same_frame:SameFrame? {
            switch(self) {
            case .same_frame(let frame):
                return frame;
            default:
                return nil
            }
        }
        
        var same_locals_1_stack_item_frame:SameLocals1StackItemFrame? {
            switch self {
            case .same_locals_1_stack_item_frame(let frame):
                return frame
            default:
                return nil
            }
        }
        
        var same_locals_1_stack_item_frame_extended:SameLocals1StackItemFrameExtended? {
            switch self {
            case .same_locals_1_stack_item_frame_extended(let frame):
                return frame
            default:
                return nil
            }
        }
        
        var chop_frame:ChopFrame? {
            switch self {
            case .chop_frame(let frame):
                return frame
            default:
                return nil
            }
        }
        
        var same_frame_extended:SameFrameExtended? {
            switch self {
            case .same_frame_extended(let frame):
                return frame
            default:
                return nil
            }
        }
        
        var append_frame:AppendFrame? {
            switch self {
            case .append_frame(let frame):
                return frame
            default:
                return nil
            }
        }
        
        var full_frame:FullFrame? {
            switch self {
            case .full_frame(let frame):
                return frame
            default:
                return nil
            }
        }
    }
    
    let name = AttributeReader.StackMapTable
    let entries :[StackMapFrame]
    
    init(_ input: DataInputStream) throws {
        let number_of_entries = try input.readU2()
        var entries = [StackMapFrame]()
        for _ in 0 ..< number_of_entries {
            
            let frame_type = try input.readU()
            var frame: StackMapFrame? = nil
            if frame_type >= 0 && frame_type <= 63 {
                frame = StackMapFrame.same_frame(StackMapFrame.SameFrame(frame_type))
            } else if frame_type >= 64 && frame_type <= 127 {
                let stack = try StackMapTableAttributeInfo.readVerificationTypeInfo(input)
                frame = StackMapFrame.same_locals_1_stack_item_frame(StackMapFrame.SameLocals1StackItemFrame(frame_type: frame_type, stack: stack))
            } else if frame_type == 247 {
                let offset_delta = try input.readU2()
                let stack = try StackMapTableAttributeInfo.readVerificationTypeInfo(input)
                frame = StackMapFrame.same_locals_1_stack_item_frame_extended(StackMapTableAttributeInfo.StackMapFrame.SameLocals1StackItemFrameExtended(frame_type: frame_type, offset_delta: offset_delta, stack: stack))
            } else if frame_type >= 248 && frame_type <= 250 {
                let offset_delta = try input.readU2()
                frame = StackMapFrame.chop_frame(StackMapTableAttributeInfo.StackMapFrame.ChopFrame(frame_type: frame_type, offset_delta: offset_delta))
            } else if frame_type == 251 {
                let offset_delta = try input.readU2()
                frame = StackMapFrame.same_frame_extended(StackMapTableAttributeInfo.StackMapFrame.SameFrameExtended(frame_type: frame_type, offset_delta: offset_delta))
            } else if frame_type >= 252 && frame_type <= 254 {
                let offset_delta = try input.readU2()
                var locals = [VerificationTypeInfo]()
                for _ in 0 ..< (frame_type - 251) {
                    locals.append(try StackMapTableAttributeInfo.readVerificationTypeInfo(input))
                }
                frame = StackMapFrame.append_frame(StackMapTableAttributeInfo.StackMapFrame.AppendFrame(frame_type: frame_type, offset_delta: offset_delta, locals: locals))
            } else if frame_type == 255 {
                let offset_delta = try input.readU2()
                let number_of_locals = try input.readU2()
                var locals = [VerificationTypeInfo]()
                for _ in 0 ..< number_of_locals {
                    locals.append(try StackMapTableAttributeInfo.readVerificationTypeInfo(input))
                }
                let number_of_stack_items = try input.readU2()
                var stack = [VerificationTypeInfo]()
                for _ in 0 ..< number_of_stack_items {
                    stack.append(try StackMapTableAttributeInfo.readVerificationTypeInfo(input))
                }
                frame = StackMapFrame.full_frame(StackMapTableAttributeInfo.StackMapFrame.FullFrame(frame_type: frame_type, offset_delta: offset_delta, locals: locals, stack: stack))
            } else {
                throw ClassFileReaderError.formatError
            }
            

            entries.append(frame!)
        }
        self.entries = entries
    }
}

// Exceptions_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
//  u2 number_of_exceptions;
//  u2 exception_index_table[number_of_exceptions];
// }
struct ExceptionsAttributeInfo : AttributeInfo {
    let name = AttributeReader.Exceptions
    let exception_index_table: [UInt16]
    init(_ input:DataInputStream) throws {
        var table = [UInt16]()
        let number_of_exceptions = try input.readU2()
        for _ in 0 ..< number_of_exceptions {
            table.append(try input.readU2())
        }
        self.exception_index_table = table
    }
}


// InnerClasses_attribute {
//    u2 attribute_name_index;
//    u4 attribute_length;
//    u2 number_of_classes;
//    {   u2 inner_class_info_index;
//        u2 outer_class_info_index;
//        u2 inner_name_index;
//        u2 inner_class_access_flags;
//    } classes[number_of_classes];
// }
struct InnerClassesAttributeInfo: AttributeInfo {
    
    struct InnerClass {
        let inner_class_info_index: UInt16;
        let outer_class_info_index: UInt16;
        let inner_name_index: UInt16;
        let inner_class_access_flags: UInt16;
        
        init(_ input: DataInputStream) throws {
            inner_class_info_index = try input.readU2()
            outer_class_info_index = try input.readU2()
            inner_name_index = try input.readU2()
            inner_class_access_flags = try input.readU2()
        }
    }

    let name = AttributeReader.InnerClasses
    let classes: [InnerClassesAttributeInfo.InnerClass]
    
    init(_ input: DataInputStream) throws {
        let number_of_classes = try input.readU2()
        var classes = [InnerClass]()
        for _ in 0 ..< number_of_classes {
            let inner_class = try InnerClass(input)
            classes.append(inner_class)
        }
        self.classes = classes
    }
}

// EnclosingMethod_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
//  u2 class_index;
//  u2 method_index;
// }
struct EnclosingMethodAttributeInfo: AttributeInfo {
    let name = AttributeReader.EnclosingMethod
    let class_index: UInt16
    let method_index: UInt16
    
    init(_ input: DataInputStream) throws {
        class_index = try input.readU2()
        method_index = try input.readU2()
    }
}

// Synthetic_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
// }
struct SyntheticAttributeInfo : AttributeInfo {
    let name = AttributeReader.Synthetic
}

// Signature_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
//  u2 signature_index;
// }
struct SignatureAttributeInfo : AttributeInfo {
    let name = AttributeReader.Signature
    let signature_index: UInt16
    
    init(_ input: DataInputStream) throws {
        signature_index = try input.readU2()
    }
}

// SourceFile_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
//  u2 sourcefile_index;
// }
struct SourceFileAttributeInfo : AttributeInfo {
    let name = AttributeReader.SourceFile
    let sourcefile_index: UInt16
    
    init(_ input: DataInputStream) throws {
        sourcefile_index = try input.readU2()
    }
}

// SourceDebugExtension_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
//  u1 debug_extension[attribute_length];
// }
struct SourceDebugExtensionAttributeInfo : AttributeInfo {
    let name: String = AttributeReader.SourceDebugExtension
    let debug_extension:[UInt8]
    init(_ input:DataInputStream, _ length:Int) throws {
        debug_extension = try input.readBytes(length)
    }
}


// LineNumberTable_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
//  u2 line_number_table_length;
//  {
//      u2 start_pc;
//      u2 line_number;
//  } line_number_table[line_number_table_length];
// }
struct LineNumberTableAttributeInfo : AttributeInfo {
    
    struct LineNumberTable {
        let start_pc: UInt16
        let line_number: UInt16
    }
    
    let name = AttributeReader.LineNumberTable
    let line_number_tables:[LineNumberTable]
    
    init(_ input:DataInputStream) throws {
        let line_number_table_length  = try input.readU2()
        var tables = [LineNumberTable]()
        for _ in 0 ..< line_number_table_length {
            let start_pc = try input.readU2()
            let line_number = try input.readU2()
            tables.append(LineNumberTableAttributeInfo.LineNumberTable(start_pc: start_pc, line_number: line_number))
        }
        self.line_number_tables = tables
    }
}

// LocalVariableTable_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
//  u2 local_variable_table_length;
//  {   u2 start_pc;
//      u2 length;
//      u2 name_index;
//      u2 descriptor_index;
//      u2 index;
//  } local_variable_table[local_variable_table_length];
// }

struct LocalVariableTableAttributeInfo : AttributeInfo {
    struct LocalVariableTable {
        let start_pc: Int
        let length: Int
        let name_index: Int
        let descriptor_index: Int
        let index: Int
        
        init(_ input:DataInputStream) throws {
            start_pc = Int(try input.readU2())
            length = Int(try input.readU2())
            name_index = Int(try input.readU2())
            descriptor_index = Int(try input.readU2())
            index = Int(try input.readU2())
        }
    }

    let name = AttributeReader.LocalVariableTable
    let local_variable_tables:[LocalVariableTable]
    
    init(_ input: DataInputStream) throws {
        let local_variable_table_length = try input.readU2()
        var tables = [LocalVariableTable]()
        for _ in 0 ..< local_variable_table_length {
            tables.append(try LocalVariableTable(input))
        }
        self.local_variable_tables = tables
    }
}


// LocalVariableTypeTable_attribute {
//    u2 attribute_name_index;
//    u4 attribute_length;
//    u2 local_variable_type_table_length;
//    {   u2 start_pc;
//        u2 length;
//        u2 name_index;
//        u2 signature_index;
//        u2 index;
//    } local_variable_type_table[local_variable_type_table_length];
// }
struct LocalVariableTypeTableAttributeInfo : AttributeInfo {
    struct LocalVariableTypeTable {
        let start_pc: UInt16
        let length: UInt16
        let name_index: UInt16
        let signature_index: UInt16
        let index: UInt16
        init(_ input:DataInputStream) throws {
            start_pc = try input.readU2()
            length = try input.readU2()
            name_index = try input.readU2()
            signature_index = try input.readU2()
            index = try input.readU2()
        }
    }

    let name = AttributeReader.LocalVariableTypeTable
    let tables:[LocalVariableTypeTable]
    init(_ input: DataInputStream) throws {
        let local_variable_type_table_length = try input.readU2()
        var tables = [LocalVariableTypeTable]()
        for _ in 0 ..< local_variable_type_table_length {
            tables.append(try LocalVariableTypeTable(input))
        }
        self.tables = tables
    }
}

// Deprecated_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
// }
struct DeprecatedAttributeInfo : AttributeInfo {
    let name = AttributeReader.Deprecated
}

// RuntimeVisibleAnnotations_attribute {
//  u2         attribute_name_index;
//  u4         attribute_length;
//  u2         num_annotations;
//  annotation annotations[num_annotations];
// }

struct RuntimeVisibleAnnotationsAttributeInfo : AttributeInfo {
    let name = AttributeReader.RuntimeVisibleAnnotations
    let annotations:[AnnotationAttr]
    init(_ input:DataInputStream, reader: ConstantPoolReader) throws {
        let num_annotations = try input.readU2()
        var annotations = [AnnotationAttr]()
        for _ in 0 ..< num_annotations {
            annotations.append(try AnnotationAttr(input, reader: reader))
        }
        self.annotations = annotations
    }
}

// RuntimeInvisibleAnnotations_attribute {
//  u2         attribute_name_index;
//  u4         attribute_length;
//  u2         num_annotations;
//  annotation annotations[num_annotations];
// }
struct RuntimeInvisibleAnnotationsAttributeInfo : AttributeInfo {
    let name = AttributeReader.RuntimeInvisibleAnnotations
    let annotations:[AnnotationAttr]
    
    init(_ input: DataInputStream, reader: ConstantPoolReader) throws {
        let num_annotations = try input.readU2()
        var annotations = [AnnotationAttr]()
        for _ in 0 ..< num_annotations {
            annotations.append(try AnnotationAttr(input, reader: reader))
        }
        self.annotations = annotations
    }
}

// RuntimeVisibleParameterAnnotations_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
//  u1 num_parameters;
//  {   u2         num_annotations;
//      annotation annotations[num_annotations];
//  } parameter_annotations[num_parameters];
// }
struct RuntimeVisibleParameterAnnotationsAttribute : AttributeInfo {
    let name = AttributeReader.RuntimeVisibleParameterAnnotations
    let parameter_annotations: [ParameterAnnotation]
    init(_ input:DataInputStream, reader: ConstantPoolReader) throws {
        let num_parameters = try input.readU()
        var annotations = [ParameterAnnotation]()
        for _ in 0 ..< num_parameters {
            annotations.append(try ParameterAnnotation(input, reader: reader))
        }
        self.parameter_annotations = annotations
    }
}

// RuntimeInvisibleParameterAnnotations_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
//  u1 num_parameters;
//  {   u2         num_annotations;
//      annotation annotations[num_annotations];
//  } parameter_annotations[num_parameters];
// }
struct RuntimeInvisibleParameterAnnotationsAttributeInfo : AttributeInfo {
    let name = AttributeReader.RuntimeInvisibleParameterAnnotations
    let parameter_annotations:[ParameterAnnotation]
    
    init(_ input:DataInputStream, reader: ConstantPoolReader) throws {
        let num_parameters = try input.readU()
        var parameter_annotations = [ParameterAnnotation]()
        for _ in 0 ..< num_parameters {
            parameter_annotations.append(try ParameterAnnotation(input, reader: reader))
        }
        self.parameter_annotations = parameter_annotations
    }
}

struct RuntimeVisibleTypeAnnotations_attribute : AttributeInfo {
    let name: String
}


// RuntimeInvisibleTypeAnnotations_attribute {
//    u2              attribute_name_index;
//    u4              attribute_length;
//    u2              num_annotations;
//    type_annotation annotations[num_annotations];
// }
struct RuntimeInvisibleTypeAnnotationsAttribute : AttributeInfo {
    let name = AttributeReader.RuntimeInvisibleTypeAnnotations
    let annotations: [TypeAnnotation]
    
    init(_ input: DataInputStream, reader: ConstantPoolReader) throws {
        var annotations = [TypeAnnotation]()
        let num_annotations = try input.readU2()
        for _ in 0 ..< num_annotations {
            annotations.append(try TypeAnnotation(input, reader: reader))
        }
        self.annotations = annotations
    }
}

// AnnotationDefault_attribute {
//  u2            attribute_name_index;
//  u4            attribute_length;
//  element_value default_value;
// }
struct AnnotationDefaultAttributeInfo : AttributeInfo {
    let name = AttributeReader.AnnotationDefault
    let default_value: ElementValue
    
    init(_ input:DataInputStream, reader: ConstantPoolReader) throws {
        let valueReader = ElementValueReader(input)
        default_value = try valueReader.read(reader: reader)
    }
}


// BootstrapMethods_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
//  u2 num_bootstrap_methods;
//  {   u2 bootstrap_method_ref;
//      u2 num_bootstrap_arguments;
//      u2 bootstrap_arguments[num_bootstrap_arguments];
//  } bootstrap_methods[num_bootstrap_methods];
// }
struct BootstrapMethodsAttributeInfo : AttributeInfo {
    struct BootstrapMethod {
        let bootstrap_method_ref: UInt16
        let bootstrap_arguments: [UInt16]
        init(_ input: DataInputStream) throws {
            bootstrap_method_ref = try input.readU2()
            let num_bootstrap_arguments = try input.readU2()
            var arguments = [UInt16]()
            for _ in 0 ..< num_bootstrap_arguments {
                arguments.append(try input.readU2())
            }
            self.bootstrap_arguments = arguments
        }
    }

    let name = AttributeReader.BootstrapMethods
    let bootstrap_methods:[BootstrapMethod]
    init(_ input: DataInputStream) throws {
        let num_boostrap_methods = try input.readU2()
        var methods = [BootstrapMethod]()
        for _ in 0 ..< num_boostrap_methods {
            methods.append(try BootstrapMethod(input))
        }
        self.bootstrap_methods = methods
    }
}

struct MethodParameters_attribute : AttributeInfo {
    struct parameter {
        let name_index: UInt16
        let access_flags: UInt16
        
        init(_ input: DataInputStream) throws {
            name_index = try input.readU2()
            access_flags = try input.readU2()
        }
    }
    
    let name = AttributeReader.MethodParameters
    let parameters: [parameter]
    
    init(_ input: DataInputStream) throws {
        let parameters_count = try input.readU()
        var parameters = [parameter]()
        for _ in 0 ..< parameters_count {
            parameters.append(try parameter(input))
        }
        self.parameters = parameters
    }
    
    
}

struct Unknown_attribute: AttributeInfo {
    let name: String
    let info: [UInt8]
}

struct Module_attribute: AttributeInfo {
    struct require {
        let requires_index: UInt16
        let requires_flags: UInt16
        let requires_version_index: UInt16
        
        init(_ input: DataInputStream) throws {
            requires_index = try input.readU2()
            requires_flags = try input.readU2()
            requires_version_index = try input.readU2()
        }
    }
    
    struct export {
        let exports_index: UInt16
        let exports_flags: UInt16
        let exports_to_index: [UInt16]
        
        init(_ input: DataInputStream) throws {
            exports_index = try input.readU2()
            exports_flags = try input.readU2()
            let exports_to_count = try input.readU2()
            var exports_to_index = [UInt16]()
            for _ in 0 ..< exports_to_count {
                exports_to_index.append(try input.readU2())
            }
            self.exports_to_index = exports_to_index
        }
    }
    
    struct open {
        let opens_index: UInt16
        let opens_flags: UInt16
        let opens_to_index: [UInt16]
        
        init(_ input: DataInputStream) throws {
            opens_index = try input.readU2()
            opens_flags = try input.readU2()
            let opens_to_count = try input.readU2()
            var opens_to_index = [UInt16]()
            for _ in 0 ..< opens_to_count {
                opens_to_index.append(try input.readU2())
            }
            self.opens_to_index = opens_to_index
        }
    }
    
    struct provide {
        let provides_index: UInt16
        let provides_with_index: [UInt16]
        
        init(_ input: DataInputStream) throws {
            provides_index = try input.readU2()
            let provides_with_count = try input.readU2()
            var provides_with_index = [UInt16]()
            for _ in 0 ..< provides_with_count {
                provides_with_index.append(try input.readU2())
            }
            self.provides_with_index = provides_with_index
        }
    }
    
    let name = AttributeReader.Module
    let module_name_index :UInt16
    let module_flags: UInt16
    let module_version_index: UInt16
    let requires: [require]
    let exports: [export]
    let opens: [open]
    let uses_index: [UInt16]
    let provides: [provide]
    
    init(_ input: DataInputStream) throws {
        module_name_index = try input.readU2()
        module_flags = try input.readU2()
        module_version_index = try input.readU2()
        
        let requires_count = try input.readU2()
        var requires = [require]()
        for _ in 0 ..< requires_count {
            requires.append(try require(input))
        }
        self.requires = requires
        
        let exports_count = try input.readU2()
        var exports = [export]()
        for _ in 0 ..< exports_count {
            exports.append(try export(input))
        }
        self.exports = exports
        
        let opens_count = try input.readU2()
        var opens = [open]()
        for _ in 0 ..< opens_count {
            opens.append(try open(input))
        }
        self.opens = opens
        
        let uses_count = try input.readU2()
        var uses_index = [UInt16]()
        for _ in 0 ..< uses_count {
            uses_index.append(try input.readU2())
        }
        self.uses_index = uses_index
        
        let provides_count = try input.readU2()
        var provides = [provide]()
        for _ in 0 ..< provides_count {
            provides.append(try provide(input))
        }
        self.provides = provides
        
    }
}

struct ModulePackages_attribute: AttributeInfo {
    let name = AttributeReader.ModulePackages
    let package_index: [UInt16]
    
    init(_ input: DataInputStream) throws {
        let package_count = try input.readU2()
        var package_index = [UInt16]()
        for _ in 0 ..< package_count {
            package_index.append(try input.readU2())
        }
        self.package_index = package_index
    }
}

struct ModuleTarget_attribute : AttributeInfo {
    let name = AttributeReader.ModuleTarget
    let os_arch_index: UInt16
    
    init(_ input: DataInputStream) throws {
        os_arch_index = try input.readU2()
    }
}

struct NestHost_attribute: AttributeInfo {
    let name = AttributeReader.NestHost
    let host_class_index: UInt16
    
    init(_ input: DataInputStream) throws {
        host_class_index = try input.readU2()
    }
}

struct NestMembers_attribute: AttributeInfo {
    let name = AttributeReader.NestMembers
    let classes: [UInt16]
    
    init(_ input: DataInputStream) throws {
        let number_of_classes = try input.readU2()
        var classes = [UInt16]()
        for _ in 0 ..< number_of_classes {
            classes.append(try input.readU2())
        }
        self.classes = classes
    }
}

class AttributeReader {
    static let ConstantValue = "ConstantValue"
    static let Code = "Code"
    static let StackMapTable = "StackMapTable"
    static let Exceptions = "Exceptions"
    static let InnerClasses = "InnerClasses"
    static let EnclosingMethod = "EnclosingMethod"
    static let Synthetic = "Synthetic"
    static let Signature = "Signature"
    static let SourceFile = "SourceFile"
    static let SourceDebugExtension = "SourceDebugExtension"
    static let LineNumberTable = "LineNumberTable"
    static let LocalVariableTable = "LocalVariableTable"
    static let LocalVariableTypeTable = "LocalVariableTypeTable"
    static let Deprecated = "Deprecated"
    static let RuntimeVisibleAnnotations = "RuntimeVisibleAnnotations"
    static let RuntimeInvisibleAnnotations = "RuntimeInvisibleAnnotations"
    static let RuntimeVisibleParameterAnnotations = "RuntimeVisibleParameterAnnotations"
    static let RuntimeInvisibleParameterAnnotations = "RuntimeInvisibleParameterAnnotations"
    static let RuntimeVisibleTypeAnnotations = "RuntimeVisibleTypeAnnotations"
    static let RuntimeInvisibleTypeAnnotations = "RuntimeInvisibleTypeAnnotations"
    static let AnnotationDefault = "AnnotationDefault"
    static let BootstrapMethods = "BootstrapMethods"
    static let MethodParameters = "MethodParameters"
    static let Module = "Module"
    static let ModulePackages = "ModulePackages"
    static let ModuleMainClass = "ModuleMainClass"
    static let NestHost = "NestHost"
    static let NestMembers = "NestMembers"
    static let ModuleTarget = "ModuleTarget"
    
    nonisolated(unsafe) private static let attribute_reader: [String: (DataInputStream, ConstantPoolReader, Int) throws -> AttributeInfo] = [
        AttributeReader.ConstantValue : { (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try ConstantValueAttributeInfo(input)
        },
        AttributeReader.StackMapTable : { (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try StackMapTableAttributeInfo(input)
        },
        AttributeReader.Code : { (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try CodeAttributeInfo(input, constant:reader)
        },
        AttributeReader.Exceptions: { (input: DataInputStream, _ : ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try ExceptionsAttributeInfo(input)
        },
        AttributeReader.InnerClasses :{ (input: DataInputStream , _ : ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try InnerClassesAttributeInfo(input)
        },
        AttributeReader.EnclosingMethod : { (input : DataInputStream, _ : ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try EnclosingMethodAttributeInfo(input)
        },
        AttributeReader.Synthetic : { ( input: DataInputStream, _: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return SyntheticAttributeInfo()
        },
        AttributeReader.Signature : { (input : DataInputStream, _ : ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try SignatureAttributeInfo(input)
        },
        AttributeReader.SourceFile : { (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try SourceFileAttributeInfo(input)
        },
        AttributeReader.Deprecated : { ( _: DataInputStream, _: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return DeprecatedAttributeInfo()
        },
        AttributeReader.RuntimeInvisibleAnnotations : { ( input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try RuntimeInvisibleAnnotationsAttributeInfo(input, reader: reader)
        },
        AttributeReader.RuntimeVisibleParameterAnnotations : { (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try RuntimeInvisibleParameterAnnotationsAttributeInfo(input, reader: reader)
        },
        AttributeReader.RuntimeVisibleAnnotations : { ( input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try RuntimeVisibleAnnotationsAttributeInfo(input, reader:reader)
        },
        AttributeReader.RuntimeInvisibleParameterAnnotations : { (input:DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try RuntimeInvisibleParameterAnnotationsAttributeInfo(input, reader: reader)
        },
        AttributeReader.LineNumberTable: { (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try LineNumberTableAttributeInfo(input)
        },
        AttributeReader.LocalVariableTable: { (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try LocalVariableTableAttributeInfo(input)
        },
        AttributeReader.LocalVariableTypeTable: {(input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try LocalVariableTypeTableAttributeInfo(input)
        },
        AttributeReader.AnnotationDefault: { (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try AnnotationDefaultAttributeInfo(input, reader: reader)
        },
        AttributeReader.BootstrapMethods: { (input: DataInputStream, _: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try BootstrapMethodsAttributeInfo(input)
        },
        AttributeReader.SourceDebugExtension: { (input: DataInputStream, _: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try SourceDebugExtensionAttributeInfo(input, length)
        },
        AttributeReader.RuntimeInvisibleTypeAnnotations:{ (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try RuntimeInvisibleTypeAnnotationsAttribute(input, reader: reader)
        },
        AttributeReader.Module:{ (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try Module_attribute(input)
        },
        AttributeReader.ModulePackages:{ (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try ModulePackages_attribute(input)
        },
        AttributeReader.NestHost: { (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try NestHost_attribute(input)
        },
        AttributeReader.NestMembers: { (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try NestMembers_attribute(input)
        },
        AttributeReader.ModuleTarget: { (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try ModuleTarget_attribute(input)
        },
        AttributeReader.MethodParameters: { (input: DataInputStream, reader: ConstantPoolReader, length:Int) throws -> AttributeInfo in
            return try MethodParameters_attribute(input)
        },
        
    ]
    
    private let input: DataInputStream
    private let reader: ConstantPoolReader
    init(_ input:DataInputStream, constant reader:ConstantPoolReader) {
        self.input = input
        self.reader = reader
    }
    
    func read() throws -> AttributeInfo {
        let attribute_name_index = try input.readU2()
        let attributeLength = try input.readU4()
        let attribute_name = reader.readUtf8(Int(attribute_name_index))
        if AttributeReader.attribute_reader[attribute_name] == nil {
            return try CustomAttributeInfo(input, attributeName: attribute_name, attributeLength: Int(attributeLength))
        } else {
            return try AttributeReader.attribute_reader[attribute_name]!(input, reader, Int(attributeLength))
        }
        
        
    }
}
