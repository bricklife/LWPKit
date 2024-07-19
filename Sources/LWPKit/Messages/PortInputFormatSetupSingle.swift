/// Port Input Format Setup (Single)
///
/// [3.17. Port Input Format Setup (Single)](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#port-input-format-setup-single)
public struct PortInputFormatSetupSingle: Message {
    public static let messageType = MessageType.portInputFormatSetupSingle

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

extension PortInputFormatSetupSingle: EncodableMessage {
    public func payload() throws -> [UInt8] {
        let deltaIntervalArray = withUnsafeBytes(of: deltaInterval.littleEndian) { [UInt8]($0) }
        return [portID, mode] + deltaIntervalArray + [notificationEnabled ? 0x01 : 0x00]
    }
}
