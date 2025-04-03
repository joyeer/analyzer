//
//  ExpressionStatements.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/8/7.
//

import Foundation


/**
 * The ExpressionStatement is present for a expression statement
 */
class ExpressionStatement : Statement {
    var resultType: JType
    init(resultType: JType) {
        self.resultType = resultType
    }
    
    /**
        convert to Value object
     */
    func asValue() -> ExpressionValue {
        return ExpressionValue(expression: self)
    }
}

/**
 * Method invocation statement for both static method invocation and feild method invocation
 */
class MethodInvocationStatement : ExpressionStatement {
    
    let name:String
    private(set) var instance:Value?
    private(set) var ownerClass:JType
    private(set) var parameters:[Value]
    
    /// Static method invocation
    init(ownerClass: JType, name:String, returnType: JType, parameters:[Value]) {
        self.name = name
        self.parameters = parameters
        self.ownerClass = ownerClass
        super.init(resultType: returnType)
    }
    
    /// Field method invocation
    convenience init(instance:Value, ownerClass:JType, name:String, returnType: JType, parameters:[Value]) {
        self.init(ownerClass:ownerClass, name:name, returnType:returnType, parameters:parameters)
        self.instance = instance
    }
    
    public override var description: String {
        var params = [String]()
        for parameter in parameters {
            params.append(parameter.description)
        }
        if instance is SuperValue {
            if name == "<init>" {
                return "super(" + params.joined(separator: ", ") + ")"
            } else {
                return "super." + name + "(" + params.joined(separator: ", ") + ")"
            }
            
        } else {
            if let referenceValue = instance as? LocalVariableReferenceValue {
                let localVariable = referenceValue.variable
                if localVariable.name == "this" {
                    return name + "(" + params.joined(separator: ", ") + ")"
                }
            }
            if instance != nil {
                return instance!.description + "." + name + "(" + params.joined(separator: ", ") + ")"
            } else {
                return ownerClass.description + "." + name + "(" + params.joined(separator: ", ") + ")"
            }
        }
    }
}

class DynamicMethodInvocationStatement: ExpressionStatement {
    init( name:String, returnType: JType, parameters:[Value]) {
        super.init(resultType: returnType)
    }
    
    override var description: String {
        return "dynamic method"
    }
}

/**
 The statement for type casting
 */
class CheckcastStatement: ExpressionStatement {
    let value: Value
    init(value: Value, type:JType) {
        self.value = value
        super.init(resultType: type)
    }
    
    public override var description: String {
        return "(" + resultType.description + ") " + value.description
    }
}

/**
    Check the object reference's type is equals to given type
 */
class InstanceofStatement : ExpressionStatement {
    public let type: JType
    public let objref: Value
    init(objref: Value, type: JType) {
        self.type = type
        self.objref = objref
        super.init(resultType: .Boolean)
    }
    
    public override var description: String {
        return objref.description + " instanceof " + type.description
    }
}

/// For the statement ?:
class ConditionalStatement :  ExpressionStatement {
    let express: Value
    let leftReturn: Value
    let rightReturn: Value
    
    init(express: Value, leftReturn: Value, rightReturn: Value) {
        self.express = express
        self.leftReturn = leftReturn
        self.rightReturn = rightReturn
        if !(self.rightReturn is NullValue) {
            super.init(resultType: self.rightReturn.type)
        } else if !(self.leftReturn is NullValue) {
            super.init(resultType: self.leftReturn.type)
        } else {
            fatalError()
        }
    }
    
    public override var description: String {
        
        var leftReturn = self.leftReturn
        var rightReturn = self.rightReturn
        
        // For resultType is Boolean, we treat 1 as true and 0 as false
        if resultType == .Boolean {
            if let integerValue = leftReturn as? IntegerValue{
                leftReturn = BooleanValue(of: integerValue.rawValue)
            }
            
            if let integerValue = rightReturn as? IntegerValue {
                rightReturn = BooleanValue(of: integerValue.rawValue)
            }
        }
        
        
        // Simplify the statement
        if resultType == .Boolean {
            if leftReturn is BooleanValue && rightReturn is BooleanValue {
                let leftBoolValue = leftReturn as! BooleanValue
                let rightBoolValue = rightReturn as! BooleanValue
                if leftBoolValue.rawValue == true && rightBoolValue.rawValue == false {
                    return express.description
                }
            }
            
            if leftReturn is ExpressionValue && rightReturn is BooleanValue {
                let leftExpressionValue = leftReturn as! ExpressionValue
                let rightBoolValue = rightReturn as! BooleanValue
                if leftExpressionValue.expression.resultType == .Boolean && rightBoolValue.rawValue == false {
                    return express.description + " && " + leftExpressionValue.description
                }
            }
        }
        
        
        return "(" + express.description + " ? " + leftReturn.description + " : " + rightReturn.description + ")"
    }
    
