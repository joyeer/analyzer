//
//  ARSCResTablePackage.swift
//  
//
//  Created by Joyeer on 2019/12/19.
//

import Common

struct ARSCResTablePackage {
    let header: ARSCHeader
    let id:UInt32
    let name:String
    let typeStrings: UInt32
    let lastPublicType: UInt32
    let keyStrings: UInt32
    let lastPublicKey: UInt32
    
    var resId: UInt32 {
        return id << 24
    }
    
    init(_ reader:DataInputStream, header:ARSCHeader) throws {
        self.header = header
        id = try reader.readU4()
        let name = try reader.readBytes(256)
        var string = ""
        name.withUnsafeBufferPointer { pointer in
            string = String(cString: pointer.baseAddress!)
        }
        self.name = string
        typeStrings = try reader.readU4()
        lastPublicType = try reader.readU4()
        keyStrings = try reader.readU4()
        lastPublicKey = try reader.readU4()
    }
}
