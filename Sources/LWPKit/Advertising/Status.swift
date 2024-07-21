extension ManufacturerData {

    /// Status
    ///
    /// [2.4. Status](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#status)
    public struct Status: OptionSet, Sendable {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public static let canBePeripheral   = Status(rawValue: 1 << 0)
        public static let canBeCentral      = Status(rawValue: 1 << 1)
        public static let requestWindow     = Status(rawValue: 1 << 5)
        public static let requestConnect    = Status(rawValue: 1 << 6)
    }
}

extension ManufacturerData.Status: CustomStringConvertible {
    public var description: String {
        let strings: [String?] = [
            contains(.canBePeripheral) ? "I can be Peripheral" : nil,
            contains(.canBeCentral) ? "I can be Central" : nil,
            contains(.requestWindow) ? "Request Window" : nil,
            contains(.requestConnect) ? "Request Connect" : nil,
        ]
        let array = strings.compactMap { $0 }
        return array.isEmpty ? "-" : array.joined(separator: ", ")
    }
}
