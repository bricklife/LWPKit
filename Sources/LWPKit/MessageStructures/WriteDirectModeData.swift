/**
 WriteDirectModeData
 
 [3.29. WriteDirectModeData](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#wr-dmd)
 */
public protocol WriteDirectModeData: PortOutputCommand {
    
    var mode: UInt8 { get }
    
    func writeDirectModeDataPayload() throws -> [UInt8]
}

extension WriteDirectModeData {
    
    public var subCommand: UInt8 {
        return 0x51
    }
    
    public func portOutputCommandPayload() throws -> [UInt8] {
        return try [mode] + writeDirectModeDataPayload()
    }
}
