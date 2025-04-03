//
//  Code.swift
//  CodeAnalyzer
//
//  Created by Joyeer on 2019/11/16.
//  Copyright © 2019 decompile.io. All rights reserved.
//

import Foundation


public struct Code {
    public let registers: Int
    public let instructions: [Instruction]
    
    public init(registers:Int, instructions:[Instruction]) {
        self.registers = registers
        self.instructions = instructions
    }
}
