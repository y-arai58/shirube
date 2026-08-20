import SwiftUI

struct ExemplarOverlayView: View {
    let lesson: CharacterLesson
    let opacity: Double

    var body: some View {
        ExemplarImageView(lesson: lesson)
            .opacity(opacity)
            .padding(28)
    }
}
