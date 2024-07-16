/// Version Number
///
/// [3.5.6. Version Number Encoding](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#version-number-encoding)
public struct VersionNumber: Sendable {
    public let majorVersion: UInt8
    public let minorVersion: UInt8
    public let bugFixingNumber: UInt8
    public let buildNumber: UInt16

    public init(majorVersion: UInt8, minorVersion: UInt8, bugFixingNumber: UInt8, buildNumber: UInt16) {
        self.majorVersion = majorVersion
        self.minorVersion = minorVersion
        self.bugFixingNumber = bugFixingNumber
        self.buildNumber = buildNumber
    }
}

extension VersionNumber: ByteCollectionDecodable {
    public init(_ bytes: some ByteCollection) throws {
        let view = bytes.view

        guard let majorAndMinorVersion = try view.uint8(3).binaryCodedDecimal,
            let bugFixingNumber = try view.uint8(2).binaryCodedDecimal,
            let buildNumber = try view.uint16(0).binaryCodedDecimal
        else {
            throw Error.invalidFormat
        }

        self.majorVersion = majorAndMinorVersion / 10
        self.minorVersion = majorAndMinorVersion % 10
        self.bugFixingNumber = bugFixingNumber
        self.buildNumber = buildNumber
    }
}

extension VersionNumber {
    public enum Error: Swift.Error {
        case invalidFormat
    }
}

extension VersionNumber: CustomStringConvertible {
    public var description: String {
        return String(format: "%d.%d.%02d.%04d", majorVersion, minorVersion, bugFixingNumber, buildNumber)
    }
}
