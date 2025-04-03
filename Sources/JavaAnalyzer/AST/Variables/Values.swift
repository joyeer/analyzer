//
//  Values.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/8/6.
//

import Foundation

public class Value : CustomStringConvertible {
    var type: JType
    init(type: JType) {
        self.type = type
    }
    
    public var description: String {
        return "<Uknown value>"
    }
}

