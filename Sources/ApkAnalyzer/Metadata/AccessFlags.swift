//
//  AccessFlags.swift
//  DecompileAndroid
//
//  Created by Qing Xu on 2019/10/3.
//

public enum AccessFlagScope {
    case `class`
    case method
    case field
}

public class AccessFlag {
    static let PUBLIC = "public"
    static let PRIVATE = "private"
    static let PROTECTED = "protected"
    static let STATIC = "static"
    static let FINAL = "final"
    static let INTERFACE = "interface"
    static let ABSTRACT = "abstract"
    static let VOLATILE = "volatile"
    static let TRANSIENT = "transient"
    static let SYNCHRONIZED = "synchronized"
    static let STRICT = "strictfp"
    static let NATIVE = "native"
    
    static let ACC_PUBLIC:UInt32 = 0x0001
    static let ACC_PRIVATE:UInt32  = 0x0002
    static let ACC_PROTECTED:UInt32  = 0x0004
    static let ACC_STATIC:UInt32  = 0x0008
    static let ACC_FINAL:UInt32  = 0x0010
    static let ACC_SUPER:UInt32  = 0x0020
    static let ACC_SYNCHRONIZED:UInt32 = 0x0020
    static let ACC_VOLATILE:UInt32 = 0x0040
    static let ACC_BRIDGE:UInt32 = 0x0040
    static let ACC_TRANSIENT:UInt32 = 0x0080
    static let ACC_VARARGS:UInt32 = 0x0080
    static let ACC_NATIVE:UInt32 = 0x0100
    static let ACC_INTERFACE:UInt32  = 0x0200
    static let ACC_ABSTRACT:UInt32  = 0x0400
    static let ACC_STRICT:UInt32 = 0x0800
    static let ACC_SYNTHETIC:UInt32  = 0x1000
    static let ACC_ANNOTATION:UInt32  = 0x2000
    static let ACC_ENUM:UInt32  = 0x4000
    static let ACC_MODULE:UInt32  = 0x8000
    static let ACC_CONSTRUCTOR:UInt32 = 0x10000
    static let ACC_DECLARAED_SYNCHRONIZED:UInt32 = 0x20000
    
    fileprivate var value:UInt32
    private let scope:AccessFlagScope
    
    /// Classs Scope
    private static let AccessFlagsForClassScope = [
        ACC_PUBLIC,
        ACC_FINAL,
        ACC_SUPER,
        ACC_INTERFACE,
        ACC_ABSTRACT,
        ACC_SYNTHETIC,
        ACC_ANNOTATION,
        ACC_ENUM,
        ACC_MODULE
    ]
    
    private static let AccessFlagNameMappingForClassScope = [
        ACC_PUBLIC : PUBLIC,
        ACC_FINAL: FINAL,
        ACC_SUPER: "",
        ACC_INTERFACE: "",
        ACC_ABSTRACT: ABSTRACT,
        ACC_SYNTHETIC: "",
        ACC_ANNOTATION: "",
        ACC_ENUM: "",
        ACC_MODULE: ""
    ]
    
    private static let AccessFlagsNameValueMappingForClassScope:[String: UInt32] = {
        var nameValueMapping = [String:UInt32]()
        _ = AccessFlagNameMappingForClassScope.map({ (key:UInt32, value:String) in
            if value != "" {
                nameValueMapping[value] = key
            }
        })
        return nameValueMapping
    }()

    /// Field
    private static let AccessFlagsForFieldScope = [
        ACC_PUBLIC,
        ACC_PRIVATE,
        ACC_PROTECTED,
        ACC_STATIC,
        ACC_FINAL,
        ACC_VOLATILE,
        ACC_TRANSIENT,
        ACC_SYNTHETIC,
        ACC_ENUM
    ]
    
    private static let AccessFlagsNameMappingForFieldScope = [
        ACC_PUBLIC : PUBLIC,
        ACC_PRIVATE: PRIVATE,
        ACC_PROTECTED: PROTECTED,
        ACC_STATIC: STATIC,
        ACC_FINAL: FINAL,
        ACC_VOLATILE: VOLATILE,
        ACC_TRANSIENT: TRANSIENT,
        ACC_SYNTHETIC: "",
        ACC_ENUM: ""
    ]
    
    private static let AccessFlagsNameValueMappingForFieldScope:[String: UInt32] = {
        var nameValueMapping = [String:UInt32]()
        _ = AccessFlagsNameMappingForFieldScope.map({ (key:UInt32, value:String)  in
            if value != "" {
                nameValueMapping[value] = key
            }
        })
        return nameValueMapping
    }()
    
