/// Port
///
/// [3.8.2. Port ID](https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#port-id)
public enum Port: UInt8, CaseIterable, Sendable {
    case A  = 0x00
    case B  = 0x01
    case C  = 0x02
    case D  = 0x03
    case E  = 0x04
    case F  = 0x05
}
