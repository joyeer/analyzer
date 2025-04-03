//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/5.
//

import Foundation

public class TypeTable {
    
    var rawTypes = [String]()
    
    public var count: Int {
        return rawTypes.count
    }
    
    func append(_ type:String) {
        rawTypes.append(type)
    }
    
    public subscript(index:Int) -> String {
        return self.rawTypes[index]
    }
}
