//
//  Parameter.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/7/23.
//

import Foundation

public class Parameter {
    public let type: JType
    public var name: String = ""
    public var annotations = [Annotation]()
    
    init(type:JType) {
        self.type = type
    }
}
