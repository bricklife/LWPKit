/// Port Output Command Feedback
///
/// [3.32. Port Output Command Feedback](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#port-output-command-feedback)
public struct PortOutputCommandFeedback: Message {
    public static var messageType = MessageType.portOutputCommandFeedback

    public let feedbacks: [Feedback]

    public init(feedbacks: [Feedback]) {
        self.feedbacks = feedbacks
    }
}

extension PortOutputCommandFeedback {
    public struct Feedback: Sendable {
        let portID: UInt8
        let feedbackMessage: Message

        public struct Message: OptionSet, Sendable {
            public let rawValue: UInt8

            public init(rawValue: UInt8) {
                self.rawValue = rawValue
            }

            public static let bufferEmptyCommandInProgress  = Message(rawValue: 1)
            public static let bufferEmptyCommandCompleted   = Message(rawValue: 1 << 1)
            public static let currentCommandsDiscarded      = Message(rawValue: 1 << 2)
            public static let idle                          = Message(rawValue: 1 << 3)
            public static let busyFull                      = Message(rawValue: 1 << 4)
        }
    }
}

extension PortOutputCommandFeedback: DecodableMessage {
    public init(payload: some ByteCollection) throws {
        let view = payload.view

        var feedbacks: [Feedback] = []
        for offset in stride(from: 0, to: payload.count, by: 2) {
            let feedback = try Feedback(
                portID: view.uint8(offset),
                feedbackMessage: view.rawRepresentable(offset + 1)
            )
            feedbacks.append(feedback)
        }
        self.feedbacks = feedbacks
    }
}

extension PortOutputCommandFeedback.Feedback: CustomStringConvertible {
    public var description: String {
        return "Port ID \(portID) = \(feedbackMessage)"
    }
}

extension PortOutputCommandFeedback.Feedback.Message: CustomStringConvertible {
    public var description: String {
        let strings: [String?] = [
            contains(.bufferEmptyCommandInProgress) ? "Buffer Empty + Command In Progress" : nil,
            contains(.bufferEmptyCommandCompleted) ? "Buffer Empty + Command Completed" : nil,
            contains(.currentCommandsDiscarded) ? "Current Command(s) Discarded" : nil,
            contains(.idle) ? "Idle" : nil,
            contains(.busyFull) ? "Busy/Full" : nil,
        ]
        let array = strings.compactMap { $0 }
        return array.isEmpty ? "-" : array.joined(separator: ", ")
    }
}
