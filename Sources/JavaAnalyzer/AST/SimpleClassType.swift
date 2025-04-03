//
//  File.swift
//  
//
//  Created by Joyeer on 2020/4/19.
//

import Foundation

public struct SimpleClassType : CustomStringConvertible {
    
    
    public let identifier: String
    
    public let arguments: [TypeArgument]
    
    public var description: String {
        var output = identifier
        
        if arguments.count > 0 {
            output += "<"
            
            for (index, argument) in arguments.enumerated() {
                if index > 0 {
                    output += ", "
                }
                output += argument.description
            }
            output += ">"
        }
        
        return output
    }
    
    public var descriptor: String {
        var output = identifier
        if arguments.count > 0 {
            output += "<"
            for (index, argument) in arguments.enumerated() {
                if index > 0 {
                    output += ", "
                }
                output += argument.descriptor
            }
            output += ">"
        }
        return output
    }
    
    
}
