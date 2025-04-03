import Common
import Foundation

// A help method to read the constant information
public class ConstantPoolReader {
    let constantPool: [ConstantPoolInfo]
    init(_ constantPool:[ConstantPoolInfo]) {
        self.constantPool = constantPool
    }
    
    func read(_ index:Int) -> ConstantPoolInfo {
        let atIndex = index - 1
        return constantPool[atIndex]
    }
    
    func readString(_ index:Int) -> String {
        let stringInfo = read(index) as! CONSTANT_String_info
        return readUtf8(Int(stringInfo.string_index))
    }
    
    func readInteger(_ index:Int) -> Int32 {
        let integerInfo = read(index) as! CONSTANT_Integer_info
        return integerInfo.value
    }
    
    func readFloat(_ index:Int) -> Float {
        let floatInfo = read(index) as! CONSTANT_Float_info
        return floatInfo.value
    }
    
    func readDouble(_ index:Int) -> Double {
        let doubleInfo = read(index) as! CONSTANT_Double_info
        return doubleInfo.value
    }
    
    func readLong(_ index:Int) -> Int64 {
        let longInfo = read(index) as! CONSTANT_Long_info
        return longInfo.value
    }
    
    func readUtf8(_ index:Int) -> String {
        let utf8 = read(index) as! CONSTANT_Utf8_info
        
        let stream = DataInputStream(Data(bytes: utf8.bytes, count: utf8.bytes.count))
        return (try? stream.readJavaMutf8(utf8.bytes.count)) ?? ""
    }
        
    func readClassInfoAsDescriptor(_ index:Int) throws -> String {
        let classInfo = read(index) as! CONSTANT_Class_info
        return readUtf8(Int(classInfo.name_index))
    }
    
    func readClassInfo(_ index:Int) throws -> JType {
        let binaryName = try readClassInfoAsDescriptor(index)
        let parser = BinaryNameParser()
        let classType = try parser.parse(binaryName)
        return JType(type: classType, descriptor: binaryName)
    }
    
    func readClassInfoAsString(_ index:Int) throws -> String {
        let classInfo = read(index) as! CONSTANT_Class_info
        return readUtf8(Int(classInfo.name_index))
    }
    
    func readMethodHandleInfo(_ index: Int) throws -> MethodHandle {
        let methodHandleInfo = read(index) as! CONSTANT_MethodHandle_info
        let reference:Any
        switch methodHandleInfo.reference_kind {
        case REF_getField, REF_getStatic, REF_putField, REF_putStatic:
            reference = try readFieldInfo(Int(methodHandleInfo.reference_index))
        case REF_invokeVirtual, REF_newInvokeSpecial, REF_invokeStatic, REF_invokeSpecial, REF_invokeInterface:
            reference = try readMethodInfo(Int(methodHandleInfo.reference_index))
        default:
            fatalError()
        }
        return MethodHandle(kind: methodHandleInfo.reference_kind, reference: reference)
    }
    
    func readMethodType(_ index: Int) throws -> MethodType {
        let methodTypeInfo = read(index) as! CONSTANT_MethodType_info
        let descriptor = readUtf8(Int(methodTypeInfo.descriptor_index))
        let methodDescriptor = try MethodDescriptor(descriptor)
        return MethodType(descriptor: methodDescriptor)
    }
    
    func readDynamicMethodInfo(_ index:Int) throws -> (methodName:String, parameterTypes:[JType], returnType:JType) {
        let methodInfo = read(index) as! CONSTANT_InvokeDynamic_info
        
        let nameAndType = readNameAndTypeInfo(methodInfo.name_and_type_index)
        let descriptor = try MethodDescriptor(nameAndType.typeDescriptor)
        var parameterTypes = [JType]()
        for parameter in descriptor.parameters {
            let type = JType(type: parameter.javaType, descriptor: parameter.descriptor)
            parameterTypes.append(type)
        }
        
        return (
            nameAndType.name,
            parameterTypes,
            JType(type: descriptor.returnType!.javaType, descriptor: descriptor.returnType!.descriptor)
        )
    }
    
    func readMethodInfo(_ index:Int) throws -> MethodRef {
        let classIndex:Int
        let nameAndTypeIndex:Int
        
        let info = read(index)
        if let methodInfo = info as? CONSTANT_Methodref_info  {
            classIndex = methodInfo.class_index
            nameAndTypeIndex = methodInfo.name_and_type_index
        } else if let methodInfo = info as? CONSTANT_InterfaceMethodref_info {
            classIndex = methodInfo.class_index
            nameAndTypeIndex = methodInfo.name_and_type_index
        } else {
            fatalError()
        }
        
        let `class` = try readClassInfo(classIndex)
        let nameAndType = readNameAndTypeInfo(nameAndTypeIndex)
        let descriptor = try MethodDescriptor(nameAndType.typeDescriptor)
        
        return MethodRef(ownerClass: `class`, methodName: nameAndType.name, descriptor: descriptor)
        
    }
    
    func readFieldInfo(_ index:Int) throws -> (ownerClass:JType, fieldType:JType, fieldName:String){
        let fieldInfo = read(index) as! CONSTANT_Fieldref_info
        let `class` = try readClassInfo(fieldInfo.class_index)
        let nameAndType = readNameAndTypeInfo(fieldInfo.name_and_type_index)
        let descriptor = try FieldDescritpor(nameAndType.typeDescriptor)
        
        return (`class`, JType(type: descriptor.javaType, descriptor: descriptor.rawDescriptor), nameAndType.name )
    }
    
    func readNameAndTypeInfo(_ index:Int) -> (name:String, typeDescriptor:String){
        let nameAndType = read(index) as! CONSTANT_NameAndType_info
        let name = readUtf8(Int(nameAndType.name_index)).replacingOccurrences(of: "/", with: ".")
        let type = readUtf8(Int(nameAndType.descriptor_index))
        return (name, type)
    }
}
