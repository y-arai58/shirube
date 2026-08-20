import SwiftData
import SwiftUI

struct CharacterSelectionView: View {
    @Query private var records: [PracticeRecord]
    private let columns = [GridItem(.adaptive(minimum: 76), spacing: 12)]

    var body: some View {
        let viewModel = CharacterSelectionViewModel(practicedCharacters: Set(records.map(\.character)))
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.lessons) { lesson in
                        NavigationLink {
                            LessonDetailView(lesson: lesson)
                        } label: {
                            CharacterCard(lesson: lesson, isPracticed: viewModel.isPracticed(lesson))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("文字を選ぶ")
        }
    }
}
