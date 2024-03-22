/**
 Mac address
 
 No documentation
 */
public struct MacAddress: Sendable {
    
    public let octets: [UInt8]
    
    public init(octets: [UInt8]) {
        self.octets = octets
    }
}

extension MacAddress: ByteCollectionDecodable {
    
    public init(_ bytes: some ByteCollection) throws {
        let view = bytes.view
        
        self.octets = [
            try view.uint8(0),
            try view.uint8(1),
            try view.uint8(2),
            try view.uint8(3),
            try view.uint8(4),
            try view.uint8(5),
        ]
    }
}

extension MacAddress: CustomStringConvertible {
    
    public var description: String {
        return octets.map({ String(format: "%02x", $0)}).joined(separator: ":")
    }
}
