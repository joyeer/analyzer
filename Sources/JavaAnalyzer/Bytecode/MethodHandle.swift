//
//  File.swift
//  
//
//  Created by Joyeer on 2020/4/26.
//

import Foundation

let REF_getField: UInt8 = 1
let REF_getStatic: UInt8 = 2
let REF_putField: UInt8 = 3
let REF_putStatic: UInt8 = 4
let REF_invokeVirtual: UInt8 = 5
let REF_invokeStatic: UInt8 = 6
let REF_invokeSpecial: UInt8 = 7
let REF_newInvokeSpecial: UInt8 = 8
let REF_invokeInterface: UInt8 = 9

struct MethodHandle {
    let kind: UInt8
    let reference: Any
}

