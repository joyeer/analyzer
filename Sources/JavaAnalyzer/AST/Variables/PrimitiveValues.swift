//
//  PrimitiveValues.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/8/6.
//

import Foundation

class PrimitiveValue : Value {
}

class PrimitiveValueHolder<T> : PrimitiveValue {
    public let rawValue: T
    init(type: JType, value: T) {
        self.rawValue = value
        super.init(type: type)
    }
}

class IntegerValue : PrimitiveValueHolder<Int> {
    init(value:Int){
        super.init(type: .Integer, value: value)
    }
    
    override var description: String {
        return "\(rawValue)"
    }
}

class FloatValue : PrimitiveValueHolder<Float> {
    init(value:Float){
        super.init(type: .Float, value: value)
    }
    
    override var description: String {
        return "\(rawValue)"
    }
}

class CharValue : PrimitiveValueHolder<Character> {
    init(value:Character) {
        super.init(type: .Char, value: value)
    }
    
    override var description: String {
        return "'\(rawValue)'"
    }
}

class ShortValue : PrimitiveValueHolder<Int16> {
    init(value:Int16) {
        super.init(type: .Short, value: value)
    }
    
    override var description: String {
        return "\(rawValue)"
    }
}

class DoubleValue : PrimitiveValueHolder<Double> {
    init(value: Double) {
        super.init(type: .Double, value: value)
    }
    
    override var description: String {
        return "\(rawValue)"
    }
}

class LongValue : PrimitiveValueHolder<Int64> {
    init(value: Int64) {
        super.init(type: .Long, value: value)
    }
    
    override var description: String {
        return "\(rawValue)"
    }
}

class BooleanValue : PrimitiveValueHolder<Bool> {
    init(of rawValue:Int) {
        if rawValue <= 0 {
            super.init(type: .Boolean, value: false)
        } else {
            super.init(type: .Boolean, value: true)
        }
    }
    nonisolated(unsafe) static let True = BooleanValue(of: 1)
    nonisolated(unsafe) static let False = BooleanValue(of: 0)
    
    override var description: String {
        return rawValue == true ? "true": "false"
    }
}

class StringValue : PrimitiveValueHolder<String> {
    init(value: String) {
        super.init(type: ObjectType.String, value: value)
    }
    
    override var description: String {
        return "\"\(self.rawValue.escapeString())\""
    }
}

// This is for Java's class type , e.g. Long.class , which cannot be changed, it's like a String
class ClassTypeValue : PrimitiveValueHolder<String> {
    
}

extension String {
    func escapeString() -> String {
        return self.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\"\"")
    }
}
