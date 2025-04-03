//
//  Class.swift
//  JavaDecompiler
//
//  Created by Qing Xu on 01/03/2018.
//

import Foundation
import Common

public typealias EnclosingMethod = (enclosingClass:String, enclosingMethod: String?, enclosingMethodDescriptor: MethodDescriptor?)
public typealias InnnerClass = (innerClass: JType?, outerClass: JType?, innerClassName: String, innerClassAccessFlags: AccessFlag)

// MARK :- Class metadata
public class Class : @unchecked Sendable {
    
    typealias ClassAttributeProcessFunction = (Class) -> (AttributeInfo, ConstantPoolReader) throws -> Void
    nonisolated(unsafe) private static let AttributeClassProcessFunctions:[String: ClassAttributeProcessFunction] = {
        return [
            AttributeReader.EnclosingMethod                         :processAttributeEnclosingMethod,
            AttributeReader.Signature                               :processAttributeSignature,
            AttributeReader.RuntimeVisibleAnnotations               :processAttributeRuntimeVisibleAnnotations,
            AttributeReader.SourceFile                              :processAttributeSourceFile,
            AttributeReader.InnerClasses                            :processAttributeInnerClasses,
            AttributeReader.BootstrapMethods                        :processAttributeBootstrapMethods,
            AttributeReader.RuntimeInvisibleAnnotations             :processAttributeRuntimeInvisibleAnnotations,
            AttributeReader.Deprecated                              :processAttributeDeprecated,
            AttributeReader.SourceDebugExtension                    :processAttributeSourceDebugExtension
        ]
    }()
    
    public let classfile: ClassFile
    public let accessFlags: AccessFlag
    public let name: String
    public let shortName: String
    public var isReversed = false
    public let package: String
    public private(set) var superclass: String
    public private(set) var signature:ClassSignature?
    public private(set) var interfaces = [String]()
    public private(set) var fields = [Field]()
    public private(set) var methods = [Method]()
    public private(set) var sourcefile:String?
    public private(set) var annotations = [Annotation]()
    
    public private(set) var enclosingMethodDecl: EnclosingMethod? =  nil
    public private(set) var innerClasses = [InnnerClass]()
    public private(set) var sourceDebugInfo: String? = nil
    
    internal private(set) var reader:ConstantPoolReader
    

    public init(_ classfile:ClassFile) throws {
        self.classfile = classfile
        accessFlags = AccessFlag(classfile.access_flags, withScope: .`class`)
        // this class
        self.reader = ConstantPoolReader(classfile.constant_pool)
        self.name = try reader.readClassInfoAsDescriptor(Int(classfile.this_class))
        
        let classType = try reader.readClassInfo(Int(classfile.this_class))
        let (packageName, shortName) = Self.extractShortNameAndPackageName(classType.type)
        self.shortName = shortName
        self.package = packageName
        
        // handle the super class
        if classfile.super_class == 0 {
            superclass = ""
        } else {
            superclass = try reader.readClassInfoAsDescriptor(Int(classfile.super_class))
        }
        
        // handle the interfaces
        for interface in classfile.interfaces {
            let interfaceName = try reader.readClassInfoAsDescriptor(Int(interface))
            interfaces.append(interfaceName)
        }
        
        // Handle the fields
        for field in classfile.fields {
            let f = try Field(field, parentClass: classfile, reader:reader)
            fields.append(f)
        }
        
        // Handle the methods
        for method in classfile.methods {
            let m = try Method(method, classfile: classfile, reader:reader)
            methods.append(m)
        }
        
        // Handle the Attributes
        try processClassAttributes(attributes: classfile.attributes, reader: reader)
        
        
    }
}

extension Class {
    
    private func processClassAttributes(attributes:[AttributeInfo], reader: ConstantPoolReader) throws {
        for attribute in attributes {
            if let processor = Class.AttributeClassProcessFunctions[attribute.name] {
                try processor(self)(attribute, reader)
            }
        }
    }
    
    private func processAttributeRuntimeVisibleAnnotations(attribute: AttributeInfo, reader:ConstantPoolReader) throws {
        let annotationAttr = attribute as! RuntimeVisibleAnnotationsAttributeInfo
        for annotation in annotationAttr.annotations {
            annotations.append(try Annotation(annotationAttr: annotation, reader: reader))
        }
    }
    
