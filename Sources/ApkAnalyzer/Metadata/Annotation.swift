//
//  File.swift
//  
//
//  Created by Joyeer on 2020/1/3.
//

import Foundation

public enum AnnotationVisibility: Int {
    case build = 0x00
    case runtime = 0x01
    case system = 0x02
}

public struct Annotation {
    public let visibility: AnnotationVisibility?
    public let type: String
    public let elements: [String: Value]
    
    public init(visibility: AnnotationVisibility?, type:String, elements: [String: Value]) {
        self.type = type
        self.visibility = visibility
        self.elements = elements
    }
}
