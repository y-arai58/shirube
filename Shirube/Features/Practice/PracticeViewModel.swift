import Foundation
import Observation
import PencilKit

@Observable
final class PracticeViewModel {
    var drawing = PKDrawing()
    var mode: PracticeMode = .trace
    var exemplarOpacity = 0.18
    var errorMessage: String?

    var hasDrawing: Bool { !drawing.strokes.isEmpty }

    func save(using repository: PracticeRepositoryProtocol, character: String) throws -> PracticeRecord {
        try repository.save(character: character, drawing: drawing, mode: mode)
    }
}
