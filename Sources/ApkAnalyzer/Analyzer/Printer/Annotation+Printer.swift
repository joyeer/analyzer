//
//  File.swift
//  
//
//  Created by Joyeer on 2020/1/4.
//

import Foundation
import Common


extension Annotation {
    func print(printer: CodePrinter, table: Table) {
        printer.print(keyword: ".annotation")
        
        if let visibility = visibility {
            printer.space()
            switch visibility {
            case .system:
                printer.print(keyword: "system")
            case .runtime:
                printer.print(keyword: "runtime")
            case .build:
                printer.print(keyword: "build")
            }
        }
        
        printer.space()
        printer.print(text: type)
        printer.newLine()
        printer.incTab()
        for (key, value) in elements {
            printer.print(text: key)
            printer.space()
            printer.print(text: "=")
            printer.space()
            value.print(printer: printer, table: table)
            printer.newLine()
        }
        printer.decTab()
        printer.print(keyword: ".end annotation")
        printer.newLine()

    }
}
