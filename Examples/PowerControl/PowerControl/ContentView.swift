import SwiftUI

struct ContentView: View {
    @StateObject var hub = Hub()
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                if hub.isReady {
                    Text(hub.connectingPeripheral?.name ?? "No name")
                    Button {
                        hub.disconnect()
                    } label: {
                        Image.xmark
                    }
                } else if hub.isConnecting {
                    Text("Connecting...")
                    Button {
                        hub.cancelConnecting()
                    } label: {
                        Image.xmark
                    }
                } else {
                    Button("Connect") {
                        hub.connect()
                    }
                }
            }
            
            Text(hub.power.description)
                .font(.largeTitle)

            HStack {
                Button {
                    let power = max(hub.power - 10, -100)
                    hub.setPower(power)
                } label: {
                    Image.minus
                }
                Button {
                    hub.setPower(0)
                } label: {
                    Image.stop
                }
                Button {
                    let power = min(hub.power + 10, 100)
                    hub.setPower(power)
                } label: {
                    Image.plus
                }
            }
            .disabled(!hub.isReady)
        }
    }
}

extension Image {
    static var xmark: Image {
#if os(macOS) || os(visionOS)
        Image(systemName: "xmark")
#else
        Image(systemName: "xmark.circle.fill")
#endif
    }
    static var plus: Image {
#if os(macOS) || os(visionOS)
        Image(systemName: "plus")
#else
        Image(systemName: "plus.circle")
#endif
    }
    static var minus: Image {
#if os(macOS) || os(visionOS)
        Image(systemName: "minus")
#else
        Image(systemName: "minus.circle")
#endif
    }
    static var stop: Image {
#if os(macOS) || os(visionOS)
        Image(systemName: "square")
#else
        Image(systemName: "square.circle")
#endif
    }
}
