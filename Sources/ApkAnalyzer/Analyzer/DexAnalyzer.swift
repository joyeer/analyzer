//
//  DexAnalyzer.swift
//  ApkAnalyzer
//
//  Created by Qing Xu on 9/10/19.
//

import Foundation
import Common

class DexAnalyzer {
    
    let table = Table()
    
    let dexfile: DexFile
    let input: DataInputStream
    var classes = [Class]()
        
    private(set) var packages = [Package]()
    
    init(dex dexfile:DexFile, input: DataInputStream) {
        self.dexfile = dexfile
        self.input = input
    }
    
    // analyze teh dex file
    func analyze(progress: ((Int)->Void)? = nil) throws {
        
        reportProgress(progress: 0, callback: progress)
        try analyzeStringTable()
        
        reportProgress(progress: 5, callback: progress)
        try analyzeTypeTable()
        
        reportProgress(progress: 10, callback: progress)
        try analyzeProtoTable()
        
        reportProgress(progress: 15, callback: progress)
        try analyzeFieldTable()
        
        reportProgress(progress: 20, callback: progress)
        try analyzeMethodTable()
        
        reportProgress(progress: 25, callback: progress)
        try analyzeClassDefs(progressBase: 25, progress: progress)
        
        try analyzePackages()
        reportProgress(progress: 100, callback: progress)
    }
    
    /// analyze the package, group all classes into package
    private func analyzePackages() throws {
        var packageIndexes = [String: [Class]]()
        for `class` in classes {
            if let packageName = `class`.classType.package {
                if packageIndexes[packageName] == nil {
                    packageIndexes[packageName] = [Class]()
                }
                
                packageIndexes[packageName]?.append(`class`)
            }
        }
        
        packages = packageIndexes.map({ (name, classes)in
            Package(name: name, classes: classes)
        })
    }
    
    /// analyze the proto table
    private func analyzeProtoTable() throws {
        for protoId in dexfile.proto_ids {
            let shorty = table.strings[Int(protoId.shorty_idx)]
            let returnType = table.types[Int(protoId.return_type_idx)]
            var parameters = [String]()
            
            if protoId.parameters_off > 0 {
                input.seek(Int(protoId.parameters_off))
                guard let typeList = TypeList(input) else {
                    throw IOError.format
                }
                
                try typeList.list.forEach { typeItem in
                    if typeItem.type_idx >= table.types.count {
                        throw IOError.format
                    }
                    parameters.append(table.types[Int(typeItem.type_idx)])
                }
            }
            
            let proto = ProtoDecl(shorty: shorty, returnType: returnType, parameterTypes: parameters)
            table.protos.append(proto)
        }
    }
    
    private func analyzeMethodTable() throws {
        for methodId in dexfile.method_ids {
            let proto = table.protos[Int(methodId.proto_idx)]
            let classType = table.types[Int(methodId.class_idx)]
            let name = table.strings[Int(methodId.name_idx)]
            
            table.methods.append(MethodDecl(classType: classType, proto: proto, name: name))
        }
    }
    
    /// parse the field table
    private func analyzeFieldTable() throws {
        for fieldId in dexfile.field_ids {
            let type = table.types[Int(fieldId.type_idx)]
            let name = table.strings[Int(fieldId.name_idx)]
            let definer = table.types[Int(fieldId.class_idx)]
            let fieldDecl = FieldDecl(definer: definer, type: type, name: name)
            table.fields.rawFields.append(fieldDecl)
        }
    }
    
    /// parse the dexfile's string_ids as Table
    private func analyzeStringTable() throws {
        // process strings
        for stringId in dexfile.string_ids {
            let dataOffset = stringId.string_data_off
            input.seek(Int(dataOffset))
            guard let dataItem = StringDataItem(input) else {
                throw IOError.format
            }
            table.strings.append(dataItem.data)
        }
    }
    
    /// analyze the type_id
    private func analyzeTypeTable() throws {
        for typeId in dexfile.type_ids {
            if typeId.description_idx >= table.strings.count {
                throw IOError.format
            }
            let descriptor = table.strings[Int(typeId.description_idx)]
            table.types.append(descriptor)
        }
    }
    
    private func analyzeClassDefs(progressBase:Int, progress:((Int)->Void)? = nil) throws {
        
        var base = dexfile.class_defs.count / (100 - progressBase) * 5
        base = base == 0 ? 1 : base
        for (index,classDef) in dexfile.class_defs.enumerated() {
            let klass = try analyzeClassDef(classDef)
            classes.append(klass)
            
            if index % base == 0 {
                reportProgress(progress: progressBase + (index / base) * 5, callback: progress)
            }
        }
    }
    
