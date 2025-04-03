//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/3.
//

import Common

struct PackedSwitchPayload {
    let firstKey: Int32
    let targets: [Int32]
    
    init(_ reader:DataInputStream) throws {
        let size = try reader.readU2()
        firstKey = Int32(bitPattern: try reader.readU4())
        var targets = [Int32]()
        for _ in 0..<size {
            targets.append(Int32(bitPattern:try reader.readU4()))
        }
        self.targets = targets
    }
}


struct SparseSwitchPayload {
    let keys:[Int32]
    let targets:[Int32]
    
    init(_ reader: DataInputStream) throws {
        let size = try reader.readU2()
        var keys = [Int32]()
        var targets = [Int32]()
        for _ in 0 ..< size {
            keys.append(Int32(bitPattern:try reader.readU4()))
        }
        for _ in 0..<size {
            targets.append(Int32(bitPattern:try reader.readU4()))
        }
        self.keys = keys
        self.targets = targets
    }
}

struct FillArrayDataPayload {
    let elementWidth: UInt16
    let size: UInt32
    let data: [UInt8]
    
    init(_ reader: DataInputStream) throws {
        elementWidth = try reader.readU2()
        size = try reader.readU4()
        data = try reader.readBytes(Int(Int(Int(size) * Int(elementWidth) + 1 ) / 2 ) * 2)
        
        if Int(size) * Int(elementWidth)  == 1 {
            print("")
        }
    }
}
