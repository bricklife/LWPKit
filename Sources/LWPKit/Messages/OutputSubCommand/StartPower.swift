/// StartPower(Power)
///
/// [3.27.1. Output Sub Command - StartPower(Power)](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#output-sub-command-startpower-power)
public struct StartPower: WriteDirectModeData {
    public let mode: UInt8 = 0x00

    public let portID: Port.RawValue
    public let startupAndCompletionInformation: UInt8
    public let power: Int8

    public init(portID: Port.RawValue, startupAndCompletionInformation: UInt8 = 0x11, power: Int8) {
        self.portID = portID
        self.startupAndCompletionInformation = startupAndCompletionInformation
        self.power = power
    }

    public func writeDirectModeDataPayload() throws -> [UInt8] {
        return [UInt8.init(bitPattern: power)]
    }

    public static func canUse(for ioType: IOType) -> Bool {
        return ioType.isMotor || ioType == .light
    }
}
