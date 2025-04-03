//
//  File.swift
//  
//
//  Created by Joyeer on 2019/11/29.
//

import Foundation
import Common

public struct CodeItem {
    let registers_size: UInt16
    let ins_size: UInt16
    let outs_size: UInt16
    let tries_size: UInt16
    let debug_info_off: UInt32
    let insns_size: UInt32
    let insns: [UInt8]
    let padding: UInt16
    let tries: [TryItem]
    let handlers: EncodedCatchHandlerList?
    
    init(_ data:DataInputStream) throws {
        registers_size = try data.readU2()
        ins_size = try data.readU2()
        outs_size = try data.readU2()
        tries_size = try data.readU2()
        debug_info_off = try data.readU4()
        let insns_size = try data.readU4()
        var insns = [UInt8]()
        for _ in 0 ..< insns_size {
            insns.append(try data.readU())
            insns.append(try data.readU())
        }
        self.insns = insns
        self.insns_size = insns_size
        if insns_size > 0 && insns_size % 2 > 0 {
            padding = try data.readU2()
        } else {
            padding = 0
        }
        var tries = [TryItem]()
        for _ in 0 ..< tries_size {
            tries.append(try TryItem(data))
        }
        self.tries = tries
        if tries_size > 0  {
            self.handlers = try EncodedCatchHandlerList(data)
        } else {
            self.handlers = nil
        }
    }
}
