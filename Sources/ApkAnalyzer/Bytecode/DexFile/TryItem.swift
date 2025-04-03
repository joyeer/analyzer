//
//  TryItem.swift
//  
//
//  Created by Joyeer on 2019/11/29.
//

import Common

struct TryItem {
    let start_addr: UInt32
    let insn_count: UInt16
    let handler_off: UInt16
    
    init(_ data:DataInputStream) throws {
        start_addr = try data.readU4()
        insn_count = try data.readU2()
        handler_off = try data.readU2()
    }
}

struct EncodedCatchHandlerList {
    let size: UInt
    let list: [EncodedCatchHandler]
    
    init(_ data: DataInputStream) throws {
        size = try data.readUleb128()
        var list = [EncodedCatchHandler]()
        for _ in 0 ..< size {
            list.append(try EncodedCatchHandler(data))
        }
        self.list = list
    }
}

struct EncodedCatchHandler {
    let size: Int
    let handlers: [EncodedTypeAddrPair]
    let catch_add_addr: UInt
    
    init(_ data: DataInputStream) throws {
        size = try data.readSleb128()
        var handlers = [EncodedTypeAddrPair]()
        for _ in 0 ..< abs(size) {
            handlers.append(try EncodedTypeAddrPair(data))
        }
        self.handlers = handlers
        if size > 0 {
            self.catch_add_addr = 0
        } else {
            self.catch_add_addr = try data.readUleb128()
        }
    }
}


struct EncodedTypeAddrPair {
    let type_idx: UInt
    let addr: UInt
    
    init(_ data: DataInputStream) throws {
        type_idx = try data.readUleb128()
        addr = try data.readUleb128()
    }
}
