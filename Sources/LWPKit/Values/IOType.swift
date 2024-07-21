/// IO Type
///
/// [3.8.4. IO Type ID](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#io-type-id)
public enum IOType: UInt16, Sendable {
    case mediumMotor                = 0x0001
    case trainMotor                 = 0x0002
    case light                      = 0x0008
    case voltageSensor              = 0x0014
    case currentSensor              = 0x0015
    case piezoSpeaker               = 0x0016
    case hubRgbLight                = 0x0017
    case tiltSensor                 = 0x0022
    case motionSensor               = 0x0023
    case colorDistanceSensor        = 0x0025
    case mediumLinearMotor          = 0x0026
    case moveHubMotor               = 0x0027
    case moveHubTiltSensor          = 0x0028
    case trainBaseMotor             = 0x0029
    case trainBaseSpeaker           = 0x002a
    case trainBaseColorSensor       = 0x002b
    case trainBaseSpeedometer       = 0x002c
    case largeMotor                 = 0x002e
    case extraLargeMotor            = 0x002f
    case mediumAngularMotor         = 0x0030
    case largeAngularMotor          = 0x0031
    case hubGestureSensor           = 0x0036
    case remoteControlButton        = 0x0037
    case remoteControlRSSI          = 0x0038
    case hubAccelerometer           = 0x0039
    case hubGyroSensor              = 0x003a
    case hubTiltSensor              = 0x003b
    case hubTemperatureSensor       = 0x003c
    case colorSensor                = 0x003d
    case distanceSensor             = 0x003e
    case forceSensor                = 0x003f
    case colorLightMatrix           = 0x0040
    case smallAngularMotor          = 0x0041
    case moveHubUnknown0042         = 0x0042
    case marioUnknown0046           = 0x0046
    case marioAccelerometer         = 0x0047
    case marioColorBarcodeSensor    = 0x0049
    case marioPantsSensor           = 0x004a
    case mediumAngularMotorGray     = 0x004b
    case largeAngularMotorGray      = 0x004c
    case spikeEssentialUnknown004e  = 0x004e
    case marioUnknown0055           = 0x0055
}

extension IOType {
    public var isMotor: Bool {
        return description.contains("Motor")
    }

    public var isDCMotor: Bool {
        switch self {
        case .mediumMotor, .trainMotor, .trainBaseMotor:
            return true
        default:
            return false
        }
    }

    public var hasRotationSensor: Bool {
        return isMotor && !isDCMotor
    }
}

extension IOType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .mediumMotor:
            return "Medium Motor"
        case .trainMotor:
            return "Train Motor"
        case .light:
            return "Light"
        case .voltageSensor:
            return "Voltage Sensor"
        case .currentSensor:
            return "Current Sensor"
        case .piezoSpeaker:
            return "Piezo Speaker"
        case .hubRgbLight:
            return "Hub RGB Light"
        case .tiltSensor:
            return "Tilt Sensor"
        case .motionSensor:
            return "Motion Sensor"
        case .colorDistanceSensor:
            return "Color & Distance Sensor"
        case .mediumLinearMotor:
            return "Medium Linear Motor"
        case .moveHubMotor:
            return "Move Hub Motor"
        case .moveHubTiltSensor:
            return "Move Hub Tilt Sensor"
        case .trainBaseMotor:
            return "Duplo Train Base Motor"
        case .trainBaseSpeaker:
            return "Duplo Train Base Speaker"
        case .trainBaseColorSensor:
            return "Duplo Train Base Color Sensor"
        case .trainBaseSpeedometer:
            return "Duplo Train Base Speedometer"
        case .largeMotor:
            return "Large Motor"
        case .extraLargeMotor:
            return "XL Motor"
        case .mediumAngularMotor:
            return "Medium Angular Motor"
        case .largeAngularMotor:
            return "Large Angular Motor"
        case .hubGestureSensor:
            return "Hub Gesture Sensor"
        case .remoteControlButton:
            return "Remote Control Button"
        case .remoteControlRSSI:
            return "Remote Control RSSI"
        case .hubAccelerometer:
            return "Hub Accelerometer"
        case .hubGyroSensor:
            return "Hub Gyro Sensor"
        case .hubTiltSensor:
            return "Hub Tilt Sensor"
        case .hubTemperatureSensor:
            return "Hub Temperature Sensor"
        case .colorSensor:
            return "Color Sensor"
        case .distanceSensor:
            return "Distance Sensor"
        case .forceSensor:
            return "Force Sensor"
        case .colorLightMatrix:
            return "Color Light Matrix"
        case .smallAngularMotor:
            return "Small Angular Motor"
        case .moveHubUnknown0042:
            return "Unknown 0042"
        case .marioUnknown0046:
            return "Unknown 0046"
        case .marioAccelerometer:
            return "Mario Accelerometer"
        case .marioColorBarcodeSensor:
            return "Mario Color Barcode Sensor"
        case .marioPantsSensor:
            return "Mario Pants Sensor"
        case .mediumAngularMotorGray:
            return "Medium Angular Motor (Gray)"
        case .largeAngularMotorGray:
            return "Large Angular Motor (Gray)"
        case .spikeEssentialUnknown004e:
            return "Unknown 004e"
        case .marioUnknown0055:
            return "Unknown 0055"
        }
    }
}