    override var resultType: JType {
        didSet {
            if let leftReturnExpressionValue = leftReturn as? ExpressionValue {
                leftReturnExpressionValue.expression.resultType = resultType
            }
            
            if let rightReturnExpressionValue = rightReturn as? ExpressionValue {
                rightReturnExpressionValue.expression.resultType = resultType
            }
        }
    }
    
}


// Handle the new XXXX()
class NewStatement : ExpressionStatement {
    public let type: JType
    public var parameters = [Value]()
    
    init(type: JType) {
        self.type = type
        super.init(resultType: type)
    }
    
    public override var description: String {
        var params = [String]()
        for parameter in parameters {
            params.append(parameter.description)
        }
        return "new " + type.description + "(\(params.joined(separator: ", ")))"
    }
}


/**
    New Array Statement, e.g. new String[] { "String1", "String2" }
 */
class NewArrayStatement : ExpressionStatement {
    let type: JType
    var values: [Value?]
    init(type: JType, count: Int) {
        self.type = type
        values = [Value?](repeating: nil, count: count)
        super.init(resultType: type)
    }
    
    public override var description: String {
        var initials = [String]()
        for value in values {
            if value != nil {
                initials.append(value!.description)
            } else {
                initials.append("null")
            }
        }
        
        return "new \(type)[] {\(initials.joined(separator: ", "))}"
    }
}

class NewPrimaryTypeArrayStatement : ExpressionStatement {
    public let type: JType
    public let count: Value
    init(type: JType, count: Value) {
        self.type = type
        self.count = count
        super.init(resultType: type)
    }
    
    override var description: String {
        return "new \(type)[\(count)]()"
    }
}

class MultiNewArrayStatement : ExpressionStatement {
    let type: JType
    let dimensions: [Value]
    init(type: JType, dimensions:[Value]) {
        self.type = type
        self.dimensions = dimensions
        super.init(resultType: self.type)
    }    
}

class FieldAssignmentStatment : ExpressionStatement {
    public var instance: Value?  = nil
    public let name: String
    public let value: Value

    convenience init(instance:Value, type: JType,  name:String, value: Value) {
        self.init(type:type, name: name, value: value)
        self.instance = instance
    }
    
    init(type: JType, name:String , value: Value) {
        self.name = name
        self.value = value
        super.init(resultType: type)
    }

    public override var description: String {
        if self.instance != nil {
            return "this." + self.name + " = " + self.value.description
        } else {
            return self.name + " = " + self.value.description
        }
    }
}

class UnaryStatement : ExpressionStatement {
    public let expression:Value
    public let `operator`:String
    // Used it for print || 
    public var reversedPrint = false
    
    init(expression: Value, `operator`: String) {
        self.expression = expression
        self.operator = `operator`
        
        switch `operator` {
        case "","!":
            super.init(resultType: .Boolean)
        case "-":
            super.init(resultType: .Integer)
        default:
            fatalError()
        }
    }
    
    public override var description: String {
        var operatorFlag = `operator`
        if reversedPrint {
            switch `operator` {
            case "!":
                operatorFlag = ""
            case "":
                operatorFlag = "!"
            default:
                fatalError()
            }
        }
        if let expressionValue = expression as? ExpressionValue {
            if expressionValue.expression is InstanceofStatement {
                return operatorFlag + "(\(expression.description))"
            }
        }
        
        return operatorFlag + expression.description
    }
}

class BinaryStatement : ExpressionStatement {
    let left: Value
    let right: Value
    let `operator`: String
    var reversedPrint = false
    
