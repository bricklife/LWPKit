/// SetColorLightMatrix
///
/// No documentation
public struct SetColorLightMatrix: WriteDirectModeData {
    public let mode: UInt8 = 0x02

    public let portID: Port.ID
    public let startupAndCompletionInformation: UInt8
    public let colorMatrix: [Color]
    public let brightnessMatrix: [UInt8]

    public static let defaultBrightnessMatrix: [UInt8] = .init(repeating: 10, count: 9)

    public init(portID: Port.ID, startupAndCompletionInformation: UInt8 = 0x11, colorMatrix: [Color], brightnessMatrix: [UInt8] = defaultBrightnessMatrix) {
        self.portID = portID
        self.startupAndCompletionInformation = startupAndCompletionInformation
        self.colorMatrix = colorMatrix
        self.brightnessMatrix = brightnessMatrix
    }

    public func writeDirectModeDataPayload() throws -> [UInt8] {
        let array = Array(zip(colorMatrix, brightnessMatrix))
        guard array.count == 9 else { throw SetColorLightMatrix.Error.numOfColorError }
        return array.map { (color, brightness) in (brightness << 4) | (color.rawValue & 0x0f) }
    }

    public static func canUse(for ioType: IOType) -> Bool {
        return ioType == .colorLightMatrix
    }
}

extension SetColorLightMatrix {
    public enum Error: Swift.Error {
        case numOfColorError
    }
}
