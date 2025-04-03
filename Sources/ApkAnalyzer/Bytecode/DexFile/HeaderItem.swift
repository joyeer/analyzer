import Common

private let DEX_FILE_MAGIC: [UInt8] = [ 0x64, 0x65, 0x78, 0x0a, 0x30, 0x33, 0x38, 0x00 ]


///
struct HeaderItem {
    
    let magic: [UInt8]
    let checksum: UInt32
    let signature: [UInt8]
    let file_size: UInt32
    let header_size: UInt32
    let endian_tag: UInt32
    let link_size: UInt32
    let link_off: UInt32
    let map_off: UInt32
    let string_ids_size: UInt32
    let string_ids_off: UInt32
    let type_ids_size: UInt32
    let type_ids_off: UInt32
    let proto_ids_size: UInt32
    let proto_ids_off: UInt32
    let field_ids_size: UInt32
    let field_ids_off: UInt32
    let method_ids_size: UInt32
    let method_ids_off: UInt32
    let class_defs_size: UInt32
    let class_defs_off: UInt32
    let data_size: UInt32
    let data_off: UInt32
    
    init?(_ input:DataInputStream) {
        do {
            self.magic = try input.readBytes(8)
            self.checksum = try input.readU4()
            self.signature = try input.readBytes(20)
            self.file_size = try input.readU4()
            self.header_size = try input.readU4()
            self.endian_tag = try input.readU4()
            self.link_size = try input.readU4()
            self.link_off = try input.readU4()
            self.map_off = try input.readU4()
            self.string_ids_size = try input.readU4()
            self.string_ids_off = try input.readU4()
            self.type_ids_size = try input.readU4()
            self.type_ids_off = try input.readU4()
            self.proto_ids_size = try input.readU4()
            self.proto_ids_off = try input.readU4()
            self.field_ids_size = try input.readU4()
            self.field_ids_off = try input.readU4()
            self.method_ids_size = try input.readU4()
            self.method_ids_off = try input.readU4()
            self.class_defs_size = try input.readU4()
            self.class_defs_off = try input.readU4()
            self.data_size = try input.readU4()
            self.data_off = try input.readU4()
            
            try verifyMagic()
        } catch _ {
            // some error occurred
            return nil
        }
    }
    
    /// verify the magic header
    private func verifyMagic() throws {
        if self.magic[0] == DEX_FILE_MAGIC[0] &&
            self.magic[1] == DEX_FILE_MAGIC[1] &&
            self.magic[2] == DEX_FILE_MAGIC[2] &&
            self.magic[3] == DEX_FILE_MAGIC[3] &&
            self.magic[4] == DEX_FILE_MAGIC[4] &&
            self.magic[5] == DEX_FILE_MAGIC[5] &&
            self.magic[7] == DEX_FILE_MAGIC[7] {
            return
            
        }
        throw IOError.format
    }
}
