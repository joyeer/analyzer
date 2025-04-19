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
        block.opcodeOffsetStart = startIndex
        block.opcodeOffsetEnd = endIndex
        
        blockMap[startIndex] = block
        list.append(block)
        return block
    }
    
    func queryBlock(startOffset: Int) -> BasicBlock {
        return blockMap[startOffset]!
    }
    
}

