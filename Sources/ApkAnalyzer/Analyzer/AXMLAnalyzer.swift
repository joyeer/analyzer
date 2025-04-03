//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/19.
//
import Foundation
import Common

public class AXMLAnalyzer {
    
    private let parser:AXMLParser
    private var tabCount = 0
    private var previousLineStartAt:Int = 0
    private var previousLineEndAt:Int = 0
    private var isNamespacePrinted = false
    private var namespaces = [String:String]()
    
    private var output = [String]()

    public init(_ data:Data) throws {
        let reader = DataInputStream(data, litteEndian: true)
        parser = try AXMLParser(reader)
    }
    
    public func analyze () throws -> String {
        xmlHeader()
        newline()
        while try parser.next() != END_DOCUMENT {
            let event = parser.event
            switch event {
            case START_DOCUMENT:
                break
            case START_TAG:
                newline()
                output.append("<")
                output.append(parser.tagName)
                if parser.getAttributeCount() > 0 || isNamespacePrinted == false {
                    newline()
                    incTab()
                    
                    if !isNamespacePrinted {
                        // print the namepsace declarations
                        isNamespacePrinted = true
                        namespaces = parser.getNamespaces()
                        for (index, namespace) in namespaces.enumerated() {
                            let preview = namespace.value
                            let uri = namespace.key
            
                            output.append("xmlns:\(preview)")
                            output.append("=")
                            output.append( "\"\(uri)\"")
                            if index == (namespaces.count - 1) && parser.getAttributeCount() == 0 {
                                break
                            }
                            newline()
                        }
                    }
                    for i in 0 ..< parser.getAttributeCount() {
                        let attributeName = try parser.getAttributeName(index: i)
                        let attributeValue = try parser.getAttributeValue(index: i)
                        let namespaceUri = try parser.getAttributeNamespace(index: i)
                        
                        if namespaceUri.count > 0, let preview = namespaces[namespaceUri] {
                            output.append( "\(preview):\(attributeName)")
                        } else {
                            output.append(attributeName)
                        }
                        
                        output.append("=")
                        output.append(attributeValue)
                        if i < (parser.getAttributeCount() - 1) {
                            newline()
                        }
                    }
                }
                
                output.append(">")
                newline()
                if parser.getAttributeCount() > 0 {
                    decTab()
                }
                
                incTab()
                
            case END_TAG:
                decTab()
                output.append("</")
                output.append(parser.tagName)
                output.append(">")
                newline()
                
            case TEXT:
                break
            default:
                fatalError("unknown event")
            }
        }
        
        return output.joined()
    }
    
    func incTab() {
        
        tabCount += 1
    }
    
    func decTab() {
        tabCount -= 1
    }
    
    func newline() {
        prepareForNewline()
        
        output.append("\n")
    }
    
    func xmlHeader() {
        output.append("<?")
        output.append("xml")
        output.append(" ")
        output.append("version")
        output.append("=")
        output.append("\"1.0\"")
        output.append(" ")
        output.append("encoding")
        output.append("=")
        output.append("\"utf-8\"")
        output.append("?>")
    }
    
    func prepareForNewline() {
        
    }

}
 
