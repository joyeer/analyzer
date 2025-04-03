//
//  Method.swift
//  JavaDecompiler
//
//  Created by Qing Xu on 01/03/2018.
//

import Foundation

// AST method information
final public class Method {
    
    public let accessFlags: AccessFlag
    // Method's display name
    public private(set) var name:String
    public private(set) var annotations = [Annotation]()
    // Generic type parameter
    public private(set) var parameters = [Parameter]()
    public private(set) var `throws` = [JType]()
    public private(set) var `return` = JType.Void
    public private(set) var code: Code?
    public private(set) var signature: MethodSignature?
    
    var statements = [Statement]()
    public var reader:ConstantPoolReader
    
    internal var exceptions = ExceptionTableLookup()
    internal var locals:LocalVariableTable?
    
    init(_ method: MethodInfo, classfile:ClassFile, reader: ConstantPoolReader) throws {
        
        accessFlags = AccessFlag(method.access_flags, withScope: .method)
        self.reader = reader
        
        // Handle the class name issue
        name = reader.readUtf8(Int(method.name_index))
        
        let descriptorString = reader.readUtf8(Int(method.descriptor_index))
        let descriptor = try MethodDescriptor(descriptorString)
        
        processDescriptor(descriptor: descriptor)
        
        // Method Attributes
        try processAttributes(attributes: method.attributes, reader: reader)
        
        // Method Parameters
        postProcessParameters()
    }
    
    public func queryOpcodeIndex(offset: Int) -> Int {
        
        if let code = code {
            return code.getOpcodeIndexForJumpIndex(offset: offset) ?? -1
        }
        return -1
    }
    
    public func queryOpcodeOffset(index: Int) -> Int {
        
        if let code = code {
            return code.opcodes[index].offset
        }
        return -1
    }
    
    public func getOpcodeBy(index: Int) -> JOpcode {
        return code!.opcodes[index]
    }
    
    /// for parameter name store in code attributes
    private func postProcessParameters() {
        if locals == nil {
            return
        }
        var index = 0
        if accessFlags.isStatic == false {
            locals!.find(index: index).declared = true
            index += 1
        }
        
        for parameter in parameters {
            let variable = locals!.find(index: index)
            if variable.type == .Long || variable.type == .Double {
                index += 2
            } else {
                index += 1
            }
            
            parameter.name = variable.name
            variable.declared = true
        }
    }
    
    private func processAttributes(attributes: [AttributeInfo], reader:ConstantPoolReader) throws {
        for attribute in attributes {
            switch attribute.name {
            case AttributeReader.Signature:
                try processAttributeSignature(attribute: attribute, reader: reader)
            case AttributeReader.RuntimeInvisibleParameterAnnotations:
                try processAttributeRuntimeInvisibleParameterAnnotations(attribute: attribute, reader: reader)
            case AttributeReader.Code:
                try processAttributeCode(attribute: attribute, reader: reader)
            case AttributeReader.RuntimeVisibleAnnotations:
                try processAttributeRuntimeVisibleAnnotations(attribute: attribute, reader: reader)
            case AttributeReader.Exceptions:
                try processAttributeException(attribute: attribute, reader: reader)
            case AttributeReader.Deprecated:
                try processAttributeDeprecated(attribute: attribute, reader: reader)
            case AttributeReader.AnnotationDefault:
                try processAttributeAnnotationDefault(attribute: attribute, reader: reader)
            case AttributeReader.RuntimeInvisibleAnnotations:
                try processAttributeRuntimeInvisibleAnnotations(attribute: attribute, reader: reader)
            case AttributeReader.MethodParameters:
                break
            default:
                break
            }
        }
    }
    
    private func processDescriptor(descriptor:MethodDescriptor) {
        for param in descriptor.parameters {
            parameters.append(Parameter(type: JType(type: param.javaType, descriptor: param.descriptor)))
        }
        
        `return` = JType(type: descriptor.returnType!.javaType, descriptor: descriptor.returnType!.descriptor)
    }
    
}

/// MARK :- Processing the Attributes information for Method
extension Method {
    
    private func processAttributeRuntimeInvisibleParameterAnnotations(attribute:AttributeInfo, reader:ConstantPoolReader) throws {
        let paramAnnotationAttrInfo = attribute as! RuntimeInvisibleParameterAnnotationsAttributeInfo
        
        for (index, param_annotation) in paramAnnotationAttrInfo.parameter_annotations.enumerated() {
            if param_annotation.annotations.count > 0 {
                let parameter = parameters[index]
                for annotationAttr in param_annotation.annotations {
                    parameter.annotations.append(try Annotation(annotationAttr: annotationAttr, reader: reader))
                }
            }
        }
    }
    
    private func processAttributeCode(attribute:AttributeInfo, reader:ConstantPoolReader) throws {
        let codeInfo = attribute as! CodeAttributeInfo
        code = try Code(code:codeInfo, method:self, reader:reader)
        locals = LocalVariableTable(localVariables: code!.localVariables)
        
        for exceptionInfo in codeInfo.exceptions {
            exceptions.insert(rawException: exceptionInfo, method: self)
        }
        
    }
    
    private func processAttributeException(attribute:AttributeInfo, reader:ConstantPoolReader) throws {
        let exceptions = attribute as! ExceptionsAttributeInfo
        for index in exceptions.exception_index_table {
            let exception = try reader.readClassInfo(Int(index))
            `throws`.append(exception)
        }
    }
    
    private func processAttributeSignature(attribute:AttributeInfo, reader:ConstantPoolReader) throws {
        let signatureAttri = attribute as! SignatureAttributeInfo
        let parser = MethodSignatureParser(signature: reader.readUtf8(Int(signatureAttri.signature_index)))
        signature = try parser.parse()
        
    }
    
    private func processAttributeRuntimeVisibleAnnotations(attribute:AttributeInfo, reader:ConstantPoolReader) throws {
        let annotationAttrInfo = attribute as! RuntimeVisibleAnnotationsAttributeInfo
        for annotationAttr in annotationAttrInfo.annotations {
            annotations.append(try Annotation(annotationAttr: annotationAttr, reader: reader))
        }
    }
    
    private func processAttributeDeprecated(attribute:AttributeInfo, reader:ConstantPoolReader) throws {
        annotations.append(Annotation(type: ObjectType.Deprecated))
    }
    
    private func processAttributeAnnotationDefault(attribute:AttributeInfo, reader:ConstantPoolReader) throws {
        
    }
    
    private func processAttributeRuntimeInvisibleAnnotations(attribute:AttributeInfo, reader: ConstantPoolReader) throws {
        let annotationAttrInfo = attribute as! RuntimeInvisibleAnnotationsAttributeInfo
        for annotationAttr in annotationAttrInfo.annotations {
            annotations.append(try Annotation(annotationAttr: annotationAttr, reader: reader))
        }
    }
    
}
