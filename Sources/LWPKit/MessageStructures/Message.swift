/**
 LEGO Wireless Protocol Message
 
 [3. LEGO Specific GATT Service](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#lego-specific-gatt-service)
 */
public protocol Message: Sendable {
    
    static var messageType: MessageType { get }
}

public protocol EncodableMessage: Message, ByteCollectionEncodable {
    
    func bytes() throws -> [UInt8]
    func payload() throws -> [UInt8]
}

extension EncodableMessage {
    
    public func bytes() throws -> [UInt8] {
        let payload = try payload()
        let payloadLength = payload.count
        let headerLength = payloadLength > 0x7f - 3 ? 4 : 3
        
        let length = headerLength + payloadLength
        let messageType = Self.messageType
        let header = CommonMessageHeader(length: length, hubID: 0, messageType: messageType)
        
        return try header.bytes() + payload
    }
}

public protocol DecodableMessage: Message, ByteCollectionDecodable {
    
    init(_ bytes: some ByteCollection) throws
    init(header: CommonMessageHeader, payload: some ByteCollection) throws
    init(payload: some ByteCollection) throws
}

extension DecodableMessage {
    
    public init(_ bytes: some ByteCollection) throws {
        let header = try CommonMessageHeader(bytes)
        let payload = try bytes.view.suffix(header.length)
        try self.init(header: header, payload: payload)
    }
    
    public init(header: CommonMessageHeader, payload: some ByteCollection) throws {
        guard header.messageType == Self.messageType else {
            throw DecodableMessageError.unmatch(messageType: header.messageType, type: Self.self)
        }
        guard header.messageLength - header.length <= payload.count else {
            throw DecodableMessageError.invalidPayload(length: payload.count)
        }
        
        try self.init(payload: payload)
    }
}

public enum DecodableMessageError: Error {
    case unmatch(messageType: MessageType, type: DecodableMessage.Type)
    case invalidPayload(length: Int)
}
