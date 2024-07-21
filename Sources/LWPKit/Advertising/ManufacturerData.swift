import Foundation

/// Manufacturer Data
///
/// [2. Advertising](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#document-2-Advertising)
public struct ManufacturerData: Sendable {
    public let buttonState: Bool
    public let systemTypeID: SystemType.RawValue

    public init?(data: Data) {
        guard data.count == 8 else { return nil }
        let startIndex = data.startIndex
        guard data[startIndex] == 0x97, data[startIndex + 1] == 0x03 else { return nil }

        self.buttonState = data[startIndex + 2] != 0
        self.systemTypeID = data[startIndex + 3]
    }
}
