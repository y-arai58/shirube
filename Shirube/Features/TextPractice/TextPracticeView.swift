import PencilKit
import SwiftData
import SwiftUI

struct TextPracticeView: View {
    let text: String

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var drawing = PKDrawing()
    @State private var canvasController = CanvasController()
    @State private var mode: PracticeMode = .trace
    @State private var exemplarOpacity = 0.18
    @State private var errorMessage: String?
    @State private var didSave = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if mode == .free { exemplar }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(mode == .trace ? "なぞり書き" : "見て書く")
                            .font(.headline)
                        Spacer()
                        Picker("練習モード", selection: $mode) {
                            ForEach(PracticeMode.allCases) { mode in
                                Text(mode.title).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 300)
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 20).fill(.background)
                        PracticeGridView()
                        if mode == .trace {
                            guideText.opacity(exemplarOpacity)
                        }
                        PencilCanvasView(drawing: $drawing, controller: canvasController)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 720)
                    .frame(maxWidth: .infinity)

                    if mode == .trace {
                        HStack {
                            Text("お手本の濃さ")
                            Slider(value: $exemplarOpacity, in: 0.05...0.5)
                        }
                    }

                    controls
                }
            }
            .padding()
            .frame(maxWidth: 1_000)
            .frame(maxWidth: .infinity)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("文章を練習")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("閉じる") { dismiss() }
            }
        }
        .alert("保存できませんでした", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("閉じる", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
        .alert("練習を記録しました", isPresented: $didSave) {
            Button("続けて練習") { drawing = PKDrawing() }
            Button("閉じる") { dismiss() }
        } message: {
            Text("「\(text)」を履歴に保存しました。")
        }
    }

    private var exemplar: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("お手本").font(.headline)
            guideText
                .frame(maxWidth: .infinity, minHeight: 170)
                .padding()
                .background(.background, in: RoundedRectangle(cornerRadius: 20))
        }
    }

    private var guideText: some View {
        Text(text)
            .font(ExemplarFont.font(size: text.count > 12 ? 42 : 64))
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.35)
            .lineLimit(3)
            .padding(24)
            .accessibilityLabel("お手本: \(text)")
    }

    private var controls: some View {
        HStack(spacing: 16) {
            Button(action: { canvasController.undo() }) {
                Label("元に戻す", systemImage: "arrow.uturn.backward")
            }
            .disabled(!canvasController.canUndo)
            .accessibilityLabel("元に戻す")

            Button("クリア", role: .destructive) {
                canvasController.clear()
                drawing = PKDrawing()
            }
            .accessibilityLabel("キャンバスをクリア")

            Spacer()
            PrimaryButton("完了", systemImage: "checkmark", action: save)
                .frame(minWidth: 110)
                .disabled(drawing.strokes.isEmpty)
        }
    }

    private func save() {
        guard !drawing.strokes.isEmpty else {
            errorMessage = "文章を書いてから完了してください。"
            return
        }
        do {
            _ = try PracticeRepository(modelContext: modelContext).save(character: text, drawing: drawing, mode: mode)
            didSave = true
        } catch {
            errorMessage = "練習記録を保存できませんでした。もう一度お試しください。"
        }
    }
}
