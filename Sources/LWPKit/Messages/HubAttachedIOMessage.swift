/// Hub Attached I/O Message
///
/// [3.8. Hub Attached I/O](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#hub-attached-i-o)
public struct HubAttachedIOMessage: Message {
    public static let messageType = MessageType.hubAttachedIO

    public let portID: UInt8
    public let event: Event

    public init(portID: UInt8, event: Event) {
        self.portID = portID
        self.event = event
    }
}

extension HubAttachedIOMessage {
    public enum IOEvent: UInt8, Sendable {
        case detachedIO         = 0x00
        case attachedIO         = 0x01
        case attachedVirtualIO  = 0x02
    }
}

extension HubAttachedIOMessage {
    public enum Event: Sendable {
        case detachedIO
        case attachedIO(ioTypeID: UInt16, hardwareRevision: VersionNumber, softwareRevision: VersionNumber)
        case attachedVirtualIO(ioTypeID: UInt16, firstPortID: UInt8, secondPortID: UInt8)

        public init(eventID: IOEvent, payload: some ByteCollection) throws {
            let view = payload.view

            switch eventID {
            case .detachedIO:
                self = .detachedIO

            case .attachedIO:
                let ioTypeID = try view.uint16(0)
                let hardwareRevision = try VersionNumber(view.suffix(2))
                let softwareRevision = try VersionNumber(view.suffix(6))
                self = .attachedIO(ioTypeID: ioTypeID, hardwareRevision: hardwareRevision, softwareRevision: softwareRevision)

            case .attachedVirtualIO:
                let ioTypeID = try view.uint16(0)
                let firstPortID = try view.uint8(2)
                let secondPortID = try view.uint8(3)
                self = .attachedVirtualIO(ioTypeID: ioTypeID, firstPortID: firstPortID, secondPortID: secondPortID)
            }
        }
    }
}

extension HubAttachedIOMessage: DecodableMessage {
    public init(payload: some ByteCollection) throws {
        let view = payload.view

        self.portID = try view.uint8(0)
        self.event = try Event(eventID: view.rawRepresentable(1), payload: view.suffix(2))
    }
}

extension HubAttachedIOMessage.IOEvent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .detachedIO:
            return "Detached I/O"
        case .attachedIO:
            return "Attached I/O"
        case .attachedVirtualIO:
            return "Attached Virtual I/O"
        }
    }
}
