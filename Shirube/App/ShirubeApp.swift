import SwiftUI
import SwiftData

@main
struct ShirubeApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
        .modelContainer(for: PracticeRecord.self)
    }
}
