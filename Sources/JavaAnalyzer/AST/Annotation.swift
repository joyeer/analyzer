//
//  Annotation.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/7/23.
//

import Foundation



public struct Annotation {
    
    public let type:JType
    public let values: [(name: String, value: ElementValue)]
    
    init(annotationAttr: AnnotationAttr, reader: ConstantPoolReader) throws {
        
        let descriptor = reader.readUtf8(Int(annotationAttr.type_index))
        let fieldDescriptor = try FieldDescritpor(descriptor)
        type = JType(type: fieldDescriptor.javaType, descriptor: fieldDescriptor.rawDescriptor)
        
        var values = [(String, ElementValue)]()
        for elementValuePair in annotationAttr.element_value_pairs {
            values.append((elementValuePair.name, elementValuePair.value))
        }
        self.values = values
    }
    
    init(typeAnnotation: TypeAnnotation, reader: ConstantPoolReader) throws {
        let descriptor = reader.readUtf8(Int(typeAnnotation.type_index))
        let fieldDescriptor = try FieldDescritpor(descriptor)
        type = JType(type: fieldDescriptor.javaType, descriptor: fieldDescriptor.rawDescriptor)
        
        var values = [(String, ElementValue)]()
        for elementValuePair in typeAnnotation.element_value_pairs {
            values.append((elementValuePair.name, elementValuePair.value))
        }
        self.values = values
    }
    
    init(type: JType) {
        self.type = type
        self.values = []
    }
}
