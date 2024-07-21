/// Port Output Command
///
/// [3.26. Port Output Command](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#port-output-command)
public protocol PortOutputCommand: EncodableMessage {
    var portID: Port.ID { get }
    var startupAndCompletionInformation: UInt8 { get }  // TODO: Use struct??
    var subCommand: UInt8 { get }

    func portOutputCommandPayload() throws -> [UInt8]

    static func canUse(for ioType: IOType) -> Bool
}

extension PortOutputCommand {
    public static var messageType: MessageType {
        return .portOutputCommand
    }

    public func payload() throws -> [UInt8] {
        return try [portID, startupAndCompletionInformation, subCommand] + portOutputCommandPayload()
    }
}
