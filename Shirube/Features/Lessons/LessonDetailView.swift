import SwiftUI

struct LessonDetailView: View {
    let lesson: CharacterLesson

    var body: some View {
        let viewModel = LessonDetailViewModel(lesson: lesson)
        ScrollView {
            VStack(spacing: 28) {
                ExemplarImageView(lesson: viewModel.lesson)
                    .padding(24)
                    .frame(maxWidth: .infinity, minHeight: 330)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 28))

                VStack(alignment: .leading, spacing: 12) {
                    Text("書くポイント").font(.title2.bold())
                    ForEach(viewModel.lesson.tips, id: \.self) { tip in
                        Label(tip, systemImage: "pencil.line")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                NavigationLink {
                    PracticeView(lesson: viewModel.lesson)
                } label: {
                    Label("「\(viewModel.lesson.character)」を練習する", systemImage: "pencil.and.scribble")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("「\(lesson.character)」")
        .navigationBarTitleDisplayMode(.inline)
    }
}
