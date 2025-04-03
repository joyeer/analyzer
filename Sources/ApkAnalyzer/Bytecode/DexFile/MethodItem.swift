//
//  MethodItem.swift
//  ApkAnalyzer
//
//  Created by Qing Xu on 9/9/19.
//

import Common

struct MethodIDItem {
    let class_idx: UInt16
    let proto_idx: UInt16
    let name_idx: UInt32
    
    init?(_ data:DataInputStream) {
        guard let class_idx = try? data.readU2() else {
            return nil
        }
        
        guard let proto_idx = try? data.readU2() else {
            return nil
        }
        
        guard let name_idx = try? data.readU4() else {
            return nil
        }
        
        self.class_idx = class_idx
        self.proto_idx = proto_idx
        self.name_idx = name_idx
    }
}

// method_id_item -> MethodDecl
public struct MethodDecl {
    public let classType: String
    public let proto: ProtoDecl
    public let name: String
}


struct MethodHandleItem {
    let method_handle_type: UInt16
    let field_or_method_id: UInt16
    
    init?(_ data:DataInputStream) {
        guard let method_handle_type = try? data.readU2() else {
            return nil
        }
        
        guard let _ = try? data.readU2() else {
            return nil
        }
        
        guard let field_or_method_id = try? data.readU2() else {
            return nil
        }
        
        guard let _ = try? data.readU2() else {
            return nil
        }
        
        self.method_handle_type = method_handle_type
        self.field_or_method_id = field_or_method_id
        
    }
}
