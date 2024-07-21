/// System Type
///
/// [2.1. System Type and Device Number](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#system-type-and-device-number)
public enum SystemType: UInt8, CaseIterable, Sendable {
    case duploTrain     = 0x20
    case boost          = 0x40
    case poweredUp      = 0x41
    case remoteControl  = 0x42
    case mario          = 0x43
    case luigi          = 0x44
    case peach          = 0x45
    case controlPlus    = 0x80
    case spikeEssential = 0x83
}

extension SystemType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .duploTrain:
            return "Duplo Train Base"
        case .boost:
            return "BOOST Move Hub"
        case .poweredUp:
            return "Powered Up Smart Hub"
        case .remoteControl:
            return "Powered Up Remote Control"
        case .mario:
            return "Mario"
        case .luigi:
            return "Luigi"
        case .peach:
            return "Peach"
        case .controlPlus:
            return "CONTROL+ Smart Hub"
        case .spikeEssential:
            return "SPIKE Essential Hub"
        }
    }
}
