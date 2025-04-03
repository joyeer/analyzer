//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/18.
//

import Common

// constants in frameworks/base/libs/androidfw/include/androidfw/ResourceTypes.h
let RES_NULL_TYPE:UInt16                        = 0x0000
let RES_STRING_POOL_TYPE:UInt16                 = 0x0001
let RES_TABLE_TYPE:UInt16                       = 0x0002
let RES_XML_TYPE:UInt16                         = 0x0003
// Chunk types in RES_XML_TYPE
let RES_XML_FIRST_CHUNK_TYPE:UInt16             = 0x0100
let RES_XML_START_NAMESPACE_TYPE:UInt16         = 0x0100
let RES_XML_END_NAMESPACE_TYPE:UInt16           = 0x0101
let RES_XML_START_ELEMENT_TYPE:UInt16           = 0x0102
let RES_XML_END_ELEMENT_TYPE:UInt16             = 0x0103
let RES_XML_CDATA_TYPE:UInt16                   = 0x0104
let RES_XML_LAST_CHUNK_TYPE:UInt16              = 0x017f
// This contains a uint32_t array mapping strings in the string
// pool back to resource identifiers. It is optional.
let RES_XML_RESOURCE_MAP_TYPE:UInt16            = 0x0180
// Chunk types in RES_TABLE_TYPE
let RES_TABLE_PACKAGE_TYPE:UInt16               = 0x0200
let RES_TABLE_TYPE_TYPE:UInt16                  = 0x0201
let RES_TABLE_TYPE_SPEC_TYPE:UInt16             = 0x0202
let RES_TABLE_LIBRARY_TYPE:UInt16               = 0x0203

struct ARSCHeader {
    
    static let SIZE = 8
    
    let start: Int
    let type: UInt16
    let header_size: UInt16
    let size: UInt32
    
    init(_ reader:DataInputStream, expected_type:UInt16? = nil) throws {
        start = reader.position
        type = try reader.readU2()
        if let expected_type = expected_type {
            guard expected_type == type else {
                throw IOError.format
            }
        }
        header_size = try reader.readU2()
        size = try reader.readU4()
        
        
    }
    
    var end: Int {
        return start + Int(size)
    }
}
