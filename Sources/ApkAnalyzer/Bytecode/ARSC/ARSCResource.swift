//
//  ARSCResource.swift
//
//
//  Created by Joyeer on 2019/12/19.
//

import Common

struct ARSCResource {
    
    let header: ARSCHeader
    let stringPool: ARSCStringBlock?
    
    init(_ reader:DataInputStream) throws {
        self.header = try ARSCHeader(reader, expected_type: RES_TABLE_TYPE)
        guard header.header_size == 12 else {
            throw IOError.format
        }
        guard header.size <= reader.count else {
            throw IOError.format
        }
        
        _ = try reader.readU4() // package count
        var stringPool: ARSCStringBlock? = nil
        
        while reader.position <= (header.end - ARSCHeader.SIZE) {
            let res_header = try ARSCHeader(reader)
            
            switch res_header.type {
            case RES_STRING_POOL_TYPE:
                guard stringPool == nil else {
                    throw IOError.format
                }
                stringPool = try ARSCStringBlock(reader, header: res_header)
                
            case RES_TABLE_PACKAGE_TYPE:
                let current_package = try ARSCResTablePackage(reader, header: res_header)
                // Resouce Type symbol header
                reader.seek(current_package.header.start + Int(current_package.typeStrings))
                let type_sp_header = try ARSCHeader(reader, expected_type: RES_STRING_POOL_TYPE)
                // let tableStrings = try ARSCStringBlock(reader, header: type_sp_header)
                _ = try ARSCStringBlock(reader, header: type_sp_header)
                
                // Resource Key Symbol header
                reader.seek(current_package.header.start + Int(current_package.keyStrings))
                let key_sp_header = try ARSCHeader(reader,expected_type: RES_STRING_POOL_TYPE)
//                let keyStrings = try ARSCStringBlock(reader, header: key_sp_header)
                _ = try ARSCStringBlock(reader, header: key_sp_header)
                
                let next_idx = res_header.start + Int(res_header.header_size) + Int(type_sp_header.size) + Int(key_sp_header.size)
                guard next_idx == reader.position else {
                    throw IOError.format
                }
                reader.seek(next_idx)
                
                while reader.position <= res_header.end - ARSCHeader.SIZE {
                    let pkg_chunk_header = try ARSCHeader(reader)
                    if pkg_chunk_header.start + Int(pkg_chunk_header.size) > res_header.size {
                        break
                    }
                    
                    switch pkg_chunk_header.type {
                    case RES_TABLE_TYPE_SPEC_TYPE:
//                        let typespec = try ARSCResTableTypeSpec(reader)
                        _ = try ARSCResTableTypeSpec(reader)
                    case RES_TABLE_TYPE_TYPE:
                        let a_res_type = try ARSCResTableType(reader)
                        
                        var entires = [Int32]()
                        for _ in 0 ..< a_res_type.entryCount {
                            entires.append(try reader.readInt32())
                        }
                        
                        for entry in entires {
                            if entry != -1 {
                                let ate = try ARSCResTableEntry(reader)
                                if ate.is_weak {
                                    reader.seek(ate.start)
                                }
                            }
                        }
                    case RES_TABLE_LIBRARY_TYPE:
                        break
                    default:
                        print("Unknown chunk type encountered: \(pkg_chunk_header)")
                    }
                    
                    reader.seek(pkg_chunk_header.end)
                }
            default:
                print(res_header.type)
            }
            
            reader.seek(res_header.end)
        }
        
        self.stringPool = stringPool
    }
}

