//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/5.
//

import Foundation

public class MethodTable {
    var rawMethods = [MethodDecl]()
    
    func append(_ decl: MethodDecl) {
        rawMethods.append(decl)
    }
    
    public subscript(_ index:Int) -> MethodDecl {
        return rawMethods[index]
    }
}
