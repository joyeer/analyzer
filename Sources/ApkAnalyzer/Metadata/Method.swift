//
//  File.swift
//  
//
//  Created by Joyeer on 2019/11/28.
//

import Foundation

public struct Method {
    public let accessFlag: AccessFlag
    public let returnType: String
    public let parameters: [String]
    public let parameterNames: [String]
    public let name: String
    public let code: Code?
    public let index: Int // index in method table
    
    public init(accessFlag: AccessFlag, returnType: String, parameters:[String], parameterNames:[String], name: String, code: Code?, index: Int) {
        self.accessFlag = accessFlag
        self.returnType = returnType
        self.parameters = parameters
        self.parameterNames = parameterNames
        self.name = name
        self.code = code
        self.index = index
    }
}
