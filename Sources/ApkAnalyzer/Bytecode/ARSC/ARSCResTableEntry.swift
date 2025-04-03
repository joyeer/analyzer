//
//  ARSCResTableEntry.swift
//  
//
//  Created by Joyeer on 2019/12/19.
//

import Common

struct ARSCResTableEntry {
    static let FLAG_COMPLEX: UInt16 = 1
    static let FLAG_PUBLIC: UInt16 = 2
    static let FLAG_WEAK: UInt16 = 4
    
    let start: Int
    let size: UInt16
    let flags: UInt16
    let index: UInt32
    var item: ARSCResTableComplex?
    var key: ARSCResTableStringPoolRef?
    
    init(_ reader: DataInputStream) throws {
        start = reader.position
        size = try reader.readU2()
        flags = try reader.readU2()
        index = try reader.readU4()
        
        if (flags & ARSCResTableEntry.FLAG_COMPLEX) != 0 {
            item = try ARSCResTableComplex(reader)
            key = nil
        } else {
            item = nil
            key = try ARSCResTableStringPoolRef(reader)
        }
    }
    
    var is_weak: Bool {
        return (self.flags & Self.FLAG_WEAK) != 0
    }
}
