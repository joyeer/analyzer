//
//  BasicBlock.swift
//  Analyzer
//
//  Created by joyeer on 2025/1/26.
//



enum BlockType {
    case goto
    case deleted
    case `if`
    case statement
}


class BasicBlock {
    
    init(type: BlockType) {
        self.type = type
    }
    
    var type: BlockType
    
    var startAt: Int = -1
    var endAt: Int = -1
    var next: BasicBlock? = nil
    var branch: BasicBlock? = nil
    var condition: BasicBlock? = nil
    var predecessors = [BasicBlock]()
}


class BasicBlockReader {
    var blocks: [BasicBlock]
    var pos: Int
    var end: Int
    init(blocks: [BasicBlock], start: Int, end: Int) {
        self.blocks = blocks
        self.pos = start - 1
        self.end = end
    }
    
    func hasNext() -> Bool {
        return self.pos + 1 < self.end
    }
    
    func next() -> BasicBlock {
        self.pos = self.pos + 1
        return self.blocks[self.pos]
    }
}
