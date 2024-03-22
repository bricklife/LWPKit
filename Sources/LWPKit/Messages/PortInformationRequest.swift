/**
 Port Information Request
 
 [3.15. Port Information Request](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#port-information-request)
 */
public struct PortInformationRequest: Message {
    
    public static var messageType = MessageType.portInformationRequest
    
    public let portID: UInt8
    public let informationType: InformationType
    
    public init(portID: UInt8, informationType: InformationType) {
        self.portID = portID
        self.informationType = informationType
    }
}

extension PortInformationRequest {
    
    public enum InformationType: UInt8, CaseIterable, Sendable {
        case portValue                  = 0x00
        case modeInfo                   = 0x01
        case possibleModeCombinations   = 0x02
    }
}

extension PortInformationRequest: EncodableMessage {
    
    public func payload() throws -> [UInt8] {
        return [portID, informationType.rawValue]
    }
}
