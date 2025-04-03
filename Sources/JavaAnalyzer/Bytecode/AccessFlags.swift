
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
    static let SYNTHETIC = "synthetic"
    static let ENUM = "enum"
    
    static let ACC_PUBLIC:UInt16 = 0x0001
    static let ACC_PRIVATE:UInt16  = 0x0002
    static let ACC_PROTECTED:UInt16  = 0x0004
    static let ACC_STATIC:UInt16  = 0x0008
    static let ACC_FINAL:UInt16  = 0x0010
    static let ACC_SUPER:UInt16  = 0x0020
    static let ACC_SYNCHRONIZED:UInt16 = 0x0020
    static let ACC_VOLATILE:UInt16 = 0x0040
    static let ACC_BRIDGE:UInt16 = 0x0040
    static let ACC_TRANSIENT:UInt16 = 0x0080
    static let ACC_VARARGS:UInt16 = 0x0080
    static let ACC_NATIVE:UInt16 = 0x0100
    static let ACC_INTERFACE:UInt16  = 0x0200
    static let ACC_ABSTRACT:UInt16  = 0x0400
    static let ACC_STRICT:UInt16 = 0x0800
    static let ACC_SYNTHETIC:UInt16  = 0x1000
    static let ACC_ANNOTATION:UInt16  = 0x2000
    static let ACC_ENUM:UInt16  = 0x4000
    static let ACC_MODULE:UInt16  = 0x8000
    
    fileprivate var value:UInt16
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
    
    private static let AccessFlagsNameValueMappingForClassScope:[String: UInt16] = {
        var nameValueMapping = [String:UInt16]()
        _ = AccessFlagNameMappingForClassScope.map({ (key:UInt16, value:String) in
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
        ACC_SYNTHETIC: SYNTHETIC,
        ACC_ENUM: ENUM
    ]
    
    private static let AccessFlagsNameValueMappingForFieldScope:[String: UInt16] = {
        var nameValueMapping = [String:UInt16]()
        _ = AccessFlagsNameMappingForFieldScope.map({ (key:UInt16, value:String)  in
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
        ACC_SYNTHETIC
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
    
    private static let AccessFlagsNameValueMappingForMethodScope:[String:UInt16] = {
        var nameValueMapping = [String:UInt16]()
        _ = AccessFlagsNameMappingForMethodScope.map({ (key:UInt16, value:String) in
            if value != "" {
                nameValueMapping[value] = key
            }
        })
        return nameValueMapping
    }()
    
    init(_ accessFlag:UInt16, withScope scope:AccessFlagScope) {
        value = accessFlag
        self.scope = scope
    }
    
    // constructor for restoring the value from code level
    public init(_ flags:[String], withScope scope:AccessFlagScope) {
        var value:UInt16 = 0
        self.scope = scope
        let accessFlags:[String:UInt16]
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
    
    public var isInterface: Bool {
        get {
            return (value & AccessFlag.ACC_INTERFACE) == AccessFlag.ACC_INTERFACE
        }
    }
    
    public var isEnum: Bool {
        get {
            return (value & AccessFlag.ACC_ENUM) == AccessFlag.ACC_ENUM
        }
    }
    
    public var isAnnotation: Bool {
        get {
            return (value & AccessFlag.ACC_ANNOTATION) == AccessFlag.ACC_ANNOTATION
        }
    }
    
    public var isStatic : Bool {
        get {
            return (value & AccessFlag.ACC_STATIC ) == AccessFlag.ACC_STATIC
        }
    }
    
    public var isAbstract: Bool {
        get {
            return (value & AccessFlag.ACC_ABSTRACT) == AccessFlag.ACC_ABSTRACT
        }
    }
    
    public var isNative: Bool {
        get {
            return (value & AccessFlag.ACC_NATIVE) == AccessFlag.ACC_NATIVE
        }
    }
    
    public var description : String {
        
        get {
            var accessFlags :[UInt16]?
            var accessFlagsNameMapping :[UInt16: String]?
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
    }
    
    public static func isValid(accessFlag flagString:String, inScope scope:AccessFlagScope) -> Bool {
        let nameValueMapping:[String:UInt16]
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

func & (left:AccessFlag, right:UInt16) -> AccessFlag {
    let value:UInt16 = left.value & right
    left.value = value
    return left
}
