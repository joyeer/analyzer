//
//  DexFile.swift
//  DecompileAndroid
//
//  Created by Qing Xu on 8/3/19.
//

import Common

let NO_INDEX: UInt32 = 0xffffffff

/// Dex File format declaration
public struct DexFile {
    let header_item: HeaderItem
    let string_ids: [StringIDItem]
    let type_ids: [TypeIDItem]
    let proto_ids: [proto_id_item]
    let field_ids: [FieldIDItem]
    let method_ids: [MethodIDItem]
    let class_defs: [ClassDefItem]
    
    init?(_ input:DataInputStream) {
        
        // header_item
        guard let header_item = HeaderItem(input) else { return nil }
        self.header_item = header_item

        // string_ids
        var string_ids = [StringIDItem]()
        for _ in 0..<header_item.string_ids_size {
            guard let string_id = StringIDItem(input) else {
                return nil
            }
            string_ids.append(string_id)
        }
        self.string_ids = string_ids
        
        // type_ids
        var type_ids = [TypeIDItem]()
        for _ in 0..<header_item.type_ids_size {
            guard let type_id = TypeIDItem(input) else {
                return nil
            }
            type_ids.append(type_id)
        }
        self.type_ids = type_ids
        
        // proto_ids
        var proto_ids = [proto_id_item]()
        for _ in 0 ..< header_item.proto_ids_size {
            guard let proto_id = proto_id_item(input) else {
                return nil
            }
            proto_ids.append(proto_id)
        }
        self.proto_ids = proto_ids
        
        // field_ids
        var field_ids = [FieldIDItem]()
        for _ in 0 ..< header_item.field_ids_size {
            guard let field_id = FieldIDItem(input) else {
                return nil
            }
            field_ids.append(field_id)
        }
        self.field_ids = field_ids
        
        // method_ids
        var method_ids = [MethodIDItem]()
        for _ in 0 ..< header_item.method_ids_size {
           guard let method_id = MethodIDItem(input) else {
               return nil
           }
           method_ids.append(method_id)
        }
        self.method_ids = method_ids
    
        // class_defs
        var class_defs = [ClassDefItem]()
        for _ in 0 ..< header_item.class_defs_size {
            guard let class_def = ClassDefItem(input) else {
                return nil
            }
            class_defs.append(class_def)
        }
        self.class_defs = class_defs
        
    }
    


}
