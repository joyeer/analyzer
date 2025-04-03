//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/19.
//

import Common

struct ARSCResTableStringPoolRef {
    let start: Int
    let size: UInt16
    let res0: UInt8
    let data_type: UInt8
    let data: UInt32
    
    init(_ reader: DataInputStream) throws {
        start = reader.position
        size = try reader.readU2()
        res0 = try reader.readU()
        guard res0 == 0 else {
            throw IOError.format
        }
        data_type = try reader.readU()
        data = try reader.readU4()
        
        
    }
}
