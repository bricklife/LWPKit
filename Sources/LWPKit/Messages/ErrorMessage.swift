/// Error Message
///
/// [3.9. Generic Error Messages](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#generic-error-messages)
public struct ErrorMessage: Message {
    public static var messageType = MessageType.genericErrorMessages

    public let commandType: UInt8
    public let errorCode: ErrorCode

    public var messageType: MessageType? {
        return MessageType(rawValue: commandType)
    }

    init(commandType: UInt8, errorCode: ErrorCode) {
        self.commandType = commandType
        self.errorCode = errorCode
    }
}

extension ErrorMessage {
    public enum ErrorCode: UInt8, Sendable {
        case ack                    = 0x01
        case mack                   = 0x02
        case bufferOverflow         = 0x03
        case timeout                = 0x04
        case commandNotRecognized   = 0x05
        case invalidUse             = 0x06
        case overcurrent            = 0x07
        case internalError          = 0x08
    }
}

extension ErrorMessage: DecodableMessage {
    public init(payload: some ByteCollection) throws {
        let view = payload.view

        self.commandType = try view.uint8(0)
        self.errorCode = try view.rawRepresentable(1)
    }
}

extension ErrorMessage.ErrorCode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ack:
            return "ACK"
        case .mack:
            return "MACK"
        case .bufferOverflow:
            return "Buffer Overflow"
        case .timeout:
            return "Timeout"
        case .commandNotRecognized:
            return "Command NOT recognized"
        case .invalidUse:
            return "Invalid use"
        case .overcurrent:
            return "Overcurrent"
        case .internalError:
            return "Internal ERROR"
        }
    }
}
