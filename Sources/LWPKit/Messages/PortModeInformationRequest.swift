/// Port Mode Information Request
///
/// [3.16. Port Mode Information Request](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#port-mode-information-request)
public struct PortModeInformationRequest: Message {
    public static let messageType = MessageType.portModeInformationRequest

    public let portID: Port.RawValue
    public let mode: UInt8
    public let modeInformationType: ModeInformation.InformationType

    public init(portID: Port.RawValue, mode: UInt8, modeInformationType: ModeInformation.InformationType) {
        self.portID = portID
        self.mode = mode
        self.modeInformationType = modeInformationType
    }
}

extension PortModeInformationRequest: EncodableMessage {
    public func payload() throws -> [UInt8] {
        return [portID, mode, modeInformationType.rawValue]
    }
}