    // Methods
    private static let AccessFlagsForMethodScope = [
        ACC_PUBLIC,
        ACC_PRIVATE,
        ACC_PROTECTED,
        ACC_STATIC,
        ACC_FINAL,
        ACC_SYNCHRONIZED,
        ACC_BRIDGE,
        ACC_VARARGS,
        ACC_NATIVE,
        ACC_ABSTRACT,
        ACC_STRICT,
        ACC_SYNTHETIC,
    ]
    
    private static let AccessFlagsNameMappingForMethodScope = [
        ACC_PUBLIC: PUBLIC,
        ACC_PRIVATE: PRIVATE,
        ACC_PROTECTED: PROTECTED,
        ACC_STATIC: STATIC,
        ACC_FINAL: FINAL,
        ACC_SYNCHRONIZED: SYNCHRONIZED,
        ACC_BRIDGE: "",
        ACC_VARARGS: "",
        ACC_NATIVE: NATIVE,
        ACC_ABSTRACT: ABSTRACT,
        ACC_STRICT: STRICT,
        ACC_SYNTHETIC: ""
    ]
    
    private static let AccessFlagsNameValueMappingForMethodScope:[String:UInt32] = {
        var nameValueMapping = [String:UInt32]()
        _ = AccessFlagsNameMappingForMethodScope.map({ (key:UInt32, value:String) in
            if value != "" {
                nameValueMapping[value] = key
            }
        })
        return nameValueMapping
    }()
    
    public init(_ accessFlag:UInt32, withScope scope:AccessFlagScope) {
        value = accessFlag
        self.scope = scope
    }
    
    // constructor for restoring the value from code level
    public init(_ flags:[String], withScope scope:AccessFlagScope) {
        var value:UInt32 = 0
        self.scope = scope
        let accessFlags:[String:UInt32]
        switch self.scope {
        case .class:
            accessFlags = AccessFlag.AccessFlagsNameValueMappingForClassScope
        case .method:
            accessFlags = AccessFlag.AccessFlagsNameValueMappingForMethodScope
        case .field:
            accessFlags = AccessFlag.AccessFlagsNameValueMappingForFieldScope
        }
        
        for flag in flags {
            let flagValue = accessFlags[flag]!
            value = value | flagValue;
        }
        self.value = value
    }
    
    public var isConstructor: Bool {
        return value & AccessFlag.ACC_CONSTRUCTOR == AccessFlag.ACC_CONSTRUCTOR
    }
    
    public var isInterface: Bool {
        return (value & AccessFlag.ACC_INTERFACE) == AccessFlag.ACC_INTERFACE
    }
    
    public var isEnum: Bool {
        return (value & AccessFlag.ACC_ENUM) == AccessFlag.ACC_ENUM
    }
    
    public var isAnnotation: Bool {
        return (value & AccessFlag.ACC_ANNOTATION) == AccessFlag.ACC_ANNOTATION
    }
    
    public var isStatic : Bool {
        return (value & AccessFlag.ACC_STATIC ) == AccessFlag.ACC_STATIC
    }
    
    public var isAbstract: Bool {
        return (value & AccessFlag.ACC_ABSTRACT) == AccessFlag.ACC_ABSTRACT
    }
    
    public var isNative: Bool {
        return (value & AccessFlag.ACC_NATIVE) == AccessFlag.ACC_NATIVE
    }
    
    public var description : String {
        var accessFlags :[UInt32]?
        var accessFlagsNameMapping :[UInt32: String]?
        switch scope {
        case .`class`:
            accessFlags = AccessFlag.AccessFlagsForClassScope
            accessFlagsNameMapping = AccessFlag.AccessFlagNameMappingForClassScope
        case .method:
            accessFlags = AccessFlag.AccessFlagsForMethodScope
            accessFlagsNameMapping = AccessFlag.AccessFlagsNameMappingForMethodScope
        case .field:
            accessFlags = AccessFlag.AccessFlagsForFieldScope
            accessFlagsNameMapping = AccessFlag.AccessFlagsNameMappingForFieldScope
        }
        
        var result:String = ""
        for accessFlag in accessFlags! {
            if ( accessFlag & value ) == accessFlag {
                let name = accessFlagsNameMapping![accessFlag]
                
                if name != nil && name!.count > 0 {
                    if result.count > 0 {
                        result += " " + name!
                    } else {
                        result += name!
                    }
                }
            }
        }
        return result
    }
    
    public static func isValid(accessFlag flagString:String, inScope scope:AccessFlagScope) -> Bool {
        let nameValueMapping:[String:UInt32]
        switch scope {
        case .class:
            nameValueMapping = AccessFlagsNameValueMappingForClassScope
        case .method:
            nameValueMapping = AccessFlagsNameValueMappingForMethodScope
        case .field:
            nameValueMapping = AccessFlagsNameValueMappingForFieldScope
        }
        return nameValueMapping[flagString] != nil
    }
}

func & (left:AccessFlag, right:UInt32) -> AccessFlag {
    let value:UInt32 = left.value & right
    left.value = value
    return left
}
