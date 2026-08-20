import Foundation
import SwiftData

@Model
final class PracticeRecord {
    @Attribute(.unique) var id: UUID
    var character: String
    var drawingData: Data
    var practiceModeRawValue: String
    var createdAt: Date

    init(character: String, drawingData: Data, practiceMode: PracticeMode, createdAt: Date = .now) {
        self.id = UUID()
        self.character = character
        self.drawingData = drawingData
        self.practiceModeRawValue = practiceMode.rawValue
        self.createdAt = createdAt
    }

    var practiceMode: PracticeMode {
        PracticeMode(rawValue: practiceModeRawValue) ?? .free
    }
}
