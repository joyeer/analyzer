
//
//  MethodSignature.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/7/21.
//

import Common

public class MethodSignature {
    public let signature: String
    public let typeParameters:[TypeParameter]
    public let parameters:[JType]
    public let result:JType
    public let `throws`:[JType]
    
    init(signature: String, typeParameters:[TypeParameter], parameters:[JType], result:JType, `throws`:[JType]) {
        self.signature = signature
        self.typeParameters = typeParameters
        self.parameters = parameters
        self.result = result
        self.throws = `throws`
    }
}
