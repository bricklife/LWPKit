import Combine
import CoreBluetooth
import LWPKit

private let serviceUUID = CBUUID(string: GATT.serviceUUID)
private let characteristicUUID = CBUUID(string: GATT.characteristicUUID)

@MainActor
final class Hub: NSObject, ObservableObject {
    private let centralManager = CBCentralManager()
    
    @Published var isConnecting = false
    @Published var isReady = false
    @Published var connectingPeripheral: CBPeripheral?
    private weak var lwpCharacteristic: CBCharacteristic?
    
    @Published var power: Int8 = 0
    @Published var powerSupportedPorts: Set<UInt8> = []
    
    override init() {
        super.init()
        centralManager.delegate = self
        centralManager.publisher(for: \.isScanning).assign(to: &$isConnecting)
    }
    
    func connect() {
        guard centralManager.state == .poweredOn else { return }
        
        // Step 1: Scan
        centralManager.scanForPeripherals(withServices: [serviceUUID])
    }
    
    func cancelConnecting() {
        centralManager.stopScan()
        disconnect()
    }
    
    func disconnect() {
        if let peripheral = connectingPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
}

extension Hub: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Found:", peripheral.name ?? "No name", RSSI)
        if connectingPeripheral == nil /* && peripheral.name == "YOUR_HUB_NAME" */ {
            connectingPeripheral = peripheral
            
            // Step 2: Connect
            centralManager.connect(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print(#function)
        peripheral.delegate = self
        
        // Step 3: Discover Service
        peripheral.discoverServices([serviceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(#function)
        connectingPeripheral = nil
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print(#function)
        connectingPeripheral = nil
        isReady = false
        
        power = 0
        powerSupportedPorts = []
    }
}

extension Hub: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(#function)
        guard let service = peripheral.services?.first(where: { $0.uuid == serviceUUID }) else {
            centralManager.cancelPeripheralConnection(peripheral)
            return
        }
        
        // Step 4: Discover Characteristic
        peripheral.discoverCharacteristics([characteristicUUID], for: service)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print(#function)
        guard let characteristic = service.characteristics?.first(where: { $0.uuid == characteristicUUID }) else {
            centralManager.cancelPeripheralConnection(peripheral)
            return
        }
        lwpCharacteristic = characteristic
        centralManager.stopScan()
        isReady = true
        
        // Step 6: Enable Notifications
        peripheral.setNotifyValue(true, for: characteristic)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        print("[notify]", data.hexString)
        decodeNotification(data)
    }
}

extension Hub {
    func write(_ data: Data) {
        guard let connectingPeripheral, let lwpCharacteristic else { return }
        print("[write]", data.hexString)
        
        // Step 5: Write
        connectingPeripheral.writeValue(data, for: lwpCharacteristic, type: .withoutResponse)
    }
}

extension Hub {
    func decodeNotification(_ data: Data) {
        do {
            let header = try CommonMessageHeader(data)
            switch header.messageType {
            case .hubAttachedIO:
                let message = try HubAttachedIOMessage(data)
                switch message.event {
                case let .attachedIO(ioTypeID, _, _):
                    let ioType = IOType(rawValue: ioTypeID)
                    print("- Attached I/O: \(ioType?.description ?? "Unknown") (\(ioTypeID)) on port \(message.portID)")
                    if let ioType, StartPower.canUse(for: ioType) {
                        powerSupportedPorts.insert(message.portID)
                    }
                case let .attachedVirtualIO(ioTypeID, firstPortID, secondPortID):
                    let ioType = IOType(rawValue: ioTypeID)
                    print("- Attached Virtual I/O: \(ioType?.description ?? "Unknown") (\(ioTypeID)) on port \(message.portID) (\(firstPortID)+\(secondPortID))")
                case .detachedIO:
                    print("- Detached I/O from port \(message.portID)")
                    powerSupportedPorts.remove(message.portID)
                }
            default:
                print("- Unhandled message:", header.messageType, header.messageLength)
            }
        } catch {
            print(error)
        }
    }
    
    func setPower(_ power: Int8) {
        do {
            for portId in powerSupportedPorts {
                let message = StartPower(portID: portId, power: power)
                write(try message.data())
            }
        } catch {
            print(#function, error)
        }
        self.power = power
    }
}

extension CBManagerState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            "unknown"
        case .resetting:
            "resetting"
        case .unsupported:
            "unsupported"
        case .unauthorized:
            "unauthorized"
        case .poweredOff:
            "poweredOff"
        case .poweredOn:
            "poweredOn"
        @unknown default:
            "@unknown default"
        }
    }
}
