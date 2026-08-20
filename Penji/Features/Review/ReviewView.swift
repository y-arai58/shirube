import PencilKit
import SwiftUI

struct ReviewView: View {
    let lesson: CharacterLesson
    let record: PracticeRecord
    @State private var comparisonMode: ComparisonMode = .sideBySide
    @State private var exemplarOpacity = 0.3

    private var drawing: PKDrawing? {
        try? PKDrawing(data: record.drawingData)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(.green)
                Text("おつかれさまでした")
                    .font(.title.bold())
                Text("「\(lesson.character)」の練習を記録しました。")
                    .foregroundStyle(.secondary)

                Picker("比較方法", selection: $comparisonMode) {
                    ForEach(ComparisonMode.allCases) { mode in Text(mode.title).tag(mode) }
                }
                .pickerStyle(.segmented)

                if let drawing {
                    DrawingComparisonView(lesson: lesson, drawing: drawing, mode: comparisonMode, exemplarOpacity: exemplarOpacity)
                } else {
                    ContentUnavailableView("記録を読み込めません", systemImage: "exclamationmark.triangle")
                }

                if comparisonMode == .overlay {
                    HStack {
                        Text("お手本の濃さ")
                        Slider(value: $exemplarOpacity, in: 0.05...0.7)
                    }
                }

                HStack {
                    NavigationLink("もう一度練習") { PracticeView(lesson: lesson) }
                        .buttonStyle(.bordered)
                    if let next = LessonRepository().nextLesson(after: lesson) {
                        NavigationLink("次の文字へ") { PracticeView(lesson: next) }
                            .buttonStyle(.borderedProminent)
                    }
                }
            }
            .padding()
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("練習完了")
        .navigationBarTitleDisplayMode(.inline)
    }
}
