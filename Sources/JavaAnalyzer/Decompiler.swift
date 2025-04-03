//
//  Decompiler.swift
//  
//
//  Created by joyeer on 2023/5/2.
//

import Foundation


class JavaDecompiler {
    
    let classfile: ClassFile
    
    init(_ classfile: ClassFile) {
        self.classfile = classfile
    }
    
    func decompile(method: Method) throws -> String {
        
        // first step is build control flow graph
        let builder = ControlFlowGraphBuilder(method.reader)
        try builder.build(method)
        return ""
    }
}
