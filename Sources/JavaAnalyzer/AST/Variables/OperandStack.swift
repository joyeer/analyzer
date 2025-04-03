//
//  OperandStack.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/8/7.
//

import Foundation
import Common

class OperandStack {
    
    private var stack = [Value]()
    
    func top() -> Value {
        return stack.last!
    }
    
    func push(value:Value) {
        stack.append(value)
    }
    
    func pop() throws -> Value {
        if stack.count == 0 {
            throw IOError.analyzeStackOverflow
        }
         return stack.popLast()!
    }
    
    func pop(count:Int) throws -> [Value] {
        var result = [Value]()
        for _ in 0 ..< count {
            result.append(try pop())
        }
        return result.reversed()
    }
    
    func reset() {
        stack.removeAll()
    }
    
    var count:Int {
        return stack.count
    }
    
    func contains(value:Value) -> Bool {
        for v in stack {
            if v === value {
                return true
            }
        }
        return false
    }
    
    func replace(value:Value, newValue:Value) {
        var replaceIndeices = [Int]()
        for (index, v) in stack.enumerated() {
            if v === value {
                replaceIndeices.append(index)
            }
        }
        
        for replaceIndex in replaceIndeices {
            stack[replaceIndex] = newValue
        }
    }
}
