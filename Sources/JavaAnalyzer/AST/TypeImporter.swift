//
//  TypeImporter.swift
//  DecompileCore
//
//  Created by Qing Xu on 2018/8/8.
//

import Foundation

class TypeImporter {
    
    private var typeCaches = [String: JType]()
    private var classCaches = [String: JType]()
    
    func getImports(package:String) -> [String] {
        var result = [String]()
        for entry in classCaches {
            if let objectType = entry.value as? ObjectType {
                if objectType.package == "java.lang" || objectType.package == package {
                    continue
                }
                result.append(objectType.type)
            }
        }
        result.sort()
        return result
    }
    
    
    func tryImport(type: String) -> JType {
        switch type {
        case "boolean":
            return .Boolean
        case "int":
            return .Integer
        case "short":
            return .Short
        case "char":
            return .Char
        case "float":
            return .Float
        case "double":
            return .Double
        case "long":
            return .Long
        case "null":
            return .Null
        case "void":
            return .Void
        default:
            let typeref = typeCaches[type]
            if typeref == nil {
                let objectType = ObjectType(classType: type)
                typeCaches[type] = objectType
            }
            
            if let objectType = typeCaches[type] as? ObjectType {
                checkingDisplayType(type: objectType)
            }
            
            return typeCaches[type]!
        }
    }
    
    func tryImport(type: JType) -> JType {
        if let objectType = type as? ObjectType {
            let typeref = typeCaches[objectType.description]
            if typeref == nil {
                typeCaches[objectType.description] = objectType
            }
            checkingDisplayType(type: objectType)
        }
        
        return type
    }
    
    private func checkingDisplayType(type: ObjectType) {
        if classCaches[type.shortType] == nil {
            classCaches[type.shortType] = type
            type.displayType = type.shortType
        } else {
            if classCaches[type.shortType]?.type != type.type {
                type.displayType = type.type
            } else {
                type.displayType = type.shortType
            }
        }
        
        for typeParam in type.typeParams {
            if typeParam.parameter != nil {
                _ = tryImport(type: typeParam.parameter!)
            }
        }
    }
}
