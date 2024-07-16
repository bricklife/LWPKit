/// Port Value (Single)
///
/// [3.21. Port Value (Single)](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#port-value-single)
public struct PortValueSingle: Message {
    public static var messageType = MessageType.portValueSingle

    public let portID: UInt8
    public let inputValue: [UInt8]

    public init(portID: UInt8, inputValue: [UInt8]) {
        self.portID = portID
        self.inputValue = inputValue
    }
}

extension PortValueSingle: DecodableMessage {
    public init(payload: some ByteCollection) throws {
        let view = payload.view

        self.portID = try view.uint8(0)
        self.inputValue = try Array(view.suffix(1))
    }
}
