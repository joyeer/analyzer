//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/5.
//

import Foundation

public class FieldTable {
    var rawFields = [FieldDecl]()
    
    subscript(_ index:Int) -> FieldDecl {
        return rawFields[index]
    }
}
