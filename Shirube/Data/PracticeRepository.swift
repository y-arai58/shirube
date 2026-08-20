import Foundation
import PencilKit
import SwiftData

protocol PracticeRepositoryProtocol {
    func save(character: String, drawing: PKDrawing, mode: PracticeMode) throws -> PracticeRecord
    func records(for character: String) throws -> [PracticeRecord]
    func recentRecords(limit: Int) throws -> [PracticeRecord]
    func practicedCharacters() throws -> Set<String>
}

final class PracticeRepository: PracticeRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(character: String, drawing: PKDrawing, mode: PracticeMode) throws -> PracticeRecord {
        let record = PracticeRecord(character: character, drawingData: drawing.persistenceData, practiceMode: mode)
        modelContext.insert(record)
        try modelContext.save()
        return record
    }

    func records(for character: String) throws -> [PracticeRecord] {
        let descriptor = FetchDescriptor<PracticeRecord>(
            predicate: #Predicate { $0.character == character },
            sortBy: [SortDescriptor(\PracticeRecord.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func recentRecords(limit: Int) throws -> [PracticeRecord] {
        var descriptor = FetchDescriptor<PracticeRecord>(sortBy: [SortDescriptor(\PracticeRecord.createdAt, order: .reverse)])
        descriptor.fetchLimit = limit
        return try modelContext.fetch(descriptor)
    }

    func practicedCharacters() throws -> Set<String> {
        Set(try modelContext.fetch(FetchDescriptor<PracticeRecord>()).map(\.character))
    }
}
