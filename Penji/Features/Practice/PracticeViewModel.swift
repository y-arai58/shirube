import Foundation
import Observation
import PencilKit

@Observable
final class PracticeViewModel {
    let lesson: CharacterLesson
    var drawing = PKDrawing()
    var mode: PracticeMode = .trace
    var exemplarOpacity = 0.18
    var errorMessage: String?

    init(lesson: CharacterLesson) {
        self.lesson = lesson
    }

    var hasDrawing: Bool { !drawing.strokes.isEmpty }

    func save(using repository: PracticeRepositoryProtocol) throws -> PracticeRecord {
        try repository.save(character: lesson.character, drawing: drawing, mode: mode)
    }
}
