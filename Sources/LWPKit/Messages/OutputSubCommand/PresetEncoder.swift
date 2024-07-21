/// PresetEncoder(Position)
///
/// [3.27.13. Output Sub Command - PresetEncoder(Position)](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#output-sub-command-presetencoder-position-n-a)
public struct PresetEncoder: WriteDirectModeData {
    public let mode: UInt8 = 0x02

    public let portID: Port.ID
    public let startupAndCompletionInformation: UInt8
    public let position: Int32

    public init(portID: Port.ID, startupAndCompletionInformation: UInt8 = 0x11, position: Int32) {
        self.portID = portID
        self.startupAndCompletionInformation = startupAndCompletionInformation
        self.position = position
    }

    public func writeDirectModeDataPayload() throws -> [UInt8] {
        return withUnsafeBytes(of: position.littleEndian) { [UInt8]($0) }
    }

    public static func canUse(for ioType: IOType) -> Bool {
        return ioType.hasRotationSensor
    }
}
