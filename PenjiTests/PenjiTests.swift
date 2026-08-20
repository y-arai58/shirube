import PencilKit
import SwiftData
import XCTest
@testable import Penji

final class PenjiTests: XCTestCase {
    func testHiraganaLessonsContain46OrderedExemplars() {
        XCTAssertEqual(HiraganaLessons.all.count, 46)
        XCTAssertEqual(HiraganaLessons.all.first?.character, "あ")
        XCTAssertEqual(HiraganaLessons.all.last?.character, "ん")
        XCTAssertEqual(HiraganaLessons.all.first?.exemplarAssetName, "hiragana_a")
    }

    func testLessonRepositoryReturnsNextLesson() {
        let repository = LessonRepository()

        XCTAssertEqual(repository.nextLesson(after: HiraganaLessons.all[0])?.character, "い")
    }

    func testHomeViewModelRecommendsFirstUnpracticedLesson() {
        let viewModel = HomeViewModel(practicedCharacters: ["あ", "い"])

        XCTAssertEqual(viewModel.recommendedLesson?.character, "う")
        XCTAssertEqual(viewModel.progress, 2.0 / 46.0, accuracy: 0.0001)
    }

    func testCharacterSelectionViewModelIdentifiesPracticedLesson() {
        let viewModel = CharacterSelectionViewModel(practicedCharacters: ["あ"])

        XCTAssertTrue(viewModel.isPracticed(HiraganaLessons.all[0]))
        XCTAssertFalse(viewModel.isPracticed(HiraganaLessons.all[1]))
    }

    func testPracticeViewModelSavesThePresentedCharacter() throws {
        let repository = CapturingPracticeRepository()
        let viewModel = PracticeViewModel()

        _ = try viewModel.save(using: repository, character: "あ")

        XCTAssertEqual(repository.savedCharacter, "あ")
    }

    @MainActor
    func testPracticeRepositorySavesAndFetchesDrawing() throws {
        let container = try ModelContainer(
            for: PracticeRecord.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let repository = PracticeRepository(modelContext: container.mainContext)
        let drawing = PKDrawing()

        let saved = try repository.save(character: "あ", drawing: drawing, mode: .trace)
        let records = try repository.records(for: "あ")

        XCTAssertEqual(records.count, 1)
        XCTAssertEqual(records.first?.id, saved.id)
        XCTAssertEqual(records.first?.practiceMode, .trace)
        XCTAssertNoThrow(try PKDrawing(persistenceData: saved.drawingData))
    }
}

private final class CapturingPracticeRepository: PracticeRepositoryProtocol {
    private(set) var savedCharacter: String?

    func save(character: String, drawing: PKDrawing, mode: PracticeMode) throws -> PracticeRecord {
        savedCharacter = character
        return PracticeRecord(character: character, drawingData: drawing.persistenceData, practiceMode: mode)
    }

    func records(for character: String) throws -> [PracticeRecord] { [] }
    func recentRecords(limit: Int) throws -> [PracticeRecord] { [] }
    func practicedCharacters() throws -> Set<String> { [] }
}
