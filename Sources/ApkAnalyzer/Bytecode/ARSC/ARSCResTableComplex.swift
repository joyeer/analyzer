//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/19.
//

import Common


struct ARSCResTableComplex {
    let id_parent: UInt32
    let count: UInt32
    let items: [(UInt32, ARSCResTableStringPoolRef)]
    
    init(_ reader: DataInputStream) throws {
        id_parent = try reader.readU4()
        count = try reader.readU4()
        var items = [(UInt32, ARSCResTableStringPoolRef)]()
        for _ in 0 ..< count {
            let item = (try reader.readU4(), try ARSCResTableStringPoolRef(reader))
            items.append(item)
        }
        self.items = items
    }
}
