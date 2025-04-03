//
//  ClassItem.swift
//  ApkAnalyzer
//
//  Created by Qing Xu on 9/9/19.
//

import Common

struct ClassDefItem {
    let class_idx: UInt32
    let access_flags: UInt32
    let superclass_idx: UInt32
    let interfaces_off: UInt32
    let source_file_idx: UInt32
    let annotations_off: UInt32
    let class_data_off: UInt32
    let static_values_off: UInt32
    
    init?(_ data:DataInputStream) {
        guard let class_idx = try? data.readU4() else {
            return nil
        }
        
        guard let access_flags = try? data.readU4() else {
            return nil
        }
        
        guard let superclass_idx = try? data.readU4() else {
            return nil
        }
        
        guard let interfaces_off = try? data.readU4() else {
            return nil
        }
        
        guard let source_file_idx = try? data.readU4() else {
            return nil
        }
        
        guard let annotations_off = try? data.readU4() else {
            return nil
        }
        
        guard let class_data_off = try? data.readU4() else {
            return nil
        }
        
        guard let static_values_off = try? data.readU4() else {
            return nil
        }
        
        self.class_idx = class_idx
        self.access_flags = access_flags
        self.superclass_idx = superclass_idx
        self.interfaces_off = interfaces_off
        self.source_file_idx = source_file_idx
        self.annotations_off = annotations_off
        self.class_data_off = class_data_off
        self.static_values_off = static_values_off
    }
}

struct EncodedField {
    var field_idx_diff: UInt
    let access_flags: UInt
    
    init(_ data:DataInputStream) throws {
        self.field_idx_diff = try data.readUleb128()
        self.access_flags = try data.readUleb128()
    }
}

struct EncodedMethod {
    var method_idx_diff: UInt
    let access_flags: UInt
    let code_off: UInt
    
    init(_ data: DataInputStream) throws {
        self.method_idx_diff = try data.readUleb128()
        self.access_flags = try data.readUleb128()
        self.code_off = try data.readUleb128()
    }
}

struct ClassDataItem {
    let static_fields: [EncodedField]
    let instance_fields: [EncodedField]
    let direct_methods: [EncodedMethod]
    let virtual_methods: [EncodedMethod]
    
    init(_ data: DataInputStream) throws {
        let static_field_size = try data.readUleb128()
        let instance_field_size = try data.readUleb128()
        let direct_methods_size = try data.readUleb128()
        let virtual_methods_size = try data.readUleb128()
        
        var static_fields = [EncodedField]()
        var instance_fields = [EncodedField]()
        var direct_methods = [EncodedMethod]()
        var virtual_methods = [EncodedMethod]()
        var offset:UInt = 0
        
        for _ in 0 ..< static_field_size {
            var static_field = try EncodedField(data)
            static_field.field_idx_diff = static_field.field_idx_diff + offset
            offset = static_field.field_idx_diff
            static_fields.append(static_field)
        }
        self.static_fields = static_fields
        
        offset = 0
        for _ in 0 ..< instance_field_size {
            var instance_field = try EncodedField(data)
            instance_field.field_idx_diff = instance_field.field_idx_diff + offset
            offset = instance_field.field_idx_diff
            instance_fields.append(instance_field)
        }
        self.instance_fields = instance_fields
        
        offset = 0
        for _ in 0 ..< direct_methods_size {
            var direct_method = try EncodedMethod(data)
            direct_method.method_idx_diff = direct_method.method_idx_diff + offset
            offset = direct_method.method_idx_diff
            direct_methods.append(direct_method)
        }
        self.direct_methods = direct_methods
        
        offset = 0
        for _ in 0 ..< virtual_methods_size {
            var virtualMethod = try EncodedMethod(data)
            virtualMethod.method_idx_diff = virtualMethod.method_idx_diff + offset
            offset = virtualMethod.method_idx_diff
            virtual_methods.append(virtualMethod)
        }
        self.virtual_methods = virtual_methods
    }
}
