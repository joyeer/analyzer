//
//  DataInputStream.swift
//  JavaDecompiler
//
//  Created by Qing Xu on 23/01/2018.
//

import Foundation

public class DataInputStream {
    
    internal let input: ByteInputStream
    private let litteEndian: Bool
    
    public init(_ data:Data, litteEndian:Bool = false) {
        self.litteEndian = litteEndian
        input = ByteInputStream(data: data)
        input.open()
    }
    
    deinit {
        input.close()
    }
    
    // MARK: - IO
    public func readU() throws -> UInt8  {
        var buffer = [UInt8](repeating: 0, count: 1)
        if input.read(&buffer, maxLength: 1) == 1 {
            return buffer[0]
        }
        throw IOError.format
    }
    
    public func readInt8() throws -> Int8 {
        return Int8(bitPattern: try readU())
    }
    
    public func readU2() throws -> UInt16 {
        var buffer = [UInt8](repeating:0, count:2)
        
        if input.read(&buffer, maxLength: 2) == 2 {
            if litteEndian {
                return (UInt16(buffer[1]) << 8) | UInt16(buffer[0])
            } else {
                return (UInt16(buffer[0]) << 8) | UInt16(buffer[1])
            }
            
        }
        throw IOError.format
    }
    
    public func readInt16() throws -> Int16 {
        var buffer = [UInt8](repeating:0, count:2)
        
        if input.read(&buffer, maxLength: 2) == 2 {
            if litteEndian {
                return (Int16(Int8(bitPattern: buffer[1])) << 8) | Int16(Int8(bitPattern: buffer[0]))
            } else {
                return (Int16(Int8(bitPattern: buffer[0])) << 8) | Int16(Int8(bitPattern: buffer[1]))
            }
        }
        throw IOError.format
    }
    
    public func readU4() throws -> UInt32 {
        var buffer = [UInt8](repeating:0, count:4)
        if input.read(&buffer, maxLength: 4) == 4 {
            let b1 = UInt32(buffer[0])
            let b2 = UInt32(buffer[1])
            let b3 = UInt32(buffer[2])
            let b4 = UInt32(buffer[3])
            if litteEndian {
                return b4 << 24 | b3 << 16 | b2 << 8 | b1
            } else {
                return b1 << 24 | b2 << 16 | b3 << 8 | b4
            }
        }
        
        throw IOError.format
    }
    
    public func readCString() throws -> String {
        var bytes = [UInt8]()
        while hasBytesAvailable {
            let byte = try readU()
            bytes.append(byte)
            if byte == 0 {
                break
            }
        }
        return String(decoding: bytes, as: UTF8.self)
    }
    
    public func readInt32() throws -> Int32 {
        var buffer = [UInt8](repeating:0, count:4)
        if input.read(&buffer, maxLength: 4) == 4 {
            let b1 = Int32(Int8(bitPattern:buffer[0]))
            let b2 = Int32(Int8(bitPattern:buffer[1]))
            let b3 = Int32(Int8(bitPattern:buffer[2]))
            let b4 = Int32(Int8(bitPattern:buffer[3]))
            if litteEndian {
                return b4 << 24 | b3 << 16 | b2 << 8 | b1
            } else {
                return b1 << 24 | b2 << 16 | b3 << 8 | b4
            }
        }
        throw IOError.format
    }
    
    public func readUInt64() throws -> UInt64 {
        var buffer = [UInt8](repeating:0, count:8)
        if input.read(&buffer, maxLength: 8) == 8 {
            let b1 = UInt64(buffer[0])
            let b2 = UInt64(buffer[1])
            let b3 = UInt64(buffer[2])
            let b4 = UInt64(buffer[3])
            let b5 = UInt64(buffer[4])
            let b6 = UInt64(buffer[5])
            let b7 = UInt64(buffer[6])
            let b8 = UInt64(buffer[7])
            
            if litteEndian {
                return b8 << 56 | b7 << 48 | b6 << 40 | b5 << 32 | b4 << 24 | b3 << 16 | b2 << 8 | b1
            } else {
                return b1 << 56 | b2 << 48 | b3 << 40 | b4 << 32 | b5 << 24 | b6 << 16 | b7 << 8 | b8
            }
        }
        throw IOError.format
    }

    
    public func readInt64() throws -> Int {
        var buffer = [UInt8](repeating:0, count:8)
        if input.read(&buffer, maxLength: 8) == 8 {
            let b1 = Int(Int8(bitPattern:buffer[0]))
            let b2 = Int(Int8(bitPattern:buffer[1]))
            let b3 = Int(Int8(bitPattern:buffer[2]))
            let b4 = Int(Int8(bitPattern:buffer[3]))
            let b5 = Int(Int8(bitPattern:buffer[4]))
            let b6 = Int(Int8(bitPattern:buffer[5]))
            let b7 = Int(Int8(bitPattern:buffer[6]))
            let b8 = Int(Int8(bitPattern:buffer[7]))
            if litteEndian {
                return b8 << 56 | b7 << 48 | b6 << 40 | b5 << 32 | b4 << 24 | b3 << 16 | b2 << 8 | b1
            } else {
                return b1 << 56 | b2 << 48 | b3 << 40 | b4 << 32 | b5 << 24 | b6 << 16 | b7 << 8 | b8
            }
        }
        throw IOError.format
    }
    
