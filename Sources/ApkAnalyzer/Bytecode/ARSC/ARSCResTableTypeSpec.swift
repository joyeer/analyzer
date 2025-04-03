//
//  ARSCResTableTypeSpec.swift
//
//
//  Created by Joyeer on 2019/12/19.
//

import Common

struct ARSCResTableTypeSpec {
    let id: UInt8
    let res0: UInt8
    let res1: UInt16
    let entryCount: UInt32
    let entries:[UInt32]
    
    init(_ reader: DataInputStream) throws {
        id = try reader.readU()
        res0 = try reader.readU()
        res1 = try reader.readU2()
        
        guard res0 == 0 else {
            throw IOError.format
        }
        
        guard res1 == 0 else {
            throw IOError.format
        }
        
        entryCount = try reader.readU4()
        var entries = [UInt32]()
        for _ in 0 ..< entryCount {
            entries.append(try reader.readU4())
        }
        
        self.entries = entries
    }
}

