/// Port Mode Information
///
/// [3.20. Port Mode Information](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#port-mode-information)
public struct PortModeInformation: Message {
    public static let messageType = MessageType.portModeInformation

    public let portID: UInt8
    public let mode: UInt8
    public let type: ModeInformation.InformationType
    public let value: ModeInformation.Value

    public init(portID: UInt8, mode: UInt8, type: ModeInformation.InformationType, value: ModeInformation.Value) {
        self.portID = portID
        self.mode = mode
        self.type = type
        self.value = value
    }
}

extension PortModeInformation: DecodableMessage {
    public init(payload: some ByteCollection) throws {
        let view = payload.view

        self.portID = try view.uint8(0)
        self.mode = try view.uint8(1)
        self.type = try view.rawRepresentable(2)
        self.value = try type.value(payload: view.suffix(3))
    }
}
