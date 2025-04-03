//
//  ClassFileReader.swift
//  Decompilr
//
//  Created by Qing Xu on 01/12/2016.
//  Copyri ght © 2016 com.decompilr. All rights reserved.
//

import Foundation
import Common

public enum ClassFileReaderError : Error {
    case ioError                // read io error
    case formatError            // class file format error
}

public class ClassFileReader {
    
    // read classfile from a Data object
    func read(_ data:Data) throws -> ClassFile {
        let input = DataInputStream(data)
        return try ClassFile(input)
    }
}