    init(left:Value, right: Value, operator:String) {
        self.left = left
        self.right = right
        self.operator = `operator`
        
        switch `operator` {
        case ">=",">", "<", "<=", "!=", "==", "&&":
            super.init(resultType: .Boolean)
        case "+", "-", "&", "^", "/", "<<", ">>", "|":
            super.init(resultType: .Integer)
        case "*":
            super.init(resultType: .Integer)
        case "%":
            super.init(resultType: .Integer)
        default:
            fatalError()
        }
    }
    
    public override var description: String {
        var operatorFlag = `operator`
        if reversedPrint {
            switch `operator` {
            case "==":
                operatorFlag = "!="
            case "!=":
                operatorFlag = "=="
            case ">=":
                operatorFlag = "<"
            default:
                fatalError()
            }
        }
        return left.description + " \(operatorFlag) " + right.description
    }
}

class TernaryStatement : ExpressionStatement {
    let left: Value
    let right: Value
    let conditional: Value
    
    init(left:Value, right:Value, conditional:Value) {
        self.left = left
        self.right = right
        self.conditional = conditional
        super.init(resultType: self.left.type)
    }
    
    override var description: String {
        return "\(conditional) ? \(left) : \(right)"
    }
}

class StringConcatStatement : ExpressionStatement {
    public let strings: [Value]
    init(strings: [Value]) {
        self.strings = strings
        super.init(resultType: ObjectType.String)
    }
    
    public override var description: String {
        var parts = [String]()
        for s in strings {
            parts.append(s.description)
        }
        
        return parts.joined(separator: " + ")
    }
}


class ReturnStatement : ExpressionStatement {
    private(set) var value:Value?
    
    init(value: Value, returnType:JType) {
        self.value = value
        super.init(resultType: returnType)
    }
    
    override init(resultType: JType) {
        super.init(resultType: resultType)
    }
    
    public override var description: String {
        if value == nil {
            return "return"
        } else {
            if self.resultType == .Boolean {
                if let intValue = value as? IntegerValue {
                    if intValue.rawValue == 1 {
                        return "return true"
                    } else if intValue.rawValue == 0 {
                        return "return false"
                    }
                }
            }
            
            if let expressionValue = value as? ExpressionValue {
                expressionValue.expression.resultType = self.resultType
            }
            return "return " +  value!.description
        }
    }
}


class LogicalOperatorStatement : ExpressionStatement {
    let units: [LogicalOperatorUnit]
    init(units:[LogicalOperatorUnit]) {
        self.units = units
        super.init(resultType: .Boolean)
    }
    
    override var description: String {
        var index = 0
        var result = [String]()
        while index < units.count {
            let curUnit = units[index]
            
            if curUnit.continue == false {
                if let unaryStatement = curUnit.expression as? UnaryStatement {
                    unaryStatement.reversedPrint = true
                } else if let binaryStatement = curUnit.expression as? BinaryStatement {
                    binaryStatement.reversedPrint = true
                }                
            }
            result.append(curUnit.expression.description)
            if curUnit.continue == true && index != units.count - 1 {
                result.append("&&")
            } else if curUnit.continue == false && index != units.count - 1 {
                result.append("||")
            }
            index += 1
        }
        return result.joined(separator: " ")
    }
}

class IncrementStatement : ExpressionStatement {
    let variable: LocalVariable
    let constant: Int
    init(variable: LocalVariable, constant:Int) {
        self.variable = variable
        self.constant = constant
        super.init(resultType: .Integer)
    }
    
    override var description: String {
        if constant == 1 {
            return "\(variable.description(target: self.resultType))++"
        } else {
            return "\(variable.description(target: self.resultType)) += 1"
        }
    }
}

class ArrayLengthStatement : ExpressionStatement {
    let value: Value
    init(value: Value) {
        self.value = value
        super.init(resultType: .Integer)
    }
    
    override var description: String {
        return value.description + ".length"
    }
}

class ArrayIndexStatement : ExpressionStatement {
    let value: Value
    let index: Value
    init(value: Value, index: Value) {
        self.value = value
        self.index = index
        super.init(resultType: value.type)
    }
    
    override var description: String {
        return value.description + "[\(index)]"
    }
}
