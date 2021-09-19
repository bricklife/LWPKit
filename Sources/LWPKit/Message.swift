import Foundation

// https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#common-message-header

public struct Message {
    
    public let length: Int
    public let hubID: UInt8 = 0x00
    public let messageType: MessageType
    
    public let body: Data
    
    public init?(data: Data) {
        guard data.count >= 3 else { return nil }
        
        let isLongMessage = data[0] & 0x80 > 0
        let length = Int(data[0] & 0x7f) + (isLongMessage ? Int(data[1]) << 7 : 0)
        let bodyIndex = isLongMessage ? 4 : 3
        
        let data = data.prefix(length)
        guard data.count == length, data.count >= bodyIndex else { return nil }
        guard let messageType = MessageType(rawValue: data[bodyIndex - 1]) else { return nil }
        
        self.length = length
        self.messageType = messageType
        self.body = data.suffix(from: bodyIndex)
    }
}
