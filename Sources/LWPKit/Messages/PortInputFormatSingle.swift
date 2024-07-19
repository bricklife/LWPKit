/// Port Input Format (Single)
///
/// [3.23. Port Input Format (Single)](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#port-input-format-single)
public struct PortInputFormatSingle: Message {
    public static let messageType = MessageType.portInputFormatSingle

    public let portID: Port.RawValue
    public let mode: UInt8
    public let deltaInterval: UInt32
    public let notificationEnabled: Bool

    public init(portID: Port.RawValue, mode: UInt8, deltaInterval: UInt32, notificationEnabled: Bool) {
        self.portID = portID
        self.mode = mode
        self.deltaInterval = deltaInterval
        self.notificationEnabled = notificationEnabled
    }
}

extension PortInputFormatSingle: DecodableMessage {
    public init(payload: some ByteCollection) throws {
        let view = payload.view

        self.portID = try view.uint8(0)
        self.mode = try view.uint8(1)
        self.deltaInterval = try view.uint32(2)
        self.notificationEnabled = try view.bool(6)
    }
}
