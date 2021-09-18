import Foundation

// https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#common-message-header

public struct Message {
    
    public let length: Int
    public let hubID: UInt8 = 0x00
    public let messageType: MessageType
    
    public let body: Data
    
    public init?(data: Data) {
        guard let firstByte = data.first else { return nil }
        let isLongMessage = firstByte > 0x7f
        let bodyIndex = isLongMessage ? 4 : 3
        guard data.count >= bodyIndex else { return nil }
        
        if isLongMessage {
            self.length = Int(firstByte & 0x7f) + (Int(data[1]) << 7)
        } else {
            self.length = Int(firstByte)
        }
        
        guard let messageType = MessageType(rawValue: data[bodyIndex - 1]) else { return nil }
        
        self.messageType = messageType
        self.body = data.suffix(from: bodyIndex)
    }
}
