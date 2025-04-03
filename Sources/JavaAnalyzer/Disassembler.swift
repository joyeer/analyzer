//
//  Disassembler.swift
//  
//
//  Created by joyeer on 2023/4/16.
//

import Foundation
import Common

/// disassemble all
public class JavaDisassembler {
    
    public init() {
    }
    
    public func disassemble(_ classfile: ClassFile) throws -> String {
        let klass = try Class(classfile)
        let asmRenderer = JavaAsmPrinter(klass)
        return asmRenderer.generate()
    }
    
}
