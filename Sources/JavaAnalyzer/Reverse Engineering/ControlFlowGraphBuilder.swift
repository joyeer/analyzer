//
//  ControlFlowGraphBuilder.swift
//  Analyzer
//
//  Created by joyeer on 2025/4/8.
//


class ControlFlowGraphBuilder {
    
    let constant: ConstantPoolReader
    var cfg: ControlFlowGraph
    init(_ constant: ConstantPoolReader) {
        self.constant = constant
        self.cfg = ControlFlowGraph()
    }
    
    func build(_ method:Method) throws {
        if let opcodes = method.code?.opcodes {
            
            /// Find leaders
            /// A leader is the first instruction of a basic block.
            /// The first instruction of the method is a leader.
            /// Any instruction that is the target of a branch instruction is a leader.
            /// Any instruction that is the target of a jump instruction is a leader.
            /// Any instruction that is the first instruction after a branch instruction is a leader.
            /// Any instruction that is the first instruction after a jump instruction is a leader.
            /// Any instruction that is the first instruction after a return instruction is a leader.
            var leaders = [Int]()
            var lastStatementIndex = -1
            try opcodes.enumerated().forEach { (index, opcode) in
                switch opcode.kind {
                case .store, .const, .load, .load_constant, .new, .getstatic, .getfield, .checkcast, .instanceof:
                    break
                case .push:
                    lastStatementIndex = index
                case .if:
                    if lastStatementIndex != -1 {
                        leaders.append(lastStatementIndex)
                    }
                    
                    leaders.append(index)
                    let branchOffset = opcode.offset + opcode.value
                    let branchIndex = method.queryOpcodeIndex(offset: branchOffset)
                    leaders.append(branchIndex - 1)
                    lastStatementIndex = index
                case .goto:
                    leaders.append(index)
                    lastStatementIndex = index
                case .return:
                    leaders.append(index)
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
            leaders.forEach { index in
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
                    block.type = .conditional
                    let branchOffset = lastOpcodeOfBlock.value + lastOpcodeOfBlock.offset
                    let branchIndex = method.queryOpcodeIndex(offset: branchOffset)
                    let branchBlock = cfg.queryBlock(startIndex: branchIndex)
                    block.branch = branchBlock
                    
                    let successor = cfg.queryBlock(startIndex: index + 1)
                    block.next = successor
                    
                    branchBlock.addPredecessor(block)
                case .goto:
                    block.type = .goto
                    let successor = cfg.queryBlock(startIndex: index + 1)
                    block.next = successor
                    break
                case .invoke:
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

