//
//  AXMLParser.swift
//  
//
//  Created by Joyeer on 2019/12/19.
//

import Foundation
import Common

// The 'data' is either 0 or 1, specifying this resource is either
// undefined or empty, respectively.
let TYPE_NULL = 0x00
// The 'data' holds a ResTable_ref, a reference to another resource
// table entry.
let TYPE_REFERENCE = 0x01
// The 'data' holds an attribute resource identifier.
let TYPE_ATTRIBUTE = 0x02
// The 'data' holds an index into the containing resource table's
// global value string pool.
let TYPE_STRING = 0x03
// The 'data' holds a single-precision floating point number.
let TYPE_FLOAT = 0x04
// The 'data' holds a complex number encoding a dimension value
// such as "100in".
let TYPE_DIMENSION = 0x05
// The 'data' holds a complex number encoding a fraction of a
// container.
let TYPE_FRACTION = 0x06
// The 'data' holds a dynamic ResTable_ref, which needs to be
// resolved before it can be used like a TYPE_REFERENCE.
let TYPE_DYNAMIC_REFERENCE = 0x07
// The 'data' holds an attribute resource identifier, which needs to be resolved
// before it can be used like a TYPE_ATTRIBUTE.
let TYPE_DYNAMIC_ATTRIBUTE = 0x08
// Beginning of integer flavors...
let TYPE_FIRST_INT = 0x10
// The 'data' is a raw integer value of the form n..n.
let TYPE_INT_DEC = 0x10
// The 'data' is a raw integer value of the form 0xn..n.
let TYPE_INT_HEX = 0x11
// The 'data' is either 0 or 1, for input "false" or "true" respectively.
let TYPE_INT_BOOLEAN = 0x12
// Beginning of color integer flavors...
let TYPE_FIRST_COLOR_INT = 0x1c
// The 'data' is a raw integer value of the form #aarrggbb.
let TYPE_INT_COLOR_ARGB8 = 0x1c
// The 'data' is a raw integer value of the form #rrggbb.
let TYPE_INT_COLOR_RGB8 = 0x1d
// The 'data' is a raw integer value of the form #argb.
let TYPE_INT_COLOR_ARGB4 = 0x1e
// The 'data' is a raw integer value of the form #rgb.
let TYPE_INT_COLOR_RGB4 = 0x1f
// ...end of integer flavors.
let TYPE_LAST_COLOR_INT = 0x1f
// ...end of integer flavors.
let TYPE_LAST_INT = 0x1f


// Internally used state variables for AXMLParser
let START_DOCUMENT = 0
let END_DOCUMENT = 1
let START_TAG = 2
let END_TAG = 3
let TEXT = 4

// Position of the fields inside an attribute
let ATTRIBUTE_IX_NAMESPACE_URI = 0
let ATTRIBUTE_IX_NAME = 1
let ATTRIBUTE_IX_VALUE_STRING = 2
let ATTRIBUTE_IX_VALUE_TYPE = 3
let ATTRIBUTE_IX_VALUE_DATA = 4
let ATTRIBUTE_LENGHT = 5

let RADIX_MULTS:[Float] = [0.00390625, 3.051758E-005, 1.192093E-007, 4.656613E-010]
let DIMENSION_UNITS = ["px", "dip", "sp", "pt", "in", "mm"]
let FRACTION_UNITS = ["%", "%p"]

let COMPLEX_UNIT_MASK:UInt32 = 0x0F

class AXMLParser {
    
    let reader: DataInputStream
    var event = -1
    private var lineNumber = -1
    private var commentIndex = -1
    private var name = -1
    private var namespaceUri = -1
    private var attributeCount = -1
    private var attributes = [Int]()
    private var idAttribute = -1
    private var classAttribute = -1
    private var styleAttribute = -1
    private var filesize = 0
    private var stringBlock: ARSCStringBlock
    private var resourceIDs = [UInt32]()
    private var namespaces = [(Int,Int)]()
    
