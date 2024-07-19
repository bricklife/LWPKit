/// GotoAbsolutePosition(AbsPos, Speed, MaxPower, EndState, UseProfile)
///
/// [3.27.11. Output Sub Command - GotoAbsolutePosition(AbsPos, Speed, MaxPower, EndState, UseProfile)](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#output-sub-command-gotoabsoluteposition-abspos-speed-maxpower-endstate-useprofile-0x0d)
public struct GotoAbsolutePosition: PortOutputCommand {
    public let subCommand: UInt8 = 0x0d

    public let portID: Port.RawValue
    public let startupAndCompletionInformation: UInt8

    public let position: Int32
    public let speed: Int8
    public let maxPower: Int8
    public let endState: Int8  // TODO: Use struct??
    public let useProfile: Int8  // TODO: Use struct??

    public init(portID: Port.RawValue, startupAndCompletionInformation: UInt8 = 0x11, position: Int32, speed: Int8, maxPower: Int8 = 100, endState: Int8 = 0x7F, useProfile: Int8 = 0x03) {
        self.portID = portID
        self.startupAndCompletionInformation = startupAndCompletionInformation

        self.position = position
        self.speed = speed
        self.maxPower = maxPower
        self.endState = endState
        self.useProfile = useProfile
    }

    public func portOutputCommandPayload() throws -> [UInt8] {
        let timeArray = withUnsafeBytes(of: position.littleEndian) { [UInt8]($0) }
        return timeArray + [
            UInt8(bitPattern: speed),
            UInt8(bitPattern: maxPower),
            UInt8(bitPattern: endState),
            UInt8(bitPattern: useProfile),
        ]
    }

    public static func canUse(for ioType: IOType) -> Bool {
        return ioType.hasRotationSensor
    }
}
