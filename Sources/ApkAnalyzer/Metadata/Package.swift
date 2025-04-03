//
//  File.swift
//  
//
//  Created by Joyeer on 2019/11/22.
//

import Foundation

public struct Package {
    public let name: String
    public let classes: [Class]
    
    public init(name: String, classes: [Class]) {
        self.name = name
        self.classes = classes
    }
}
