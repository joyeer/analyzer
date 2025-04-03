//
//  StringItem.swift
//  ApkAnalyzer
//
//  Created by Qing Xu on 9/7/19.
//

import Common

struct StringIDItem {
    let string_data_off:UInt32
    
    init?(_ data:DataInputStream) {
        guard let data_off = try? data.readU4() else {
            return nil
        }
        string_data_off = data_off
    }
}

struct StringDataItem {
    let utf16_size:UInt
    let data: String
    
    init?(_ data: DataInputStream) {
        guard let utf16_size = try? data.readUleb128() else {
            return nil
        }
        guard let data = try? data.readMutf8(Int(utf16_size)) else {
            return nil
        }
        self.utf16_size = utf16_size
        self.data = data
    }
}
