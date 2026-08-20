import SwiftUI
import SwiftData

@main
struct PenjiApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
        .modelContainer(for: PracticeRecord.self)
    }
}
