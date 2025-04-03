//
//  BlockStatements.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/8/6.
//

import Foundation

class BlockStatement : Statement {
    
}

class IfStatement : BlockStatement {
    let conditional: ExpressionValue
    var statements:[Statement]
    
    init(compare:ExpressionValue, statements:[Statement]) {
        self.conditional = compare
        self.statements = statements
    }
    
    public var conditionExpressionDescription : String {
        return conditional.description
    }
}

class IfElseStatement : BlockStatement {
    let conditional : ExpressionValue
    var ifBlockStatements:[Statement]
    var elseBlockStatements:[Statement]
    
    init(conditional: ExpressionValue, ifBlockStatements:[Statement], elseBlockStatements:[Statement]) {
        self.conditional = conditional
        self.ifBlockStatements = ifBlockStatements
        self.elseBlockStatements = elseBlockStatements
    }
}

class SynchronizedStatement : BlockStatement {
    
    let lockObject: Value
    var statements: [Statement]
    
    init(lock:Value, statements:[Statement]) {
        self.lockObject = lock
        self.statements = statements
    }
}

class LoopStatement : BlockStatement {
    let conditional: Statement
    var statements: [Statement]
    
    init(conditional: Statement, statements:[Statement]) {
        self.conditional = conditional
        self.statements = statements
        super.init()
    }
}

class CatchStatement : BlockStatement {
    let variable:LocalVariable
    var statements: [Statement] {
        didSet {
            
            // Remove the try { ... } catch(Throwable ex) { ... } 's Throwable ex variable declaration here
            if statements.count > 0 {
                if let localVariableDeclarationStatement = statements.first! as? LocalVariableDeclarationStatement {
                    if localVariableDeclarationStatement.variable == variable {
                        statements.removeFirst()
                    }
                }
            }
        }
    }
    init(variable:LocalVariable, statements: [Statement]) {
        self.variable = variable
        self.statements = statements
        super.init()
    }
}

class TryCatchFinallyStatement : BlockStatement {
    var tryBlock: [Statement]
    var catchBlocks = [CatchStatement]()
    var finallyBlock :[Statement]? = nil
    
    init(try: [Statement]) {
        tryBlock = `try`
        super.init()
    }
}

class CaseStatement : BlockStatement {
    var matches: [Int]
    var statements:[Statement]
    init(matches:[Int], statements:[Statement]) {
        self.statements = statements
        self.matches = matches
    }
}

class SwitchStatement : BlockStatement {
    let key:Value
    var `default`: [Statement]
    let cases:[CaseStatement]
    
    init(key:Value, cases:[CaseStatement], `default`:[Statement]) {
        self.key = key
        self.default = `default`
        self.cases = cases
        super.init()
    }
    
}
