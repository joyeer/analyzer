//
//  Statements.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/7/27.
//

import Foundation

class Statement : CustomStringConvertible {
    // The value is indicate this statement started with which opcode index
    var lineAt: Int = -1
    public var description: String {
        return "statement"
    }
}

///MAKR: Local variable
// Statement for assigning value to LocalVariable
class LocalVariableAssignmentStatement : Statement {
    let variable: LocalVariable
    let value: Value
    
    init(variable: LocalVariable, value: Value) {
        self.variable = variable
        self.value = value
    }
    
   
    
}

class LocalVariableDeclarationAssginmentStatement : Statement {
    let statement: LocalVariableAssignmentStatement
    
    init(statement: LocalVariableAssignmentStatement) {
        self.statement = statement
    }
    }

class LocalVariableDeclarationStatement : Statement {
    public let variable: LocalVariable
    
    init(variable:LocalVariable) {
        self.variable = variable
    }
    
    override var description: String {
        return variable.type.description + " "  + variable.name
    }
}


class ThrowStatement : Statement {
    public let error: Value
    init(error:Value) {
        self.error = error
    }
    
    public override var description: String {
        return "throw \(error)"
    }
}

class BreakStatement : Statement {
    public let label:String = ""
    
    public override var description: String {
        if label.count > 0 {
            return "break \(label)"
        } else {
            return "break"
        }
    }
}

class GotoStatement : Statement {
    var jumpIndexAt: Int
    init(_ index:Int) {
        jumpIndexAt = index
        super.init()
    }
    
    override var description: String {
        return "goto \(jumpIndexAt)"
    }
}

