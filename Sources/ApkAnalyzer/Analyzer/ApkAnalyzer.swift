//
//  ApkAnalyzer.swift
//  
//
//  Created by Joyeer on 2019/12/21.
//

import Foundation
import Common

//public class ApkAnalyzer : Analyzer {
//    public var reporter: CoreAnalyzer.ProgressReporter?
//    
//
//    public init() {
//    }
//    
//    let reader = ZipReader()
//        
//    public func getDisplayContent(node: FileNode) throws -> (ContentType, Any)  {
//        if let `class` = node.payload as? Class {
//            let creator = DalvikCodeCreator()
//            return (.code, creator.render(`class`))
//        } else if node.path == "AndroidManifest.xml" || (node.path.starts(with: "res/") && node.path.hasSuffix(".xml")) {
//            if let data = node.payload as? Data {
//                let axmlAnalyzer = try AXMLAnalyzer(data)
//                return ( .code, try axmlAnalyzer.analyze())
//            }
//        } else {
//            // try to display as normal text data
//            if let data = node.payload as? Data {
//                if let string = String(data: data, encoding: .utf8) {
//                    return (.code,  NSAttributedString(string:string, attributes: [ NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)]))
//                } else if let image = UIImage(data: data) {
//                    return (.image,  image)
//                } else {
//                    return (.bin, data)
//                }
//            }
//        }
//        
//    
//        return (.code, NSAttributedString())
//
//    }
//    
//    public func decompile(node: FileNode) -> NSAttributedString {
//        return NSAttributedString(string: "")
//    }
//    
//    public func disassemble(node: FileNode) throws -> NSAttributedString {
//        
//        if let klass = node.payload as? Class {
//            let creator = DalvikCodeCreator()
//            return creator.render(klass)
//        } else if node.path == "AndroidManifest.xml" || (node.path.starts(with: "res/") && node.path.hasSuffix(".xml")) {
//            
//            guard let data = try reader.readRawData(path: node.path) else {
//                return NSAttributedString(string: "")
//            }
//
//            let axmlAnalyzer = try AXMLAnalyzer(data)
//            return try axmlAnalyzer.analyze()
//        }
//        return NSAttributedString(string: "")
//    }
//    
//    public func getContentType(node: FileNode) -> [ContentType] {
//        if node.payload is Class {
//            return [.code]
//        } else if node.name.hasSuffix(".xml") {
//            return [.code]
//        } else if node.path.hasSuffix(".png") || node.path.hasSuffix(".jpg") {
//            return [.image]
//        } else {
//            return [.bin, .txt]
//        }
//    }
//    
//    public func getContentText(node: FileNode) throws -> NSAttributedString {
//        guard let data = try reader.readRawData(path: node.path) else {
//            return NSAttributedString(string: "")
//        }
//        
//        guard let text = String(data: data, encoding: .ascii) else {
//            return NSAttributedString(string: "")
//        }
//    
//        return NSAttributedString(string: text)
//    }
//    
//    public func getContentData(node: FileNode) throws -> Data {
//        return try reader.readRawData(path: node.path)!
//    }
//
//    public func analyze(path: String) throws -> FileNode {
//        let url = URL(fileURLWithPath: path)
//        var root = [String:Any]()
//        
//        // Step 1. unzipping
//        try reader.open(url)
//        
//        // Step 2. resources.arsc
//        if let arscFile = try reader.readRawData(path: "resources.arsc") {
//            let analyzer = ARSCAnalyzer(arscFile)
//            try analyzer.analyze()
//        }
//        
//        // Step 3. classes.dex
//        
//        if let dexData = try reader.readRawData(path: "classes.dex") {
//            var classes = [Data]()
//            var names = [String]()
//            classes.append(dexData)
//            names.append("classes.dex")
//            var index = 2
//            while true {
//                guard let dexData = try reader.readRawData(path: "classes\(index).dex") else {
//                    break
//                }
//                classes.append(dexData)
//                names.append("classes\(index).dex")
//                index += 1
//            }
//
//            var curProgress:Float = 0.1
//            let perProgress:Float = 0.9 / Float(classes.count)
//        
//            for (index, data) in classes.enumerated() {
//                if index > 0 {
//                    curProgress += perProgress
//                }
//                let dexReader = DexReader()
//                let dexfile = dexReader.open(data)
//                let analyzer = DexAnalyzer(dex: dexfile!, input: dexReader.input!)
//                
//                try analyzer.analyze( progress: { progress in
//                    // report the dexing progress
//                    let p = CGFloat(curProgress + (perProgress * Float(progress)/100.0))
//                    self.report(progress: "Analyzing classes.dex \(Int(p * 100))%...", percentage:p)
//                })
//                insert(packages: analyzer.packages, root: &root, rootFolderName: names[index])
//            }
//            
//        }
//        
//        // Step 4. prapare the Tree
//        for entry in reader.entries {
//            if (entry.key.hasPrefix("classes") && entry.key.hasSuffix(".dex")) == false && entry.key != "resources.arsc" {
//                var parts = entry.key.split(separator: "/").map { String($0) }
//                insert(parts: &parts, root: &root, data: entry.value, originalPath: entry.key, parentPath: "")
//            }
//        }
//    
//        // insert the dex results into root
//        return normalize(root: root, parentPath: "project://\(url.deletingPathExtension().lastPathComponent)")
//    }
//    
//    private func report(progress: String, percentage: CGFloat) {
//        if let reporter = reporter {
//            reporter(progress, percentage)
//        }
//    }
//    
//    
//    // insert the dex analyze result into tree structure
//    private func insert(packages:[Package], root: inout [String:Any], rootFolderName: String) {
//        var dexRoot = [String: Any]()
//        
//        for package in packages {
//            for `class` in package.classes {
//                if let clsssName = `class`.classType.type {
//                    var parts = clsssName.split(separator: ".").map { String($0) }
//                    insert(parts: &parts, root: &dexRoot, data: `class`, originalPath: "", parentPath: "")
//                }
//            }
//        }
//        
//        root[rootFolderName] = dexRoot
//    }
//
//    
//}
