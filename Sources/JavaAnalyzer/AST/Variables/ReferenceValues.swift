//
//  ReferenceValues.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/8/6.
//

import Foundation

public class ReferenceValue : Value {
    
}

class LocalVariableReferenceValue : Value {
    let variable:LocalVariable
    init(variable: LocalVariable) {
        self.variable = variable
        super.init(type: variable.type)
    }
    
    override var description: String {
        return variable.name
    }
}

class FieldReferenceValue : ReferenceValue {
    public let name: String
    public var instance: Value?
    public var ownerClass:JType
    
    init(instance: Value?, ownerClass:JType, fieldType:JType, fieldName:String) {
        self.name = fieldName
        self.instance = instance
        self.ownerClass = ownerClass
        super.init(type: fieldType)
    }
    
    convenience init(ownerClass:JType, fieldType:JType, fieldName:String) {
        self.init(instance: nil, ownerClass:ownerClass, fieldType:fieldType, fieldName:fieldName)
    }
    
    public override var description: String {
        if instance != nil {
            return instance!.description + "." + name
        } else {
            return ownerClass.description + "." + name
        }
        
    }
}


class TypeReferenceValue : ReferenceValue {
    public let refType: JType
    override init(type: JType) {
        refType = type
        super.init(type: refType)
    }
    
    override var description: String {
        return refType.description + ".class"
    }
}

class ThisValue : ReferenceValue {
    override var description: String {
        return "this"
    }
}

class SuperValue : ReferenceValue {
    override var description: String {
        return "super"
    }
}

/**
    This holds a ExpressionStatement object as Value object
 */
class ExpressionValue : ReferenceValue {
    var expression: ExpressionStatement
    init(expression: ExpressionStatement) {
        self.expression = expression
        super.init(type: expression.resultType)
    }
    
    public override var description: String {
        return expression.description
    }
    
}

class NullValue : Value {
    nonisolated(unsafe) static let Null = NullValue(type: .Null)
    
    override var description: String {
        return "null"
    }
}

typealias LogicalOperatorUnit =  (expression: ExpressionStatement, `continue`:Bool)

// This is the Logical compute Unit which used in && || operator
class LogicalOperatorUnitValue : Value {
    
    let logical: LogicalOperatorUnit
    init(flag: LogicalOperatorUnit) {
        logical = flag
        super.init(type: .Boolean)
    }
    
}
