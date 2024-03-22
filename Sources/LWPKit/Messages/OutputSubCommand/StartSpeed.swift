/**
 StartSpeed (Speed, MaxPower, UseProfile)
 
 [3.27.5. Output Sub Command - StartSpeed (Speed, MaxPower, UseProfile)](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#output-sub-command-startspeed-speed-maxpower-useprofile-0x07)
 */
public struct StartSpeed: PortOutputCommand {
    
    public let subCommand: UInt8 = 0x07
    
    public let portID: UInt8
    public let startupAndCompletionInformation: UInt8
    public let speed: Int8
    public let maxPower: Int8
    public let useProfile: Int8 // TODO: Use struct??
    
    public init(portID: UInt8, startupAndCompletionInformation: UInt8 = 0x11, speed: Int8, maxPower: Int8 = 100, useProfile: Int8 = 0x03) {
        self.portID = portID
        self.startupAndCompletionInformation = startupAndCompletionInformation
        self.speed = speed
        self.maxPower = maxPower
        self.useProfile = useProfile
    }
    
    public func portOutputCommandPayload() throws -> [UInt8] {
        return [UInt8(bitPattern: speed), UInt8(bitPattern: maxPower), UInt8(bitPattern: useProfile)]
    }
    
    public static func canUse(for ioType: IOType) -> Bool {
        return ioType.hasRotationSensor
    }
}
