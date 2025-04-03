//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/5.
//

import Foundation


public class StringTable {
    var rawStrings = [String]()
    
    var count: Int {
        return rawStrings.count
    }
    
    func append(_ string: String) {
        rawStrings.append(string)
    }
    
    public subscript(_ index:Int) -> String {
        return rawStrings[index]
    }
}
