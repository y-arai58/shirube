import PencilKit
import SwiftUI

enum ComparisonMode: String, CaseIterable, Identifiable {
    case sideBySide
    case overlay

    var id: String { rawValue }
    var title: String { self == .sideBySide ? "並べて比較" : "重ねて比較" }
}

struct DrawingComparisonView: View {
    let lesson: CharacterLesson
    let drawing: PKDrawing
    let mode: ComparisonMode
    let exemplarOpacity: Double

    var body: some View {
        Group {
            if mode == .sideBySide {
                HStack(spacing: 16) {
                    comparisonTile(title: "お手本") { exemplar }
                    comparisonTile(title: "あなたの文字") { drawingImage }
                }
            } else {
                comparisonTile(title: "重ねて比較") {
                    ZStack {
                        exemplar.opacity(exemplarOpacity)
                        drawingImage
                    }
                }
            }
        }
    }

    private var exemplar: some View {
        Text(lesson.character)
            .font(ExemplarFont.font(size: 150))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var drawingImage: some View {
        Image(uiImage: drawing.image(from: CGRect(x: 0, y: 0, width: 600, height: 600), scale: UIScreen.main.scale))
            .resizable()
            .scaledToFit()
            .padding(18)
    }

    private func comparisonTile<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            content()
                .frame(maxWidth: .infinity, minHeight: 260)
                .background(.background, in: RoundedRectangle(cornerRadius: 18))
        }
        .frame(maxWidth: .infinity)
    }
}
