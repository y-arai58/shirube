import Observation
import PencilKit

@Observable
final class ReviewViewModel {
    let lesson: CharacterLesson
    let record: PracticeRecord
    var comparisonMode: ComparisonMode = .sideBySide
    var exemplarOpacity = 0.3

    init(lesson: CharacterLesson, record: PracticeRecord) {
        self.lesson = lesson
        self.record = record
    }

    var drawing: PKDrawing? {
        try? PKDrawing(persistenceData: record.drawingData)
    }
}
