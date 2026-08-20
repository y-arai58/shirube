import Foundation

struct CharacterLesson: Identifiable, Hashable {
    let id: String
    let character: String
    let order: Int
    let tips: [String]
    let exemplarAssetName: String
}
