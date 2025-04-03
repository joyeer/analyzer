//
//  File.swift
//
//
//  Created by Joyeer on 2019/12/4.
//

import Foundation

open class CodePrinter {

    
    private var previousLineStartAt:Int = 0
    private var previousLineEndAt:Int = -1
    private var tabCount = 0

    public private(set) var output = [String]()
    
    public init() {
    }
    
    public func space() {
        output.append(" ")
        
    }
    public func print(number: String) {
        output.append(number)
    }
    
    public func print(opcode: String) {
        output.append(opcode)
    }
    
    public func print(register: String) {
        print(text: register)
    }
    
    
    public func print(text: String) {
        print(identifier: text)
    }
    
    public func comma() {
        print(identifier: ", ")
    }
    
    public func print(lineNumber:Int) {
        output.append(String(format:"%04X", lineNumber))
    }
    
    public func print(branch: Int) {
        output.append(String(format:"%04X", branch))
    }
    
    public func print(string: String) {
        output.append("\"\(string.escaping())\"")
    }
    
    public func print(keyword: String) {
        output.append(keyword)
    }
    
    public func newLine() {
        
        output.append("\n")
        for _ in 0 ..< tabCount {
            space()
        }
    }
    
    public func incTab() {
        tabCount += 1
    }
    
    public func decTab() {
        tabCount -= 1
    }
    
    public func resetTab(count:Int) {
        tabCount = count
    }

    public func print(identifier: String) {
        output.append(identifier)
    }
        
    public func print(comment: String) {
        output.append(comment)
    }
    
    open func print(type: String) {
        output.append(type)
    }
}

public extension String {
    
    func escaping() -> String {
        // \b = \u{8}
        // \f = \u{12}
        return self
            .replacingOccurrences(of:"\"", with: "\\\"")
            .replacingOccurrences(of:"\n", with: "\\n")
            .replacingOccurrences(of:"\u{8}", with: "\\b")
            .replacingOccurrences(of:"\u{12}", with: "\\f")
            .replacingOccurrences(of:"\r", with: "\\r")
            .replacingOccurrences(of:"\t", with: "\\t")
    }

}