    init(_ reader:DataInputStream) throws {
        self.reader = reader
        
        guard reader.count >= 8 else {
            throw IOError.format //TODO: move it to another error
        }
        
        guard reader.count < 0xFFFFFFFF else {
            throw IOError.format
        }
        
        let axmlHeader = try ARSCHeader(reader)
        filesize = Int(axmlHeader.size)
        
        guard axmlHeader.header_size != 28024 else {
            throw IOError.format // TODO: error
        }
        
        guard axmlHeader.type == RES_XML_TYPE else {
            throw IOError.format // TODO: erro
        }
        
        // string pool
        
        let header = try ARSCHeader(reader, expected_type: RES_STRING_POOL_TYPE)
        guard header.header_size == 0x1C else {
            throw IOError.format // TODO
        }
        
        stringBlock = try ARSCStringBlock(reader, header: header)
        
    }
    
    func next() throws -> Int {
        try doNext()
        return event
    }
    
    private func doNext() throws {
        if event == END_DOCUMENT {
            return
        }
        
        reset()
        
        while true {
            if reader.hasBytesAvailable == false || reader.position == filesize {
                event = END_DOCUMENT
                break
            }
            
            let h = try ARSCHeader(reader)
            
            if h.type == RES_XML_RESOURCE_MAP_TYPE {
                if h.size < 8 || h.size % 4 != 0 {
                    throw IOError.format
                }
                
                for _ in 0 ..< ((Int(h.size) - Int(h.header_size))/4) {
                    resourceIDs.append(try reader.readU4())
                }
                continue
            }
            
            if h.type < RES_XML_FIRST_CHUNK_TYPE || h.type > RES_XML_LAST_CHUNK_TYPE {
                reader.seek(h.end)
                continue
            }
            
            guard h.header_size == 0x10 else {
                throw IOError.format
            }
            
            lineNumber = Int(try reader.readU4())
            commentIndex = Int(try reader.readU4())
            
            if commentIndex != 0xFFFFFFFF && (h.type == RES_XML_START_NAMESPACE_TYPE || h.type == RES_XML_END_NAMESPACE_TYPE) {
                print("Unhandled Comment at namespace chunk")
            }
            
            if h.type == RES_XML_START_NAMESPACE_TYPE {
                let preview = try reader.readU4()
                let uri = try reader.readU4()
                namespaces.append((Int(preview), Int(uri)))
                
                continue
            }
            
            if h.type == RES_XML_END_NAMESPACE_TYPE {
                let preview = try reader.readU4()
                let uri = try reader.readU4()
                
                namespaces.removeAll { value -> Bool in
                    value.0 == preview && value.1 == uri
                }
                continue
            }
            
            if h.type == RES_XML_START_ELEMENT_TYPE {
                namespaceUri = Int(try reader.readU4())
                name = Int(try reader.readU4())
                _ = try reader.readU4()
                attributeCount = Int(try reader.readU4())
                classAttribute = Int(try reader.readU4())
                idAttribute = (attributeCount >> 16) - 1
                attributeCount = attributeCount & 0xFFFF
                styleAttribute = classAttribute >> 16 - 1
                classAttribute = classAttribute & 0xFFFF - 1
                
                for _ in 0 ..< attributeCount * ATTRIBUTE_LENGHT {
                    attributes.append(Int(try reader.readU4()))
                }
                
                event = START_TAG
                break
            }
            
            if h.type == RES_XML_END_ELEMENT_TYPE {
                namespaceUri = Int(try reader.readU4())
                name = Int(try reader.readU4())
                
                event = END_TAG
                break
            }
            
            if h.type == RES_XML_CDATA_TYPE {
                name = Int(try reader.readU4())
//                let size = try reader.readU2()
//                let res0 = try reader.readU()
//                let dataType = try reader.readU()
//                let data = try reader.readU4()
                _ = try reader.readU2()
                _ = try reader.readU()
                _ = try reader.readU()
                _ = try reader.readU4()
                
                event = TEXT
                break
            }
            
            reader.seek(h.end)
        }
    }
    
