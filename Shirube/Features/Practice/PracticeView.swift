import PencilKit
import SwiftData
import SwiftUI

struct PracticeView: View {
    let lesson: CharacterLesson
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: PracticeViewModel
    @State private var canvasController = CanvasController()
    @State private var savedRecord: PracticeRecord?

    init(lesson: CharacterLesson) {
        self.lesson = lesson
        _viewModel = State(initialValue: PracticeViewModel())
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                Group {
                    if proxy.size.width > 850 && horizontalSizeClass == .regular && viewModel.mode == .free {
                        HStack(alignment: .top, spacing: 28) {
                            exemplarPanel
                            practiceCanvas
                        }
                    } else {
                        VStack(spacing: 22) {
                            if viewModel.mode == .free { exemplarPanel }
                            practiceCanvas
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 1_100)
                .frame(maxWidth: .infinity)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("「\(lesson.character)」を練習")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .alert("保存できませんでした", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } })) {
            Button("閉じる", role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .navigationDestination(item: $savedRecord) { record in
            ReviewView(lesson: lesson, record: record)
        }
    }

    private var exemplarPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("お手本")
                .font(.headline)
            ExemplarImageView(lesson: lesson)
                .padding(18)
                .frame(maxWidth: .infinity, minHeight: 280)
                .background(.background, in: RoundedRectangle(cornerRadius: 20))
            tips
        }
        .frame(maxWidth: .infinity)
    }

    private var practiceCanvas: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(viewModel.mode == .trace ? "なぞり書き" : "練習マス")
                    .font(.headline)
                Spacer()
                Picker("練習モード", selection: $viewModel.mode) {
                    ForEach(PracticeMode.allCases) { mode in Text(mode.title).tag(mode) }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 300)
            }

            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(.background)
                PracticeGridView()
                if viewModel.mode == .trace {
                    ExemplarOverlayView(lesson: lesson, opacity: viewModel.exemplarOpacity)
                }
                PencilCanvasView(drawing: $viewModel.drawing, controller: canvasController)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 620)
            .frame(maxWidth: .infinity)

            if viewModel.mode == .trace {
                HStack {
                    Text("お手本の濃さ")
                    Slider(value: $viewModel.exemplarOpacity, in: 0.05...0.5)
                        .accessibilityLabel("お手本の濃さ")
                }
            }

            HStack(spacing: 16) {
                Button(action: { canvasController.undo() }) {
                    Label("元に戻す", systemImage: "arrow.uturn.backward")
                }
                .disabled(!canvasController.canUndo)
                .accessibilityLabel("元に戻す")

                Button(action: { canvasController.redo() }) {
                    Label("やり直す", systemImage: "arrow.uturn.forward")
                }
                .disabled(!canvasController.canRedo)
                .accessibilityLabel("やり直す")

                Button("クリア", role: .destructive) {
                    canvasController.clear()
                    viewModel.drawing = PKDrawing()
                }
                .accessibilityLabel("キャンバスをクリア")

                Spacer()
                PrimaryButton("完了", systemImage: "checkmark", action: savePractice)
                    .frame(minWidth: 110)
                .disabled(!viewModel.hasDrawing)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var tips: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("書くポイント").font(.headline)
            ForEach(lesson.tips, id: \.self) { tip in
                Label(tip, systemImage: "checkmark.circle")
                    .font(.subheadline)
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("閉じる") { dismiss() }
        }
    }

    private func savePractice() {
        guard viewModel.hasDrawing else {
            viewModel.errorMessage = "文字を書いてから完了してください。"
            return
        }
        do {
            let record = try viewModel.save(
                using: PracticeRepository(modelContext: modelContext),
                character: lesson.character
            )
            savedRecord = record
        } catch {
            viewModel.errorMessage = "練習記録を保存できませんでした。もう一度お試しください。"
        }
    }
}
