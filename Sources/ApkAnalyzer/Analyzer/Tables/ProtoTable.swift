//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/5.
//

import Foundation

public class ProtoTable {
    private var rawProtos = [ProtoDecl]()
    
    func append(_ proto: ProtoDecl) {
        rawProtos.append(proto)
    }
    
    var count: Int {
        return rawProtos.count
    }
    
    public subscript(_ index:Int) -> ProtoDecl {
        return rawProtos[index]
    }
}
