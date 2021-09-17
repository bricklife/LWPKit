import Foundation

// https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#message-types

public enum MessageType: UInt8 {
    
    case hubProperties              = 0x01
    case hubActions                 = 0x02
    case hubAlerts                  = 0x03
    case hubAttachedIO              = 0x04
    case genericErrorMessages       = 0x05
    case hwNetWorkCommands          = 0x08
    case fwUpdateGoIntoBootMode     = 0x10
    case fwUpdateLockMemory         = 0x11
    case fwUpdateLockStatusRequest  = 0x12
    case fwLockStatus               = 0x13
    
    case portInformationRequest             = 0x21
    case portModeInformationRequest         = 0x22
    case portInputFormatSetupSingle         = 0x41
    case portInputFormatSetupCombinedMode   = 0x42
    case portInformation                    = 0x43
    case portModeInformation                = 0x44
    case portValueSingle                    = 0x45
    case portValueCombinedMode              = 0x46
    case portInputFormatSingle              = 0x47
    case portInputFormatCombinedMode        = 0x48
    case virtualPortSetup                   = 0x61
    case portOutputCommand                  = 0x81
    case portOutputCommandFeedback          = 0x82
}

extension MessageType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .hubProperties:
            return "Hub Properties"
        case .hubActions:
            return "Hub Actions"
        case .hubAlerts:
            return "Hub Alerts"
        case .hubAttachedIO:
            return "Hub Attached I/O"
        case .genericErrorMessages:
            return "Generic Error Messages"
        case .hwNetWorkCommands:
            return "H/W NetWork Commands"
        case .fwUpdateGoIntoBootMode:
            return "F/W Update - Go Into Boot Mode"
        case .fwUpdateLockMemory:
            return "F/W Update Lock memory"
        case .fwUpdateLockStatusRequest:
            return "F/W Update Lock Status Request"
        case .fwLockStatus:
            return "F/W Lock Status"
        case .portInformationRequest:
            return "Port Information Request"
        case .portModeInformationRequest:
            return "Port Mode Information Request"
        case .portInputFormatSetupSingle:
            return "Port Input Format Setup (Single)"
        case .portInputFormatSetupCombinedMode:
            return "Port Input Format Setup (CombinedMode)"
        case .portInformation:
            return "Port Information"
        case .portModeInformation:
            return "Port Mode Information"
        case .portValueSingle:
            return "Port Value (Single)"
        case .portValueCombinedMode:
            return "Port Value (CombinedMode)"
        case .portInputFormatSingle:
            return "Port Input Format (Single)"
        case .portInputFormatCombinedMode:
            return "Port Input Format (CombinedMode)"
        case .virtualPortSetup:
            return "Virtual Port Setup"
        case .portOutputCommand:
            return "Port Output Command"
        case .portOutputCommandFeedback:
            return "Port Output Command Feedback"
        }
    }
}
