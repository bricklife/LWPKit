/// LWP Version Number
///
/// [3.5.7. LWP Version Number Encoding](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#lwp-ver-no)
public struct LWPVersionNumber: Sendable {
    public let majorVersion: UInt8
    public let minorVersion: UInt8

    public init(majorVersion: UInt8, minorVersion: UInt8) {
        self.majorVersion = majorVersion
        self.minorVersion = minorVersion
    }
}

extension LWPVersionNumber: ByteCollectionDecodable {
    public init(_ bytes: some ByteCollection) throws {
        let view = bytes.view

        guard let majorVersion = try view.uint8(1).binaryCodedDecimal,
            let minorVersion = try view.uint8(0).binaryCodedDecimal
        else {
            throw Error.invalidFormat
        }

        self.majorVersion = majorVersion
        self.minorVersion = minorVersion
    }
}

extension LWPVersionNumber {
    public enum Error: Swift.Error {
        case invalidFormat
    }
}

extension LWPVersionNumber: CustomStringConvertible {
    public var description: String {
        return String(format: "%d.%d", majorVersion, minorVersion)
    }
}
