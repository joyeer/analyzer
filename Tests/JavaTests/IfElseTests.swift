//
//  IfElseTests.swift
//  Analyzer
//
//  Created by joyeer on 2025/2/3.
//


import Foundation
@testable import JavaAnalyzer

import Testing

struct IfElseTests {
    var classfile: ClassFile
    var klass: Class
    
    init() throws {
        (self.klass, self.classfile) =  get(class: "io.decompile.testdata.IfElse")
    }
    
    @Test func if_() {
        let r = decompile(method: "if_", class: self.klass)
    }
}

