//
//  ControlFlowGraph.swift
//  Analyzer
//
//  Created by joyeer on 2025/1/4.
//
class ControlFlowGraph {
    var list = [BasicBlock]()
    private var blockMap = [Int: BasicBlock]()
    
    
    func newBasicBlock(type: BlockType, startIndex: Int, endIndex: Int) -> BasicBlock {
        let block = BasicBlock(type: type)
        block.startAt = startIndex
        block.endAt = endIndex
        
        blockMap[startIndex] = block
        list.append(block)
        return block
    }
    
    
    func nextBlock(startIndex: Int) -> BasicBlock? {
        
        let pos = startIndex + 1
        if list.count <= pos {
            return nil
        }
        return list[pos]
    }
    
    func queryBlock(startIndex: Int) -> BasicBlock {
        return blockMap[startIndex]!
    }
    
}

