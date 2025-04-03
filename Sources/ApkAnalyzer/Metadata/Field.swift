//
//  File.swift
//  
//
//  Created by Joyeer on 2019/11/28.
//

import Foundation

public struct Field {
    public let accessFlag: AccessFlag
    public let type: String
    public let name: String
    public let index: Int
    
    public init(accessFlags: AccessFlag, type: String, name:String, index:Int) {
        self.accessFlag = accessFlags
        self.name = name
        self.type = type
        self.index = index
    }
}
