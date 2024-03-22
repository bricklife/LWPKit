/**
 StartSpeedForDegrees(Degrees, Speed, MaxPower, EndState, UseProfile)
 
 [3.27.9. Output Sub Command - StartSpeedForDegrees(Degrees, Speed, MaxPower, EndState, UseProfile)](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#output-sub-command-startspeedfordegrees-degrees-speed-maxpower-endstate-useprofile-0x0b)
 */
public struct StartSpeedForDegrees: PortOutputCommand {
    
    public let subCommand: UInt8 = 0x0b
    
    public let portID: UInt8
    public let startupAndCompletionInformation: UInt8
    
    public let degrees: Int32
    public let speed: Int8
    public let maxPower: Int8
    public let endState: Int8 // TODO: Use struct??
    public let useProfile: Int8 // TODO: Use struct??
    
    public init(portID: UInt8, startupAndCompletionInformation: UInt8 = 0x11, degrees: Int32, speed: Int8, maxPower: Int8 = 100, endState: Int8 = 0x7F, useProfile: Int8 = 0x03) {
        self.portID = portID
        self.startupAndCompletionInformation = startupAndCompletionInformation
        
        self.degrees = degrees
        self.speed = speed
        self.maxPower = maxPower
        self.endState = endState
        self.useProfile = useProfile
    }
    
    public func portOutputCommandPayload() throws -> [UInt8] {
        let timeArray = withUnsafeBytes(of: degrees.littleEndian) { [UInt8]($0) }
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