    private func processAttributeSignature(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        let signatureAttri = attribute as! SignatureAttributeInfo
        
        let parser = ClassSignatureParser(signature: reader.readUtf8(Int(signatureAttri.signature_index)))
        self.signature = try parser.parse()
    }
    
    private func processAttributeSourceFile(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        let sourcefileAttr = attribute as! SourceFileAttributeInfo
        sourcefile = reader.readUtf8(Int(sourcefileAttr.sourcefile_index))
    }
    
    private func processAttributeEnclosingMethod(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        let enclosingMethod = attribute as! EnclosingMethodAttributeInfo
        
        let innermostClass = try reader.readClassInfo(Int(enclosingMethod.class_index))
        
        if enclosingMethod.method_index > 0 {
            let innermostMethod = reader.readNameAndTypeInfo(Int(enclosingMethod.method_index))
            let descriptor = try MethodDescriptor(innermostMethod.typeDescriptor)
            
            enclosingMethodDecl = (enclosingClass: innermostClass.descriptor, enclosingMethod: innermostMethod.name, enclosingMethodDescriptor: descriptor)
        } else {
            enclosingMethodDecl = (enclosingClass: innermostClass.descriptor, enclosingMethod: nil, enclosingMethodDescriptor: nil)
        }
        
    }
    
    private func processAttributeInnerClasses(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        let innerClassAttr = attribute as! InnerClassesAttributeInfo
        for classInfo in innerClassAttr.classes {
            let innerClassInfo = try reader.readClassInfo(Int(classInfo.inner_class_info_index))
            var outerClassInfo: JType? = nil
            
            if classInfo.outer_class_info_index > 0 {
                outerClassInfo = try reader.readClassInfo(Int(classInfo.outer_class_info_index))
            }
            
            var innerClassName = ""
            if classInfo.inner_name_index > 0 {
                innerClassName = reader.readUtf8(Int(classInfo.inner_name_index))
            }
            
            innerClasses.append(
                (innerClass: innerClassInfo, outerClass: outerClassInfo, innerClassName: innerClassName, innerClassAccessFlags: AccessFlag(classInfo.inner_class_access_flags, withScope: .class)))
        }
    }
    
    private func processAttributeBootstrapMethods(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        let bootstrapMethods = attribute as! BootstrapMethodsAttributeInfo
        
        for bootstrapMethod in bootstrapMethods.bootstrap_methods {
            let methodHandle = try reader.readMethodHandleInfo(Int(bootstrapMethod.bootstrap_method_ref))
            var arguments = [Any]()
            for index in bootstrapMethod.bootstrap_arguments {
                let cp = reader.read(Int(index))
                switch cp.tag {
                case CONSTANT_String:
                    arguments.append(reader.readString(Int(index)))
                case CONSTANT_MethodHandle:
                    arguments.append(try reader.readMethodHandleInfo(Int(index)))
                case CONSTANT_MethodType:
                    arguments.append(try reader.readMethodType(Int(index)))
                case CONSTANT_Integer:
                    arguments.append(reader.readInteger(Int(index)))
                default:
                    fatalError()
                }
                
                _ = BootstrapMethod(handle: methodHandle, arguments: arguments)
            }
        }
        
    }
    
    private func processAttributeRuntimeInvisibleAnnotations(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        let annotationAttr = attribute as! RuntimeInvisibleAnnotationsAttributeInfo
        for annotation in annotationAttr.annotations {
            annotations.append(try Annotation(annotationAttr: annotation, reader: reader))
        }
    }
    
    private func processAttributeDeprecated(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        annotations.append(Annotation(type: ObjectType.Deprecated))
    }
    
    private func processAttributeSourceDebugExtension(attribute: AttributeInfo, reader: ConstantPoolReader) throws {
        let sourceDebugExtensionAttr = attribute as! SourceDebugExtensionAttributeInfo
        let bytes = sourceDebugExtensionAttr.debug_extension
        sourceDebugInfo = try DataInputStream(Data(bytes: bytes, count: bytes.count)).readJavaMutf8(bytes.count)
    }
    
    private static func extractShortNameAndPackageName(_ name:String) -> (String, String) {
        // the package name
        let shortName: String
        let components = name.split(separator: ".")
        if let lastName = components.last {
           shortName = String(lastName)
        } else {
           shortName = name
        }
        let package = components.dropLast().joined(separator: ".")
        return (package, shortName)
    }
}