    public func readBytes(_ count:Int) throws -> [UInt8] {
        var buffer = [UInt8](repeating:0, count:count)
        guard input.read(&buffer, maxLength: count) == count else {
            throw IOError.format
        }
        
        return buffer
    }
    
    public var hasBytesAvailable: Bool {
        return input.hasBytesAvailable
    }
    
    /// read Uleb128
    public func readUleb128() throws -> UInt {
        var result: Int = 0
        var shift: Int = 0
        var byte: UInt8 = 0
        
        while true {
            byte = try readU()
            result |= ((Int(byte) & 0x7F) << shift)
            shift += 7

            if ((byte & 0x80) >> 7) == 0 {
                break
            }
            
            if (shift >= 64) {
                throw IOError.format
            }
        }

        return UInt(result)
    }
    
    public func readSleb128() throws -> Int {
        var result: Int32 = 0
        var shift: Int = 0
        var byte: UInt8 = 0
        
        while true {
            byte = try readU()
            result |= ((Int32(byte) & 0x7F) << shift)
            shift += 7

            if ((byte & 0x80) >> 7) == 0 {
                break
            }
            
            if (shift >= 64) {
                throw IOError.format
            }
        }
        
        if byte & 0x40 != 0 {
            switch shift / 7 {
            case 1:
                result = result | Int32(bitPattern: 0xffffff80)
            case 2:
                result = result | Int32(bitPattern: 0xffff8000)
            case 3:
                result = result | Int32(bitPattern: 0xff800000)
            case 4:
                result = result | Int32(bitPattern: 0x80000000)
            default:
                throw IOError.format
            }
        }
        return Int(result)
    }
    
    /// read mutf-8 string from string
    public func readMutf8(_ exceptedSize:Int) throws -> String? {
        if exceptedSize == 0 {
            return ""
        }

        var s = 0
        var out = [UInt16](repeating: 0, count:  exceptedSize)
        while (true) {
            let a = (UInt16) (try readU() & 0xff)
            if a == 0 {
                return String(utf16CodeUnits: out, count: exceptedSize)
            }
            out[s] = a
            if a < 0x80 {
                s += 1
            } else if (a & 0xe0) == 0xc0 {
                let b = (UInt16) (try readU() & 0xff)
                if ((b & 0xC0) != 0x80) {
                    throw IOError.format
                }
                
                out[s] =  (UInt16) (((a & 0x1F) << 6) | (b & 0x3F))
                s += 1
            } else if ((a & 0xf0) == 0xe0) {
                let b = UInt16(try readU() & 0xff)
                let c = UInt16(try readU() & 0xff)
                if (((b & 0xC0) != 0x80) || ((c & 0xC0) != 0x80)) {
                    throw IOError.format
                }
                out[s] = ((a & 0x0F) << 12) | ((b & 0x3F) << 6) | (c & 0x3F)
                s += 1
            } else {
                throw IOError.format
            }
        }
    }
    
    
    public func readJavaMutf8(_ exceptedSize:Int) throws -> String? {
        if exceptedSize == 0 {
            return ""
        }

       var s = 0
        var out = [UInt16](repeating: 0, count:  exceptedSize)
        while (hasBytesAvailable) {
            let a = (UInt16) (try readU() & 0xff)
            
            out[s] = a
            if a < 0x80 {
                s += 1
            } else if (a & 0xe0) == 0xc0 {
                let b = (UInt16) (try readU() & 0xff)
                if ((b & 0xC0) != 0x80) {
                    throw IOError.format
                }
                
                out[s] =  (UInt16) (((a & 0x1F) << 6) | (b & 0x3F))
                s += 1
            } else if ((a & 0xf0) == 0xe0) {
                let b = UInt16(try readU() & 0xff)
                let c = UInt16(try readU() & 0xff)
                if (((b & 0xC0) != 0x80) || ((c & 0xC0) != 0x80)) {
                    throw IOError.format
                }
                out[s] = ((a & 0x0F) << 12) | ((b & 0x3F) << 6) | (c & 0x3F)
                s += 1
            } else {
                throw IOError.format
            }
        }
        
        return String(utf16CodeUnits: out, count: s)
    }

    
    public func seek(_ position:Int) {
        input.reset(position)
    }
    
    public func previous() {
        input.previous()
    }
    
    public var position:Int {
        return input.curIndex
    }
    
    public var count:Int {
        return input.totalCount
    }
}
