import Observation
import PencilKit

@Observable
final class ReviewViewModel {
    let record: PracticeRecord
    var comparisonMode: ComparisonMode = .sideBySide
    var exemplarOpacity = 0.3

    init(record: PracticeRecord) {
        self.record = record
    }

    var drawing: PKDrawing? {
        try? PKDrawing(persistenceData: record.drawingData)
    }
}
