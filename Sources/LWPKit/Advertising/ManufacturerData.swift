/**
 Manufacturer Data
 
 [2. Advertising](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#document-2-Advertising)
 */
import Foundation

public struct ManufacturerData: Sendable {
    public let buttonState: Bool
    public let hubType: HubType
    
    public init?(data: Data) {
        guard data.count == 8 else { return nil }
        guard data[0] == 0x97, data[1] == 0x03 else { return nil }
        
        self.buttonState = data[2] != 0
        
        guard let hubType = HubType(rawValue: data[3]) else { return nil }
        self.hubType = hubType
    }
}
