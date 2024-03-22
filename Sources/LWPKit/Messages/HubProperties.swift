/**
 Hub Property Message
 
 [3.5. Hub Properties](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#hub-properties)
 */
public struct HubPropertyMessage: Message {
    
    public static var messageType = MessageType.hubProperties
    
    public let property: HubProperty
    public let operation: HubProperty.Operation
    public let value: HubProperty.Value?
    
    public init(property: HubProperty, operation: HubProperty.Operation, value: HubProperty.Value? = nil) {
        self.property = property
        self.operation = operation
        self.value = value
    }
}

extension HubPropertyMessage: EncodableMessage {
    
    public func payload() throws -> [UInt8] {
        switch operation {
        case .set:
            return [property.rawValue, operation.rawValue] + (value?.bytes() ?? [])
        case .enableUpdates, .disableUpdates, .reset, .requestUpdate, .update:
            return [property.rawValue, operation.rawValue]
        }
    }
}

extension HubPropertyMessage: DecodableMessage {
    
    public init(payload: some ByteCollection) throws {
        let view = payload.view
        
        self.property = try view.rawRepresentable(0)
        self.operation = try view.rawRepresentable(1)
        
        if operation == .set || operation == .update {
            self.value = try property.value(payload: view.suffix(2))
        } else {
            self.value = nil
        }
    }
}
