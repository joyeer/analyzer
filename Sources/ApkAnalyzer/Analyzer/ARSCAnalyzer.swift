//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/19.
//

import Common
import Foundation

class ARSCAnalyzer {
    
    let reader: DataInputStream
    
    init(_ data:Data) {
        reader = DataInputStream(data, litteEndian: true)
    }
    
    func analyze() throws {
        _ = try ARSCResource(reader)
        
    }
}
