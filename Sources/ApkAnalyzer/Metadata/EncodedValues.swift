//
//  File.swift
//  
//
//  Created by Joyeer on 2020/1/3.
//

import Foundation

public struct Value {
    public let type:Int
    public let arg:Int
    public let value: Any?
    
    public init(type: Int, arg: Int, value:Any? ) {
        self.type = type
        self.arg = arg
        self.value = value
    }
}