    /// Return the assosciated tag name
    var tagName: String {
        return stringBlock.getString(index: name)
    }
    
    func getNamespaces() -> [String: String] {
        var result = [String:String]()
        for namespace in namespaces {
            let preview = stringBlock.getString(index: namespace.0)
            let uri = stringBlock.getString(index: namespace.1)
            
            result[uri] = preview
        }
        
        return result
    }
    
    func getAttributeCount() -> Int {
        return attributeCount
    }
    
    func getAttributeUri(index: Int) throws -> Int {
        let offset = try getAttributeOffset(index: index)
        let uri = attributes[offset + ATTRIBUTE_IX_NAMESPACE_URI]
        return uri
    }
    
    func getAttributeNamespace(index: Int) throws -> String {
        let uri = try getAttributeUri(index: index)
        if uri == 0xFFFFFFFF {
            return ""
        }
        return stringBlock.getString(index: uri)
    }
    
    func getAttributeName(index: Int) throws -> String {
        let offset = try getAttributeOffset(index: index)
        let name = attributes[offset + ATTRIBUTE_IX_NAME]
        
        var res = stringBlock.getString(index: name)
        if res == "" {
            let attr = resourceIDs[name]
            if let item = AndroidResources.shared.resources[Int(attr)] {
                res = "android:" + item.name
            } else {
                res = "android:UNKNOWN_SYSTEM_ATTRIBUTE_\(attr)"
            }
        }
        
        return res
    }
    
    private func getAttributeOffset(index:Int) throws -> Int {
        let offset = index * ATTRIBUTE_LENGHT
        guard offset < attributes.count else {
            throw IOError.format
        }
        return offset
    }
    
    func getAttributeValueType(index: Int) throws -> Int {
        let offset = try getAttributeOffset(index: index)
        return attributes[offset + ATTRIBUTE_IX_VALUE_TYPE] >> 24
    }
    
    func getAttributeValueData(index: Int) throws -> Int {
        let offset = try getAttributeOffset(index: index)
        return attributes[offset + ATTRIBUTE_IX_VALUE_DATA]
    }
    
    func getAttributeValue(index: Int) throws -> String {
        let offset = try getAttributeOffset(index: index)
        let valueType = try getAttributeValueType(index: index)
        let valueData = try getAttributeValueData(index: index)
        switch valueType {
        case TYPE_STRING:
            let valueString = attributes[offset + ATTRIBUTE_IX_VALUE_STRING]
            return "\"\(stringBlock.getString(index: valueString).escaping())\""
        case TYPE_ATTRIBUTE:
            return "\"@attr/0x\(String(valueData, radix: 16))\""
        case TYPE_INT_BOOLEAN:
            return valueType == 1 ? "true" : "false"
        case TYPE_INT_DEC:
            return "\"\(valueData)\""
        case TYPE_FLOAT:
            return "\"\(Float(Int32(bitPattern:UInt32(valueData))))\""
        case TYPE_INT_HEX:
            return "\"0x\(String(valueData, radix:16))\""
        case TYPE_REFERENCE:
            return "\"@ref/0x\(String(valueData, radix: 16))\""
        case TYPE_FRACTION:
            return "\"\(complexToFloat(value: valueData) * 100)\""
        case TYPE_DIMENSION:
            return "\"\(complexToFloat(value: valueData))\(DIMENSION_UNITS[Int(UInt32(valueData) & COMPLEX_UNIT_MASK)])\""
        default:
            fatalError()
        }
    }
    
    func complexToFloat(value:Int) -> Float{
        return Float(Int32(bitPattern: UInt32(value) & 0xFFFFFF00)) * RADIX_MULTS[Int((UInt32(value) >> 4) & 3)]
    }
    
    private func reset() {
        event = -1
        commentIndex = -1
        lineNumber = -1
        name = -1
        namespaceUri = -1
        attributes = []
        idAttribute = -1
        classAttribute = -1
        styleAttribute = -1
        attributeCount = -1
    }
}
