//
//  Int+String.swift
//  Analyzer
//
//  Created by joyeer on 2024/12/18.
//

public extension Int {
    func getHexString() -> String {
        if self < 0 {
            return String("-0x\(String(abs(self), radix:16))")
        } else {
            return String("0x\(String(self, radix:16))")
        }
    }
}
