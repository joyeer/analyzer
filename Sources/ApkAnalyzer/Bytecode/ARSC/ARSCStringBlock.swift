//
//  ARSCStringBlock.swift
//  
//
//  Created by Joyeer on 2019/12/19.
//

import Common


// Flags in the STRING Section
let SORTED_FLAG = 1 << 0
let UTF8_FLAG = 1 << 8

struct ARSCStringBlock {
    let stringCount: UInt32
    let styleCount: UInt32
    let flags: UInt32
    let stringsStart: UInt32
    let stylesStart: UInt32
    
    let stringOffsets: [UInt32]
    let styleOffsets: [UInt32]
    let stringbuf: [UInt8]
    let styles: [UInt32]
    
    private var isUtf8: Bool {
        return (Int(flags) & UTF8_FLAG) != 0
    }
    
    init(_ reader:DataInputStream, header:ARSCHeader) throws {
        let stringCount = try reader.readU4()
        let styleCount = try reader.readU4()
        flags = try reader.readU4()
        stringsStart = try reader.readU4()
        stylesStart = try reader.readU4()
        
        var stringOffsets = [UInt32]()
        var styleOffsets = [UInt32]()
        for _ in 0 ..< stringCount {
            stringOffsets.append(try reader.readU4())
        }
        
        for _ in 0 ..< styleCount {
            styleOffsets.append(try reader.readU4())
        }
        self.stringOffsets = stringOffsets
        self.styleOffsets = styleOffsets
        
        var size = header.size - stringsStart
        if stylesStart != 0 && styleCount != 0 {
            size = stylesStart - stringsStart
        }
        
        if size % 4 != 0 {
            throw IOError.format
        }
        
        stringbuf = try reader.readBytes(Int(size))
        var styles = [UInt32]()
        if stylesStart != 0 && styleCount != 0 {
            size = header.size - stylesStart
            styles.append(try reader.readU4())
        }
        
        self.stringCount = stringCount
        self.styleCount = styleCount
        self.styles = styles
    }
    
    func getString(index:Int) -> String {
        
        if index < 0 || index > stringCount {
            return ""
        }
        
        var offset = Int(stringOffsets[index])
        var length = 0
        
        if isUtf8 {
            let info = getUtf8(array: stringbuf, arrayOffset: Int(offset))
            offset = info.0
            length = info.1
        } else {
            let info = getUtf16(array: stringbuf, offset: Int(offset))
            offset += info.0
            length = info.1
        }
        return decocdeString(offset: offset, length: length)
    }
    
    private func decocdeString(offset:Int, length:Int) -> String {
        return String(bytes: stringbuf[offset ..< (offset + length)], encoding: isUtf8 ? .utf8 : .utf16LittleEndian)!
    }
    
    private func getUtf16(array:[UInt8], offset:Int) -> (Int,Int) {
    
        let val = Int((array[offset + 1] & 0xFF) << 8 | array[offset] & 0xFF)
        if ((val & 0x8000) != 0) {
            let high = Int((array[offset + 3] & 0xFF) << 8)
            let low = Int((array[offset + 2] & 0xFF))
            let len_value =  Int(((val & 0x7FFF) << 16)) + (high + low)
            return (4, Int(len_value * 2))
        }
        return (2, Int(val * 2))
    }

    
    private func getUtf8(array:[UInt8], arrayOffset:Int) -> (Int, Int) {
        
        var offset = arrayOffset
        var val = array[offset]
        var length = 0
        // We skip the utf16 length of the string
        if ((val & 0x80) != 0) {
            offset += 2
        } else {
            offset += 1;
        }
        // And we read only the utf-8 encoded length of the string
        val = array[offset]
        offset += 1;
        if ((val & 0x80) != 0) {
            let low = array[offset] & 0xFF
            length = Int(((val & 0x7F) << 8) + low)
            offset += 1;
        } else {
            length = Int(val)
        }
        return (offset, length)
    }

}
