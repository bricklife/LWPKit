/**
 Mode Information
 
 [3.16.2. Mode Information Types](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#mode-information-types)
 */
public enum ModeInformation: Sendable {
    
    public enum InformationType: UInt8, CaseIterable, Sendable {
        case name           = 0x00
        case raw            = 0x01
        case percent        = 0x02
        case si             = 0x03
        case symbol         = 0x04
        case mapping        = 0x05
        case motorBias      = 0x07
        case capabilityBits = 0x08
        case valueFormat    = 0x80
    }
    
    public enum Encoding: Sendable {
        case string
        case range
        case uint8
        case mapping
        case array
        case valueFormat
    }
    
    public enum Value: Sendable {
        case string(String)
        case range(ClosedRange<Float>)
        case uint8(UInt8)
        case mapping(input: Mapping, output: Mapping)
        case array(Array<UInt8>)
        case valueFormat(ValueFormat)
    }
}

extension ModeInformation {
    
    public struct Mapping: OptionSet, Sendable {
        public let rawValue: UInt8
        
        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
        
        public static let supportsNullValue             = Mapping(rawValue: 1 << 7)
        public static let supportsFunctionalMapping2_0  = Mapping(rawValue: 1 << 6)
        public static let absolute                      = Mapping(rawValue: 1 << 4)
        public static let relative                      = Mapping(rawValue: 1 << 3)
        public static let discrete                      = Mapping(rawValue: 1 << 2)
    }
}

extension ModeInformation {
    
    public struct ValueFormat: Sendable {
        public let numberOfDatasets: UInt8
        public let datasetType: DataSet
        public let totalFigures: UInt8
        public let decimalsIfAny: UInt8
        
        public enum DataSet: UInt8, Sendable {
            case bit8   = 0x00
            case bit16  = 0x01
            case bit32  = 0x02
            case float  = 0x03
        }
    }
}

extension ModeInformation.InformationType {
    
    public var encoding: ModeInformation.Encoding {
        switch self {
        case .name:
            return .string
        case .raw:
            return .range
        case .percent:
            return .range
        case .si:
            return .range
        case .symbol:
            return .string
        case .mapping:
            return .mapping
        case .motorBias:
            return .uint8
        case .capabilityBits:
            return .array
        case .valueFormat:
            return .valueFormat
        }
    }
    
    public func value(payload: some ByteCollection) throws -> ModeInformation.Value {
        let view = payload.view
        
        switch encoding  {
        case .string:
            return try .string(view.string(0))
        case .range:
            return try .range(view.float(0) ... view.float(4))
        case .uint8:
            return try .uint8(view.uint8(0))
        case .mapping:
            let input = try ModeInformation.Mapping(rawValue: view.uint8(0))
            let output = try ModeInformation.Mapping(rawValue: view.uint8(1))
            return .mapping(input: input, output: output)
        case .array:
            return .array(Array(payload))
        case .valueFormat:
            let valueFormat = ModeInformation.ValueFormat(numberOfDatasets: try view.uint8(0),
                                                          datasetType: try view.rawRepresentable(1),
                                                          totalFigures: try view.uint8(2),
                                                          decimalsIfAny: try view.uint8(3))
            return .valueFormat(valueFormat)
        }
    }
}

extension ModeInformation.InformationType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .name:
            return "Name"
        case .raw:
            return "RAW Range"
        case .percent:
            return "PCT Range"
        case .si:
            return "SI Range"
        case .symbol:
            return "Symbol"
        case .mapping:
            return "Mapping"
        case .motorBias:
            return "Motor Bias"
        case .capabilityBits:
            return "Capability Bits"
        case .valueFormat:
            return "Value Format"
        }
    }
}

extension ModeInformation.Mapping: CustomStringConvertible {
    
    public var description: String {
        let strings: [String?] = [
            contains(.supportsNullValue) ? "Supports NULL value" : nil,
            contains(.supportsFunctionalMapping2_0) ? "Supports Functional Mapping 2.0+" : nil,
            contains(.absolute) ? "Absolute" : nil,
            contains(.relative) ? "Relative" : nil,
            contains(.discrete) ? "Discrete" : nil,
        ]
        let array = strings.compactMap { $0 }
        return array.isEmpty ? "-" : array.joined(separator: ", ")
    }
}

extension ModeInformation.ValueFormat.DataSet: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .bit8:
            return "8 bit"
        case .bit16:
            return "16 bit"
        case .bit32:
            return "32 bit"
        case .float:
            return "Float"
        }
    }
}

extension ModeInformation.Value: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .string(let string):
            return string
        case .range(let range):
            return range.description
        case .uint8(let uint8):
            return uint8.description
        case .mapping(input: let input, output: let outout):
            return "Input: \(input)\nOutput: \(outout)"
        case .array(let array):
            return array.description
        case .valueFormat(let valueFormat):
            return "\(valueFormat)"
        }
    }
}
