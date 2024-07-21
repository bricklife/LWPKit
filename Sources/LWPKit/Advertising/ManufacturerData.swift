import Foundation

/// Manufacturer Data
///
/// [2. Advertising](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#document-2-Advertising)
public struct ManufacturerData: Sendable {
    public let buttonState: Bool
    public let systemTypeID: SystemType.RawValue
    public let deviceCapabilities: DeviceCapabilities
    public let lastNetwork: UInt8
    public let status: Status
    public let option: UInt8

    public init?(data: Data) {
        guard data.count == 8 else { return nil }
        let startIndex = data.startIndex

        // Manufacturer identifier should be 0x0397
        guard data[startIndex] == 0x97, data[startIndex + 1] == 0x03 else { return nil }

        self.buttonState = data[startIndex + 2] != 0
        self.systemTypeID = data[startIndex + 3]
        self.deviceCapabilities = DeviceCapabilities(rawValue: data[startIndex + 4])
        self.lastNetwork = data[startIndex + 5]
        self.status = Status(rawValue: data[startIndex + 6])
        self.option = data[startIndex + 7]
    }
}
