
//  TypeItem.swift
//  ApkAnalyzer
//
//  Created by Qing Xu on 9/7/19.
//

import Common

struct TypeIDItem {
    let description_idx: UInt32
    
    init?(_ data:DataInputStream) {
        guard let description_idx = try? data.readU4() else {
            return nil
        }
        
        self.description_idx = description_idx
    }
}

/// type_list
/// referenced from class_def_item and proto_id_item
struct TypeList {
    let list: [TypeItem]
    
    init?(_ data:DataInputStream) {
        guard let size = try? data.readU4() else {
            return nil
        }
        
        var items = [TypeItem]()
        for _ in 0 ..< size {
            guard let typeItem = TypeItem(data) else {
                return nil
            }
            items.append(typeItem)
        }
        list = items
    }
}

struct TypeItem {
    let type_idx: UInt16
    init?(_ data:DataInputStream) {
        guard let type_idx = try? data.readU2() else {
            return nil
        }
        
        self.type_idx = type_idx
    }
}
