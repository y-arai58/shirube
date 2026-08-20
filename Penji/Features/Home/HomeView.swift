import SwiftData
import SwiftUI

struct HomeView: View {
    @Query(sort: \PracticeRecord.createdAt, order: .reverse) private var records: [PracticeRecord]
    private let lessonRepository = LessonRepository()

    var body: some View {
        let viewModel = HomeViewModel(
            lessons: lessonRepository.allLessons(),
            practicedCharacters: Set(records.map(\.character))
        )

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("今日も、丁寧に一文字。")
                            .font(.largeTitle.bold())
                        Text("書くことを楽しむ、iPadのペン字練習")
                            .foregroundStyle(.secondary)
                    }

                    ProgressCard(progress: viewModel.progress, practicedCount: viewModel.practicedCharacters.count)

                    if let lesson = viewModel.recommendedLesson {
                        NavigationLink {
                            LessonDetailView(lesson: lesson)
                        } label: {
                            CharacterCard(lesson: lesson, isPracticed: false, isRecommended: true)
                        }
                        .buttonStyle(.plain)
                    } else {
                        ContentUnavailableView("すべて練習済みです", systemImage: "checkmark.seal", description: Text("好きな文字をもう一度練習しましょう。"))
                    }

                    if !records.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("最近の練習").font(.title2.bold())
                            ForEach(records.prefix(3)) { record in
                                PracticeRecordCard(record: record)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 800, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle("ペン字練習")
        }
    }
}
