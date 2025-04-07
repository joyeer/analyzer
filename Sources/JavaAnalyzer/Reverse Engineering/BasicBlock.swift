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
    
    var index: Int = 0
    var startAt: Int = -1
    var endAt: Int = -1
    
    weak var branch: BasicBlock? = nil
    
    private var _predecessors = [Weak<BasicBlock>]()
    var next: BasicBlock? = nil
    
    var predecessors: [BasicBlock] {
        _predecessors.compactMap { $0.value }
    }
    
    func addPredecessor(_ block: BasicBlock) {
        _predecessors.append(Weak(block))
    }
}

class Weak<T: AnyObject> {
    weak var value: T?
    init(_ value: T) {
        self.value = value
    }
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
