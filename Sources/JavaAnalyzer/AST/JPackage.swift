
import Foundation

// MARK :- Package metadata
public class JPackage {
    public private(set) var name: String
    
    public var classes = [Class]()
    init(_ name:String) {
        self.name = name
    }
    
}

extension JPackage : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name.hashValue)
    }
}

public func ==(left: JPackage, right: JPackage) -> Bool {
    return left.name == right.name
}


