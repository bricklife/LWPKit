/// Hub Property
///
/// [3.5.1. Hub Property and Operation](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#hub-property-and-operation)
public enum HubProperty: UInt8, CaseIterable, Sendable {
    case advertisingName                = 0x01
    case button                         = 0x02
    case firmwareVersion                = 0x03
    case hardwareVersion                = 0x04
    case rssi                           = 0x05
    case batteryVoltage                 = 0x06
    case batteryType                    = 0x07
    case manufacturerName               = 0x08
    case radioFirmwareVersion           = 0x09
    case legoWirelessProtocolVersion    = 0x0a
    case systemTypeID                   = 0x0b
    case hardwareNetworkID              = 0x0c
    case primaryMacAddress              = 0x0d
    case secondaryMacAddress            = 0x0e
    case hardwareNetworkFamily          = 0x0f
    case speakerVolume                  = 0x12
}

extension HubProperty {
    public enum Operation: UInt8, CaseIterable, Sendable {
        case set            = 0x01
        case enableUpdates  = 0x02
        case disableUpdates = 0x03
        case reset          = 0x04
        case requestUpdate  = 0x05
        case update         = 0x06
    }

    public var operations: [Operation] {
        switch self {
        case .advertisingName, .speakerVolume:
            return Operation.allCases
        case .button, .rssi, .batteryVoltage:
            return [.enableUpdates, .disableUpdates, .requestUpdate, .update]
        case .hardwareNetworkID:
            return [.set, .reset, .requestUpdate, .update]
        case .hardwareNetworkFamily:
            return [.set, .requestUpdate, .update]
        case .firmwareVersion, .hardwareVersion, .batteryType, .manufacturerName, .radioFirmwareVersion, .legoWirelessProtocolVersion, .systemTypeID, .primaryMacAddress, .secondaryMacAddress:
            return [.requestUpdate, .update]
        }
    }
}

extension HubProperty {
    public enum Encoding: Sendable {
        case bool
        case uint8
        case int8
        case string
        case versionNumber
        case lwpVersionNumber
        case macAddress
    }

    public var encoding: Encoding {
        switch self {
        case .advertisingName:
            return .string
        case .button:
            return .bool
        case .firmwareVersion:
            return .versionNumber
        case .hardwareVersion:
            return .versionNumber
        case .rssi:
            return .int8
        case .batteryVoltage:
            return .uint8
        case .batteryType:
            return .uint8
        case .manufacturerName:
            return .string
        case .radioFirmwareVersion:
            return .string
        case .legoWirelessProtocolVersion:
            return .lwpVersionNumber
        case .systemTypeID:
            return .uint8
        case .hardwareNetworkID:
            return .uint8
        case .primaryMacAddress:
            return .macAddress
        case .secondaryMacAddress:
            return .macAddress
        case .hardwareNetworkFamily:
            return .uint8
        case .speakerVolume:
            return .uint8
        }
    }
}

extension HubProperty {
    public enum Value: Sendable {
        case bool(Bool)
        case uint8(UInt8)
        case int8(Int8)
        case string(String)
        case versionNumber(VersionNumber)
        case lwpVersionNumber(LWPVersionNumber)
        case macAddress(MacAddress)
    }

    public func value(payload: some ByteCollection) throws -> Value {
        let view = payload.view

        switch encoding {
        case .bool:
            return .bool(try view.uint8(0) > 0)
        case .uint8:
            return .uint8(try view.uint8(0))
        case .int8:
            return .int8(try view.int8(0))
        case .string:
            return .string(try view.string(0))
        case .versionNumber:
            return .versionNumber(try VersionNumber(payload))
        case .lwpVersionNumber:
            return .lwpVersionNumber(try LWPVersionNumber(payload))
        case .macAddress:
            return .macAddress(try MacAddress(payload))
        }
    }
}

extension HubProperty.Value {
    public func bytes() -> [UInt8] {
        switch self {
        case .bool(let value):
            return value ? [1] : [0]
        case .uint8(let value):
            return [value]
        case .int8(let value):
            return [UInt8(bitPattern: value)]
        case .string(let value):
            return Array(value.utf8)
        case .versionNumber, .lwpVersionNumber, .macAddress:
            return []  // Never used
        }
    }
}

extension HubProperty: CustomStringConvertible {
    public var description: String {
        switch self {
        case .advertisingName:
            return "Advertising Name"
        case .button:
            return "Button"
        case .firmwareVersion:
            return "Firmware Version"
        case .hardwareVersion:
            return "Hardware Version"
        case .rssi:
            return "RSSI"
        case .batteryVoltage:
            return "Battery Voltage [%]"
        case .batteryType:
            return "Battery Type"
        case .manufacturerName:
            return "Manufacturer Name"
        case .radioFirmwareVersion:
            return "Radio Firmware Version"
        case .legoWirelessProtocolVersion:
            return "LEGO Wireless Protocol Version"
        case .systemTypeID:
            return "System Type ID"
        case .hardwareNetworkID:
            return "Hardware Network ID"
        case .primaryMacAddress:
            return "Primary MAC Address"
        case .secondaryMacAddress:
            return "Secondary MAC Address"
        case .hardwareNetworkFamily:
            return "Hardware Network Family"
        case .speakerVolume:
            return "Speaker Volume"
        }
    }
}

extension HubProperty.Operation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .set:
            return "Set"
        case .enableUpdates:
            return "Enable Updates"
        case .disableUpdates:
            return "Disable Updates"
        case .reset:
            return "Reset"
        case .requestUpdate:
            return "Request Update"
        case .update:
            return "Update"
        }
    }
}

extension HubProperty.Value: CustomStringConvertible {
    public var description: String {
        switch self {
        case .bool(let bool):
            return bool.description
        case .uint8(let uint8):
            return uint8.description
        case .int8(let int8):
            return int8.description
        case .string(let string):
            return string
        case .versionNumber(let versionNumber):
            return versionNumber.description
        case .lwpVersionNumber(let lwpVersionNumber):
            return lwpVersionNumber.description
        case .macAddress(let macAddress):
            return macAddress.description
        }
    }
}
