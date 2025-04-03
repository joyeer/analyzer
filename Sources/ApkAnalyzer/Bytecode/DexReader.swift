//
//  DexReader.swift
//  ApkAnalyzer
//
//  Created by Qing Xu on 9/2/19.
//
import Foundation
import Common

public class DexReader {
    
    public var input: DataInputStream? = nil
    
    public init() {
    }
    
    /// read an DexFile from a Data memory
    public func open(_ data:Data) -> DexFile? {
        input = DataInputStream(data, litteEndian: true)
        let dexFile = DexFile(input!)
        return dexFile
    }
}
