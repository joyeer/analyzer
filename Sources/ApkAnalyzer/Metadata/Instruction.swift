//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/4.
//

import Foundation

public struct Instruction {
    public let offset: Int
    public let opcode: Int
    public let raws: [UInt8]
    public let payload: Any?
    
    public init(offset:Int, opcode: Int, raws: [UInt8], payload:Any? = nil) {
        self.offset = offset
        self.opcode = opcode
        self.raws = raws
        self.payload = payload
    }
}
