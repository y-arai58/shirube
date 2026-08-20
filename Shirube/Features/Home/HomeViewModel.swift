import Foundation

struct HomeViewModel {
    let lessons: [CharacterLesson]
    let practicedCharacters: Set<String>

    init(lessonRepository: LessonRepositoryProtocol = LessonRepository(), practicedCharacters: Set<String>) {
        self.lessons = lessonRepository.allLessons()
        self.practicedCharacters = practicedCharacters
    }

    var recommendedLesson: CharacterLesson? {
        lessons.first { !practicedCharacters.contains($0.character) }
    }

    var progress: Double {
        guard !lessons.isEmpty else { return 0 }
        return Double(practicedCharacters.count) / Double(lessons.count)
    }
}
