//
//  Field.swift
//  JavaDecompiler
//
//  Created by Qing Xu on 01/03/2018.
//

import Foundation

public class Field : @unchecked Sendable {
    
    // Field attribute process function
    typealias FieldAttributeProcessFunction = (Field) -> (AttributeInfo, ConstantPoolReader) throws -> Void
    
    private let FieldAttributeProcessFunctions:[String: FieldAttributeProcessFunction] = {
        return [
            AttributeReader.ConstantValue                       : processAttributeConstantValue,
            AttributeReader.Signature                           : processAttributeSignature,
            AttributeReader.RuntimeVisibleAnnotations           : processAttributeRuntimeVisibleAnnotations,
            AttributeReader.Deprecated                          : processAttributeDeprecated,
            AttributeReader.RuntimeInvisibleAnnotations         : processAttributeRuntimeInvisibleAnnotations,
            AttributeReader.Synthetic                           : processAttributeSynthetic,
            AttributeReader.RuntimeInvisibleTypeAnnotations     : processAttributeRuntimeInvisibleTypeAnnotations,
            AttributeReader.RuntimeVisibleTypeAnnotations       : processAttributeRuntimeVisibleTypeAnnotations,
        ]
    }()
    
    public let accessFlags: AccessFlag
    public let name: String
    public private(set) var type:JType
    public private(set) var annotations = [Annotation]()
    public private(set) var constantValue:String?
    public private(set) var signature: FieldSignature?
    public private(set) var deprecated = false
    
    init(_ info: FieldInfo, parentClass classfile:ClassFile, reader:ConstantPoolReader) throws {
        accessFlags = AccessFlag(info.access_flags, withScope: .field)
        name = reader.readUtf8(Int(info.name_index))
        let descriptor = try FieldDescritpor(reader.readUtf8(Int(info.descriptor_index)))
        type = JType(type: descriptor.javaType, descriptor: descriptor.rawDescriptor)
        try processFieldAttributes(attributes: info.attributes, reader: reader)
    }
}


extension Field {
    
    private func processFieldAttributes(attributes:[AttributeInfo], reader:ConstantPoolReader) throws {
        for attribute in attributes {
            let function = FieldAttributeProcessFunctions[attribute.name]!
            try function(self)(attribute, reader)
        }
    }
    
    private func processAttributeConstantValue(attribute:AttributeInfo, reader:ConstantPoolReader) throws {
        let constantValueAttr = attribute as! ConstantValueAttributeInfo
        switch type.fullDescription {
        case "long":
            constantValue = String(reader.readLong(constantValueAttr.constantvalue_index))
        case "float":
            constantValue = String(reader.readFloat(constantValueAttr.constantvalue_index))
        case "double":
            constantValue = String(reader.readDouble(constantValueAttr.constantvalue_index))
        case "int", "short", "char", "byte":
            constantValue = String(reader.readInteger(constantValueAttr.constantvalue_index))
        case "boolean":
            constantValue = reader.readInteger(constantValueAttr.constantvalue_index) > 0 ? "true": "false"
        case "java.lang.String", "String":
            let string = reader.readString(constantValueAttr.constantvalue_index)
            constantValue = string
        default:
            fatalError()
        }
    }
    
    private func processAttributeRuntimeVisibleAnnotations(attribute: AttributeInfo, reader:ConstantPoolReader) throws {
        let annotationAttrInfo = attribute as! RuntimeVisibleAnnotationsAttributeInfo
        for annotationAttr in annotationAttrInfo.annotations {
            annotations.append(try Annotation(annotationAttr: annotationAttr, reader: reader))
        }
    }
    
    private func processAttributeSignature(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        let signatureAttr = attribute as! SignatureAttributeInfo
        let string = reader.readUtf8(Int(signatureAttr.signature_index))
        signature = try FieldSignature(signature: string)
    }
    
    private func processAttributeDeprecated(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        deprecated = true
    }
    
    private func processAttributeRuntimeInvisibleTypeAnnotations(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        let annotationAttrInfo = attribute as! RuntimeInvisibleTypeAnnotationsAttribute
        for annotationAttr in annotationAttrInfo.annotations {
            annotations.append(try Annotation(typeAnnotation: annotationAttr, reader: reader))
        }
    }
    
    private func processAttributeRuntimeInvisibleAnnotations(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        let annotationAttr = attribute as! RuntimeInvisibleAnnotationsAttributeInfo
        for annotation in annotationAttr.annotations {
            annotations.append(try Annotation(annotationAttr: annotation, reader: reader))
        }
    }
    
    private func processAttributeSynthetic(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        
    }
    
    private func processAttributeRuntimeVisibleTypeAnnotations(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        
    }

}
