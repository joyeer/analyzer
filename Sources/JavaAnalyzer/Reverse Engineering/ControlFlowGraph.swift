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

class ControlFlowGraphBuilder {
    
    let constant: ConstantPoolReader
    var cfg: ControlFlowGraph
    init(_ constant: ConstantPoolReader) {
        self.constant = constant
        self.cfg = ControlFlowGraph()
    }
    
    func build(_ method:Method) throws {
        if let opcodes = method.code?.opcodes {
            var map = [Int]()
            var lastStatementIndex = -1
            try opcodes.enumerated().forEach { (index, opcode) in
                switch opcode.kind {
                case .store, .const, .load, .load_constant, .new, .getstatic, .getfield, .checkcast, .instanceof:
                    break
                case .push:
                    lastStatementIndex = index
                case .if:
                    if lastStatementIndex != -1 {
                        map.append(lastStatementIndex)
                    }
                    
                    map.append(index)
                    let branchOffset = opcode.offset + opcode.value
                    let branchIndex = method.queryOpcodeIndex(offset: branchOffset)
                    map.append(branchIndex - 1)
                    lastStatementIndex = index
                case .goto:
                    map.append(index)
                    lastStatementIndex = index
                case .return:
                    map.append(index)
                    lastStatementIndex = index
                case .invoke:
                    let methodInfo = try constant.readMethodInfo(opcode.value)
                    if let returnDescriptor = methodInfo.descriptor.returnType?.descriptor , returnDescriptor == "V" {
                        lastStatementIndex = index
                    }
                default:
                    break
                }
            }
            
            // Build basic blocks
            var lastIndex = 0
            map.forEach { index in
                let block = cfg.newBasicBlock(type: .deleted, startIndex: lastIndex, endIndex: index)
                block.startAt = lastIndex
                block.endAt = index
                lastIndex = index + 1
            }
            // Build Blocks
            let reader = BasicBlockReader(blocks: cfg.list, start: 0, end: cfg.list.count)
            
            while reader.hasNext() {
                let block = reader.next()
                let index = reader.pos

                // build the relationship among the Blocks
                let lastOpcodeOfBlock = method.getOpcodeBy(index: block.endAt)


                switch lastOpcodeOfBlock.kind {
                case .if:
                    // the if opcode is espeical, the next following block is it's branch block,
                    // it's next block
                    block.type = .if
                    let branchOffset = lastOpcodeOfBlock.value + lastOpcodeOfBlock.offset
                    let nextBlockIndex = method.queryOpcodeIndex(offset: branchOffset)
                    let nextBlock = cfg.queryBlock(startIndex: nextBlockIndex)
                    block.next = nextBlock
                    
                    let branchIndex = method.queryOpcodeIndex(offset: lastOpcodeOfBlock.offset) + 1
                    let branchBlock = cfg.queryBlock(startIndex: branchIndex )
                    block.branch = branchBlock
                    branchBlock.addPredecessor(block)
                case .goto:
                    block.type = .goto
                    break
                default:
                    block.type = .statement
                    if let nextBlock = cfg.nextBlock(startIndex: index) {
                        if nextBlock.predecessors.count == 0 {
                            block.next = nextBlock
                        }
                    }
                    
                    break
                }
                
            }

//            reader.pos = 0
//            let builder = ControlFlowBuilder(reader: reader)
//            builder.build()
                        

            
        }
    }
}


