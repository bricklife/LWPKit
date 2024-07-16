/// SetColorLightMatrix
///
/// No documentation
public struct SetColorLightMatrix: WriteDirectModeData {
    public let mode: UInt8 = 0x02

    public let portID: UInt8
    public let startupAndCompletionInformation: UInt8
    public let colorIDs: [Color]
    public let colorLevels: [UInt8]

    public static let defaultColorLevels: [UInt8] = .init(repeating: 0x0a, count: 9)

    public init(portID: UInt8, startupAndCompletionInformation: UInt8 = 0x11, colorIDs: [Color], colorLevels: [UInt8] = defaultColorLevels) {
        self.portID = portID
        self.startupAndCompletionInformation = startupAndCompletionInformation
        self.colorIDs = colorIDs
        self.colorLevels = colorLevels
    }

    public func writeDirectModeDataPayload() throws -> [UInt8] {
        let array = Array(zip(colorIDs, colorLevels))
        guard array.count == 9 else { throw SetColorLightMatrix.Error.numOfColorError }
        return array.map { (id, level) in (level << 4) | (id.rawValue & 0x0f) }
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
