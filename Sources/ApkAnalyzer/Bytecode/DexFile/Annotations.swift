//
//  Annotation.swift
//  ApkAnalyzer
//
//  Created by Qing Xu on 2019/10/10.
//

import Common

struct FieldAnnotation {
    let field_idx: UInt32
    let annotations_off : UInt32
    init(_ data: DataInputStream) throws {
        self.field_idx = try data.readU4()
        self.annotations_off = try data.readU4()
    }
}

struct MethodAnnotation {
    let method_idx: UInt32
    let annotations_off: UInt32
    init(_ data: DataInputStream) throws {
        self.method_idx = try data.readU4()
        self.annotations_off = try data.readU4()
    }
}

struct ParameterAnnotation {
    let method_idx: UInt32
    let annotations_off: UInt32
    
    init(_ data: DataInputStream) throws {
        self.method_idx = try data.readU4()
        self.annotations_off = try data.readU4()
    }
}

struct AnnotationsDirectoryItem {
    let class_annotations_off:Int
    let field_annotations:[FieldAnnotation]
    let method_annotations: [MethodAnnotation]
    let parameter_annotations: [ParameterAnnotation]
    
    init(_ data: DataInputStream) throws {
        self.class_annotations_off = Int(try data.readU4())
        let field_size = try data.readU4()
        let method_size = try data.readU4()
        let parameter_size = try data.readU4()
        
        var fieldAnnotations = [FieldAnnotation]()
        for _ in 0 ..< field_size {
            let field_annotation = try FieldAnnotation(data)
            fieldAnnotations.append(field_annotation)
        }
        field_annotations = fieldAnnotations
        
        var methodAnnotations = [MethodAnnotation]()
        for _ in 0 ..< method_size {
            let methodAnnotation = try MethodAnnotation(data)
            methodAnnotations.append(methodAnnotation)
        }
        method_annotations = methodAnnotations
        
        var parameterAnnotations = [ParameterAnnotation]()
        for _ in 0 ..< parameter_size {
            let parameterAnnotation = try ParameterAnnotation(data)
            parameterAnnotations.append(parameterAnnotation)
        }
        parameter_annotations = parameterAnnotations
    }
}


struct AnnotationSetItem {
    let entries: [AnnotationOffItem]
    
    init(_ data: DataInputStream) throws {
        let size = try data.readU4()
        var entries = [AnnotationOffItem]()
        for _ in 0 ..< size {
            entries.append(try AnnotationOffItem(data))
        }
        self.entries = entries
    }
}

struct AnnotationOffItem {
    let annotation_off: UInt32
    init(_ data: DataInputStream) throws {
        annotation_off = try data.readU4()
    }
}

struct AnnotationItem {
    let visibility: UInt8
    let annotation: EncodedAnnotation
    
    init(_ data: DataInputStream) throws {
        visibility = try data.readU()
        annotation = try EncodedAnnotation(data)
    }
}

struct AnnotationSetRefList {
    let list: [AnnotationSetRefItem]
    
    init(_ data: DataInputStream) throws {
        let size = try data.readU4()
        var list = [AnnotationSetRefItem]()
        for _ in 0 ..< size {
            let item = try AnnotationSetRefItem(data)
            list.append(item)
        }
        self.list = list
    }
}

struct AnnotationSetRefItem {
    let annotations_off: UInt32
    init(_ data:DataInputStream) throws {
        annotations_off = try data.readU4()
    }
}
