import SwiftData
import SwiftUI

struct CharacterSelectionView: View {
    @Query private var records: [PracticeRecord]
    private let lessons = LessonRepository().allLessons()
    private let columns = [GridItem(.adaptive(minimum: 76), spacing: 12)]

    var body: some View {
        let practicedCharacters = Set(records.map(\.character))
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(lessons) { lesson in
                        NavigationLink {
                            LessonDetailView(lesson: lesson)
                        } label: {
                            CharacterCard(lesson: lesson, isPracticed: practicedCharacters.contains(lesson.character))
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
