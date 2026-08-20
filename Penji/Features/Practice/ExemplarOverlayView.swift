import SwiftUI

struct ExemplarOverlayView: View {
    let lesson: CharacterLesson
    let opacity: Double

    var body: some View {
        Text(lesson.character)
            .font(ExemplarFont.font(size: 280))
            .foregroundStyle(.primary)
            .opacity(opacity)
            .minimumScaleFactor(0.2)
            .accessibilityLabel("お手本: \(lesson.character)")
    }
}
