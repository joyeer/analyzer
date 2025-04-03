//
//  DebugInfoItem.swift
//  
//
//  Created by Joyeer on 2020/1/4.
//

import Common


struct DebugInfoItem {
    let line_start: Int
    let parameter_names: [Int]
    
    init(_ data: DataInputStream) throws {
        line_start = try Int(data.readUleb128())
        let parameters_size = try data.readUleb128()
        var parameter_names = [Int]()
        for _ in 0 ..< parameters_size {
            parameter_names.append(Int(try data.readUleb128()) - 1)
        }
        self.parameter_names = parameter_names
    }
}
