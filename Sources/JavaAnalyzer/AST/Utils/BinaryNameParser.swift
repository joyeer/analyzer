//
//  BinaryNameParser.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/9/27.
//

import Foundation

class BinaryNameParser {
    func parse(_ string: String) throws -> String {
        if string.hasPrefix("[") {
            let descriptor = try FieldDescritpor(string)
            return descriptor.javaType
        } else {
            return string.replacingOccurrences(of: "/", with: ".")
        }
    }
}
