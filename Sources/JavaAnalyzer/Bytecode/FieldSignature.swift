//
//  FieldSignature.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/7/18.
//

import Foundation

/**
 * FieldSignature:
 *  ReferenceTypeSignature
 */
public class FieldSignature {
    
    public let type:JType;
    public let signature: String
    
    public init(signature: String) throws {
        self.signature = signature
        let parser = FieldSignatureParser(signature: signature)
        type = try parser.parse()
    }
}
