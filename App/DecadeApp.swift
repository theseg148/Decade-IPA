import SwiftUI

@main
struct DecadeApp: App {
    var body: some Scene {
        WindowGroup {
            GameWebView()
                .ignoresSafeArea()
        }
    }
}
