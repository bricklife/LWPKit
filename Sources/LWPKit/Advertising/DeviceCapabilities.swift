extension ManufacturerData {

    /// Device Capabilities
    ///
    /// [2.2. Device Capabilities (Hub Kind)](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#device-capabilities-hub-kind)
    public struct DeviceCapabilities: OptionSet, Sendable {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public static let supportsCentralRole       = DeviceCapabilities(rawValue: 1 << 0)
        public static let supportsPeripheralRole    = DeviceCapabilities(rawValue: 1 << 1)
        public static let supportsLPF2devices       = DeviceCapabilities(rawValue: 1 << 2)
        public static let actAsRemoteController     = DeviceCapabilities(rawValue: 1 << 3)
    }
}

extension ManufacturerData.DeviceCapabilities: CustomStringConvertible {
    public var description: String {
        let strings: [String?] = [
            contains(.supportsCentralRole) ? "Supports Central Role" : nil,
            contains(.supportsPeripheralRole) ? "Supports Peripheral Role" : nil,
            contains(.supportsLPF2devices) ? "Supports LPF2 devices (H/W connectors)" : nil,
            contains(.actAsRemoteController) ? "Act as a Remote Controller (R/C)" : nil,
        ]
        let array = strings.compactMap { $0 }
        return array.isEmpty ? "-" : array.joined(separator: ", ")
    }
}