    private func analyzeClassDef(_ classDef: ClassDefItem) throws -> Class {
        
        guard table.types.count > classDef.class_idx &&
            table.types.count > classDef.superclass_idx else {
            throw IOError.format
        }
        
        let classType = TypeDescriptor(rawValue: table.types[Int(classDef.class_idx)])
        let accessFlags = AccessFlag(classDef.access_flags, withScope: .class)
        let superType = TypeDescriptor(rawValue: table.types[Int(classDef.superclass_idx)])
        // analyze interfaces
        var interfaces = [TypeDescriptor]()
        if classDef.interfaces_off > 0 {
            input.seek(Int(classDef.interfaces_off))
            
            guard let typeList = TypeList(input) else {
                throw IOError.format
            }
            
            try typeList.list.forEach { typeItem in
                if typeItem.type_idx >= table.types.count {
                    throw IOError.format
                }
                interfaces.append(TypeDescriptor(rawValue: table.types[Int(typeItem.type_idx)]))
            }
        }
        
        // analyze source file
        var sourceFile = ""
        if classDef.source_file_idx != NO_INDEX {
            sourceFile = table.strings[Int(classDef.source_file_idx)]
        }
        
        var classAnnotations = [Annotation]()
        var fieldAnnotations = [Int: [Annotation]]()
        var methodAnnotations = [Int: [Annotation]]()
        var parameterAnnotations = [Int: [[Annotation]?]]()
        
        // analayze annonations
        if classDef.annotations_off > 0 {
            input.seek(Int(classDef.annotations_off))
            let annotationDirectory = try AnnotationsDirectoryItem(input)
            classAnnotations = try analyzeClassAnnotations(annotationDirectoryItem: annotationDirectory)
            fieldAnnotations = try analyzeFieldAnnotations(annotationDirectoryItem: annotationDirectory)
            methodAnnotations = try analyzeMethodAnnotations(annotationDirectoryItem: annotationDirectory)
            parameterAnnotations = try analyzeParameterAnnotations(annotationDirectoryItem: annotationDirectory)
        }
        
        var staticFields = [Field]()
        var instanceFields = [Field]()
        
        var directMethods = [Method]()
        var virtualMethods = [Method]()
        
        // analayze class data
        if classDef.class_data_off > 0 {
            input.seek(Int(classDef.class_data_off))
            let classData = try ClassDataItem(input)
            
            // parse the field information
            staticFields = analyzeFields(encodedFields: classData.static_fields)
            instanceFields = analyzeFields(encodedFields: classData.instance_fields)
            
            // parse the method information
            directMethods = try analyzeMethods(encodedMethods: classData.direct_methods)
            virtualMethods = try analyzeMethods(encodedMethods: classData.virtual_methods)
        }
        
        // analyze
        if classDef.static_values_off > 0 {
            input.seek(Int(classDef.static_values_off))
//            let encodedArray = try EncodedArray(input)
            _ = try EncodedArray(input)
        }
        
        return Class(accessflag: accessFlags,
                     classType: classType,
                     superType: superType,
                     interfaceTypes: interfaces,
                     staticFields: staticFields,
                     instanceFields: instanceFields,
                     directMethods: directMethods,
                     virtualMethods: virtualMethods,
                     sourceFile: sourceFile,
                     annotations: classAnnotations,
                     fieldAnnotations: fieldAnnotations,
                     methodAnnotations: methodAnnotations,
                     parameterAnnotations: parameterAnnotations,
                     table: table)
    }
    
    
    // MARK:- Analyzing Annotations
    func analyzeClassAnnotations(annotationDirectoryItem: AnnotationsDirectoryItem) throws -> [Annotation] {
        var annotations = [Annotation]()
        
        if annotationDirectoryItem.class_annotations_off > 0 {
            // class annotaiton
            input.seek(annotationDirectoryItem.class_annotations_off)
            let annotationSet = try AnnotationSetItem(input)
            annotations = try analyzeAnnotations(annotationSet: annotationSet)
        }
        
        return annotations
    }
    
    func analyzeFieldAnnotations(annotationDirectoryItem: AnnotationsDirectoryItem) throws -> [Int: [Annotation]] {
        var result = [Int: [Annotation]]()
        
        for fieldAnnotation in annotationDirectoryItem.field_annotations {
            input.seek(Int(fieldAnnotation.annotations_off))
            let annotationSet = try AnnotationSetItem(input)
            let annotations = try analyzeAnnotations(annotationSet: annotationSet)
            
            result[Int(fieldAnnotation.field_idx)] = annotations
        }
        return result
    }
    
