//
//  TestCaseBase.swift
//  
//
//  Created by joyeer on 2023/4/15.
//
import XCTest
@testable import JavaAnalyzer
@testable import Common


func get(class: String) -> (Class, ClassFile) {
    
    let testResourceUrl = "/classes/" + `class`.replacingOccurrences(of: ".", with: "/")
    let url = Bundle.module.url(forResource:testResourceUrl, withExtension: ".class")

    let classfileData = try! Data(contentsOf: url!)
    let inputStream = DataInputStream(classfileData)
    let classfile = try! ClassFile(inputStream)
    return (try! Class(classfile), classfile)
}

func get(method: String, from class: Class) -> JavaAnalyzer.Method {
    return `class`.methods.first { item in
        item.name == method
    }!
}

func decompile(method: String, class: Class) -> String {
    let m = get(method: method, from: `class`)
    let decompiler = JavaDecompiler(`class`.classfile)
    return try! decompiler.decompile(method: m)
}
