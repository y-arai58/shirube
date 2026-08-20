import Foundation

protocol LessonRepositoryProtocol {
    func allLessons() -> [CharacterLesson]
    func lesson(for character: String) -> CharacterLesson?
    func nextLesson(after lesson: CharacterLesson) -> CharacterLesson?
}

final class LessonRepository: LessonRepositoryProtocol {
    func allLessons() -> [CharacterLesson] { HiraganaLessons.all }

    func lesson(for character: String) -> CharacterLesson? {
        HiraganaLessons.all.first { $0.character == character }
    }

    func nextLesson(after lesson: CharacterLesson) -> CharacterLesson? {
        HiraganaLessons.all.first { $0.order == lesson.order + 1 }
    }
}
