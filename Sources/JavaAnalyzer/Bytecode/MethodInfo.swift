//
//  MethodInfo.swift
//  JavaDecompiler
//
//  Created by Qing Xu on 23/01/2018.
//

import Common

// MARK: - Method

public struct MethodInfo {
    
    let access_flags: UInt16
    let name_index: UInt16
    let descriptor_index: UInt16
    let attributes: [AttributeInfo]
    
    init(_ input: DataInputStream, constant reader:ConstantPoolReader) throws {
        access_flags = try input.readU2()
        name_index = try input.readU2()
        descriptor_index = try input.readU2()
        
        let attributes_count = try input.readU2()
        var attributes = [AttributeInfo]()
        for _ in 0 ..< attributes_count {
            let reader = AttributeReader(input, constant: reader)
            let attribute = try reader.read()
            attributes.append(attribute)
        }
        self.attributes = attributes
    }
}

