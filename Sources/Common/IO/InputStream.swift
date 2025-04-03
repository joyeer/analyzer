//
//  InputStream.swift
//  
//
//  Created by joyeer on 2023/4/15.
//

import Foundation

class ByteInputStream : InputStream {
    var bytes:UnsafePointer<UInt8>? = nil
    let data:Data
    var curIndex: Int = 0
    var totalCount: Int = 0
    
    override init(data: Data) {
        self.data = data
        super.init(data: data)
    }
    
    override func open() {
        // try to get the unsafe bytes pointee
        curIndex = 0
        totalCount = data.count
    }
    
    override func close() {
        curIndex = -1
        self.bytes = nil
    }
    
    override var hasBytesAvailable: Bool {
        return curIndex < totalCount
    }
    
    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        
        let bytesToRead = curIndex + len < totalCount ? len : totalCount - curIndex
        for index in 0 ..< bytesToRead {
            buffer[index] = byte(at:curIndex + index)
        }
        curIndex += bytesToRead
        
        return bytesToRead
    }
    
    func byte(at position:Int) -> UInt8 {

        let result = data.withUnsafeBytes { rawBytes -> UInt8 in
            guard let rawBytes = rawBytes.bindMemory(to: UInt8.self).baseAddress else {
                return UInt8(0)
            }
            return rawBytes[position]
        }
        return result
    }
    
    // reset the current read position by the given pointer
    func reset(_ pointer:Int) {
        curIndex = pointer
        
        if curIndex < 0 {
            curIndex = 0
        }
        
        if curIndex > totalCount {
            curIndex = totalCount
        }
    }
    
    func previous() {
        reset(curIndex - 1)
    }
}
