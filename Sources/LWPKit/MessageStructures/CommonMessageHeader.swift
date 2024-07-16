/// Common Message Header
///
/// [3.1. Common Message Header](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#common-message-header)
public struct CommonMessageHeader: Sendable {
    public let messageLength: Int
    public let hubID: UInt8
    public let messageType: MessageType

    public var length: Int {
        return messageLength > 0x7f ? 4 : 3
    }

    public init(length: Int, hubID: UInt8, messageType: MessageType) {
        self.messageLength = length
        self.hubID = hubID
        self.messageType = messageType
    }
}

extension CommonMessageHeader: ByteCollectionDecodable {
    public init(_ bytes: some ByteCollection) throws {
        let view = bytes.view

        let firstByte = try view.uint8(0)
        let isLongMessage = firstByte > 0x7f

        var length = Int(firstByte & 0x7f)
        if isLongMessage {
            length += Int(try view.uint8(1)) << 7
        }
        let offset = isLongMessage ? 2 : 1

        self.messageLength = length
        self.hubID = try view.uint8(offset)
        self.messageType = try view.rawRepresentable(offset + 1)
    }
}

extension CommonMessageHeader: ByteCollectionEncodable {
    public func bytes() throws -> [UInt8] {
        var bytes = [UInt8]()

        bytes.append(UInt8(messageLength & 0x7f))
        if messageLength > 0x7f {
            bytes.append(UInt8(truncatingIfNeeded: messageLength >> 7))
        }

        bytes.append(hubID)
        bytes.append(messageType.rawValue)

        return bytes
    }
}
