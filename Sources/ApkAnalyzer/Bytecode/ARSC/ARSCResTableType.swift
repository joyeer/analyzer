//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/19.
//

import Common

// ResTable_type
struct ARSCResTableType {
    let id: UInt8
    let flags: UInt8
    let reserved: UInt16
    let entryCount: UInt32
    let entriesStart: UInt32
    let config: ARSCResTableConfig
    
    init(_ reader: DataInputStream) throws {
        id = try reader.readU()
        flags = try reader.readU()
        reserved = try reader.readU2()
        guard reserved == 0 else {
            throw IOError.format
        }
        entryCount = try reader.readU4()
        entriesStart = try reader.readU4()
        config = try ARSCResTableConfig(reader)
        
    }
}
