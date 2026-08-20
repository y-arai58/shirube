import SwiftUI

struct AppRootView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("ホーム", systemImage: "house") }

            CharacterSelectionView()
                .tabItem { Label("練習", systemImage: "character.book.closed") }

            TextPracticeMenuView()
                .tabItem { Label("文章", systemImage: "text.book.closed") }

            HistoryView()
                .tabItem { Label("履歴", systemImage: "clock.arrow.circlepath") }
        }
    }
}
