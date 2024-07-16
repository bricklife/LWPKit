/// Port Information
///
/// [3.19. Port Information](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#port-information)
public struct PortInformation: Message {
    public static var messageType = MessageType.portInformation

    public let portID: UInt8
    public let information: Information

    public init(portID: UInt8, information: Information) {
        self.portID = portID
        self.information = information
    }
}

extension PortInformation {
    public enum InformationTypeID: UInt8 {
        case modeInfo                   = 0x01
        case possibleModeCombinations   = 0x02
    }
}

extension PortInformation {
    public enum Information: Sendable {
        case modeInfo(ModeInfo)
        case possibleModeCombinations(PossibleModeCombinations)

        public init(informationTypeID: InformationTypeID, payload: some ByteCollection) throws {
            switch informationTypeID {
            case .modeInfo:
                self = .modeInfo(try ModeInfo(payload))

            case .possibleModeCombinations:
                self = .possibleModeCombinations(try PossibleModeCombinations(payload))
            }
        }
    }
}

extension PortInformation {
    public struct ModeInfo: ByteCollectionDecodable, Sendable {
        public let capabilities: Capabilities
        public let totalModeCount: UInt8
        public let inputModes: PortModeSet
        public let outputModes: PortModeSet
    }
}

extension PortInformation.ModeInfo {
    public init(_ bytes: some ByteCollection) throws {
        let view = bytes.view
        capabilities = try PortInformation.Capabilities(rawValue: view.uint8(0))
        totalModeCount = try view.uint8(1)
        inputModes = try PortInformation.PortModeSet(rawValue: view.uint16(2))
        outputModes = try PortInformation.PortModeSet(rawValue: view.uint16(4))
    }
}

extension PortInformation {
    public typealias PossibleModeCombinations = [PortModeSet]
}

extension PortInformation.PossibleModeCombinations: ByteCollectionDecodable {
    public init(_ bytes: some ByteCollection) throws {
        let view = bytes.view
        var portModeSets: Self = []
        for offset in stride(from: 0, to: view.count, by: 2) {
            portModeSets.append(try PortInformation.PortModeSet(rawValue: view.uint16(offset)))
        }
        self = portModeSets
    }
}

extension PortInformation {
    public struct Capabilities: OptionSet, Sendable {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public static let logicalSynchronizable = Capabilities(rawValue: 1 << 3)
        public static let logicalCombinable     = Capabilities(rawValue: 1 << 2)
        public static let input                 = Capabilities(rawValue: 1 << 1)
        public static let output                = Capabilities(rawValue: 1 << 0)
    }
}

extension PortInformation {
    public struct PortModeSet: OptionSet, Sendable {
        public let rawValue: UInt16

        public init(rawValue: UInt16) {
            self.rawValue = rawValue
        }

        public var array: [UInt8] {
            return Array((0...15).filter { rawValue & 1 << $0 != 0 })
        }

        public static let mode0     = PortModeSet(rawValue: 1 << 0)
        public static let mode1     = PortModeSet(rawValue: 1 << 1)
        public static let mode2     = PortModeSet(rawValue: 1 << 2)
        public static let mode3     = PortModeSet(rawValue: 1 << 3)
        public static let mode4     = PortModeSet(rawValue: 1 << 4)
        public static let mode5     = PortModeSet(rawValue: 1 << 5)
        public static let mode6     = PortModeSet(rawValue: 1 << 6)
        public static let mode7     = PortModeSet(rawValue: 1 << 7)
        public static let mode8     = PortModeSet(rawValue: 1 << 8)
        public static let mode9     = PortModeSet(rawValue: 1 << 9)
        public static let mode10    = PortModeSet(rawValue: 1 << 10)
        public static let mode11    = PortModeSet(rawValue: 1 << 11)
        public static let mode12    = PortModeSet(rawValue: 1 << 12)
        public static let mode13    = PortModeSet(rawValue: 1 << 13)
        public static let mode14    = PortModeSet(rawValue: 1 << 14)
        public static let mode15    = PortModeSet(rawValue: 1 << 15)
    }
}

extension PortInformation: DecodableMessage {
    public init(payload: some ByteCollection) throws {
        let view = payload.view

        self.portID = try view.uint8(0)
        self.information = try Information(informationTypeID: view.rawRepresentable(1), payload: view.suffix(2))
    }
}

extension PortInformation.Capabilities: CustomStringConvertible {
    public var description: String {
        let strings: [String?] = [
            contains(.logicalSynchronizable) ? "Logical Synchronizable" : nil,
            contains(.logicalCombinable) ? "Logical Combinable" : nil,
            contains(.input) ? "Input" : nil,
            contains(.output) ? "Output" : nil,
        ]
        let array = strings.compactMap { $0 }
        return array.isEmpty ? "-" : array.joined(separator: ", ")
    }
}

extension PortInformation.PortModeSet: CustomStringConvertible {
    public var description: String {
        return array.isEmpty ? "-" : array.map(String.init).joined(separator: ", ")
    }
}
