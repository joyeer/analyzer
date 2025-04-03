//
//  FieldItem.swift
//  ApkAnalyzer
//
//  Created by Qing Xu on 9/9/19.
//

import Common

// field_id_item
struct FieldIDItem {
    let class_idx: UInt16
    let type_idx: UInt16
    let name_idx: UInt32
    
    init?(_ data:DataInputStream) {
        guard let class_idx = try? data.readU2() else {
            return nil
        }
        
        guard let type_idx = try? data.readU2() else {
            return nil
        }
        
        guard let name_idx = try? data.readU4() else {
            return nil
        }
        
        self.class_idx = class_idx
        self.type_idx = type_idx
        self.name_idx = name_idx
    }
}

public struct FieldDecl {
    public let definer: String // the definer of this field
    public let type: String // the type of this field
    public let name: String // the name of this field
}

