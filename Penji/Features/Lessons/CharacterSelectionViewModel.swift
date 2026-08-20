import Foundation

struct CharacterSelectionViewModel {
    let lessons: [CharacterLesson]
    let practicedCharacters: Set<String>

    init(lessonRepository: LessonRepositoryProtocol = LessonRepository(), practicedCharacters: Set<String>) {
        self.lessons = lessonRepository.allLessons()
        self.practicedCharacters = practicedCharacters
    }

    func isPracticed(_ lesson: CharacterLesson) -> Bool {
        practicedCharacters.contains(lesson.character)
    }
}