    func analyzeMethodAnnotations(annotationDirectoryItem: AnnotationsDirectoryItem) throws -> [Int: [Annotation]] {
        var result = [Int: [Annotation]]()
        
        for methodAnnotation in annotationDirectoryItem.method_annotations {
            input.seek(Int(methodAnnotation.annotations_off))
            let annotationSet = try AnnotationSetItem(input)
            let annotations = try analyzeAnnotations(annotationSet: annotationSet)
            
            result[Int(methodAnnotation.method_idx)] = annotations
        }
        return result
    }
    
    func analyzeParameterAnnotations(annotationDirectoryItem: AnnotationsDirectoryItem) throws -> [Int: [[Annotation]?]] {
        var result = [Int: [[Annotation]?]]()
        
        for paramAnnotation in annotationDirectoryItem.parameter_annotations {
            var paramAnnotations = [[Annotation]?]()
            input.seek(Int(paramAnnotation.annotations_off))
            let annotationSetRefList = try AnnotationSetRefList(input)
            
            for refitem in annotationSetRefList.list {
                if refitem.annotations_off == 0 {
                    paramAnnotations.append(nil)
                } else {
                    input.seek(Int(refitem.annotations_off))
                    let annotationSet = try AnnotationSetItem(input)
                    let annotations = try analyzeAnnotations(annotationSet: annotationSet)
                    paramAnnotations.append(annotations)
                }
            }
            
            result[Int(paramAnnotation.method_idx)] = paramAnnotations
        }
        
        return result
    }
    
    func analyzeAnnotations(annotationSet: AnnotationSetItem) throws -> [Annotation] {
        
        var annotations = [Annotation]()
        for entry in annotationSet.entries {
            input.seek(Int(entry.annotation_off))
            let item = try AnnotationItem(input)
            let annotation = try item.annotation.toAnnotation(table: table, visibility: AnnotationVisibility(rawValue: Int(item.visibility)))
            annotations.append( annotation)
        }
        
        return annotations

    }
    
    // MARK:- Analyzing Fields information
    func analyzeFields(encodedFields: [EncodedField]) -> [Field] {
        return encodedFields.map { encodeField in
            analyzeField(encodedField: encodeField)
        }
    }
    
    func analyzeField(encodedField: EncodedField) -> Field {
        let accessFlags = AccessFlag(UInt32(encodedField.access_flags), withScope: .field)
        let field = table.fields[Int(encodedField.field_idx_diff)]
        return Field(accessFlags: accessFlags, type: field.type, name: field.name, index: Int(encodedField.field_idx_diff))
    }
    
    // MARK:- Analyzing method informations
    func analyzeMethods(encodedMethods: [EncodedMethod]) throws -> [Method] {
        return try encodedMethods.map { encodedMethod in
            try analyzeMethod(encodedMethod: encodedMethod)
        }
    }
    
    func analyzeMethod(encodedMethod: EncodedMethod) throws -> Method {
        let accessFlags = AccessFlag(UInt32(encodedMethod.access_flags), withScope: .method)
        
        let method = table.methods[Int(encodedMethod.method_idx_diff)]
        var code: Code?
        var parameterNames = [String]()
        if encodedMethod.code_off > 0 {
            input.seek(Int(encodedMethod.code_off))
            let codeItem = try CodeItem(input)
            // start to analyze the opcodes
            code = try analyzeCode(codeItem: codeItem)
            
            if codeItem.debug_info_off != 0 {
                input.seek(Int(codeItem.debug_info_off))
                let debugInfoItem = try DebugInfoItem(input)
                parameterNames = analyzeDebugInfo(item: debugInfoItem)
            }
        } 
        
        return Method(accessFlag: accessFlags, returnType:method.proto.returnType, parameters: method.proto.parameterTypes, parameterNames: parameterNames, name: method.name, code:code, index: Int(encodedMethod.method_idx_diff))
    }
    
    func analyzeDebugInfo(item: DebugInfoItem) -> [String]{
        var parameterNames = [String]()
        for index in item.parameter_names {
            if index != -1 {
                parameterNames.append(table.strings[index])
            } else {
                parameterNames.append("")
            }
        }
        return parameterNames
    }
    
    /// analyze the opcodes
    func analyzeCode(codeItem: CodeItem) throws -> Code {
        let analyzer = OpcodeAnalyzer()
        try analyzer.analyze(codeItem: codeItem)
        return Code(registers: Int(codeItem.registers_size), instructions:analyzer.instructions)
    }
    
    func reportProgress(progress:Int, callback: ((Int)->Void)?) {
        if let callback = callback {
            callback(progress < 100 ? progress : 100)
        }
    }
    
}
