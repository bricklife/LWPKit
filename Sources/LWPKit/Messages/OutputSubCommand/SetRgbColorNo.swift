/// SetRgbColorNo(ColorNo)
///
/// [3.27.20. Output Sub Command - SetRgbColorNo(ColorNo)](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#output-sub-command-setrgbcolorno-colorno-n-a)
public struct SetRgbColorNo: WriteDirectModeData {
    public let mode: UInt8 = 0x00

    public let portID: Port.ID
    public let startupAndCompletionInformation: UInt8
    public let color: Color

    public init(portID: Port.ID, startupAndCompletionInformation: UInt8 = 0x11, color: Color) {
        self.portID = portID
        self.startupAndCompletionInformation = startupAndCompletionInformation
        self.color = color
    }

    public func writeDirectModeDataPayload() throws -> [UInt8] {
        return [color.rawValue]
    }

    public static func canUse(for ioType: IOType) -> Bool {
        return ioType == .hubRgbLight
    }
}
