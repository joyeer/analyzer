//
//  ARSCResTableConfig.swift
//  
//
//  Created by Joyeer on 2019/12/19.
//

import Common

struct ARSCResTableConfig {
    let start: Int
    let size: UInt32
    let imsi: UInt32
    let locale: UInt32
    let screenType: UInt32
    let input: UInt32
    let screenSize: UInt32
    let version: UInt32
    let screenConfig: UInt32
    let screenSizeDp: UInt32
    let screenConfig2: UInt32
    let exceedingSize: Int
    let padding:[UInt8]
    
    init(_ reader: DataInputStream) throws {
        start = reader.position
        size = try reader.readU4()
        imsi = try reader.readU4()
        locale = try reader.readU4()
        screenType = try reader.readU4()
        input = try reader.readU4()
        screenSize = try reader.readU4()
        version = try reader.readU4()
        
        if size >= 32 {
            screenConfig = try reader.readU4()
        } else {
            screenConfig = 0
        }
        
        if size >= 36 {
            screenSizeDp = try reader.readU4()
        } else {
            screenSizeDp = 0
        }
        
        if size >= 40 {
            screenConfig2 = try reader.readU4()
        } else {
            screenConfig2 = 0
        }
        
        exceedingSize = Int(size) - (reader.position - start)
        padding = try reader.readBytes(exceedingSize)
    }
}
