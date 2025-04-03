//
//  File.swift
//  
//
//  Created by Joyeer on 2020/4/19.
//

import Foundation


public struct PackageSpecifier : CustomStringConvertible, Equatable {
    public var identifiers: [String]
    
    public var description: String {
        return identifiers.joined(separator: ".")
    }
    
    public var descriptor: String {
        return identifiers.joined(separator: "/")
    }
}
