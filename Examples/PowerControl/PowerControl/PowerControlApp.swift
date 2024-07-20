import SwiftUI

@main
struct PowerControlApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .padding(50)
        }
#if os(macOS) || os(visionOS)
        .windowResizability(.contentMinSize)
#endif
    }
}
