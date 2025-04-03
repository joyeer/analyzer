//
//  ProtoItem.swift
//  ApkAnalyzer
//
//  Created by Qing Xu on 9/7/19.
//

import Common

struct proto_id_item {
    let shorty_idx: UInt32
    let return_type_idx: UInt32
    let parameters_off: UInt32
    
    init?(_ data:DataInputStream) {
        guard let shorty_idx = try? data.readU4() else {
            return nil
        }
        
        guard let return_type_idx = try? data.readU4() else {
            return nil
        }
        
        guard let parameters_off = try? data.readU4() else {
            return nil
        }
        
        self.shorty_idx = shorty_idx
        self.return_type_idx  = return_type_idx
        self.parameters_off = parameters_off
    }
}

// proto_id_item -> ProtoDecl
public struct ProtoDecl {
    public let shorty: String
    public let returnType: String
    public let parameterTypes: [String]
    
    public var description: String {
        return "(\(parameterTypes.joined(separator: "")))\(returnType)"
    }
}
