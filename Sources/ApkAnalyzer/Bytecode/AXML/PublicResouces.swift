//
//  File.swift
//  
//
//  Created by Joyeer on 2019/12/20.
//

import Foundation

struct ResourceItem {
    let type: String
    let name: String
    let id: Int
}

class AndroidResources : NSObject {
    
    nonisolated(unsafe) static var shared = AndroidResources()
    
    private(set) var resources = [Int: ResourceItem]()
    
    private override init() {
        super.init()
        if let path = Bundle.main.path(forResource: "public", ofType: "xml") {
            initResouces(path: path)
        }
    }
    
    func initResouces(path: String) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        } catch  {
            
        }
    }
}

extension AndroidResources : XMLParserDelegate {
     
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "public" {
            
            if let _id = attributeDict["id"], let id = Int(_id.dropFirst(2), radix: 16), let type = attributeDict["type"], let name = attributeDict["name"] {
                let item = ResourceItem(type: type, name: name, id: id)
                resources[id] = item
            }
        }
    }
}
