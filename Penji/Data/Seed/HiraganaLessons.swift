import Foundation

enum HiraganaLessons {
    static let all: [CharacterLesson] = [
        "あ", "い", "う", "え", "お", "か", "き", "く", "け", "こ",
        "さ", "し", "す", "せ", "そ", "た", "ち", "つ", "て", "と",
        "な", "に", "ぬ", "ね", "の", "は", "ひ", "ふ", "へ", "ほ",
        "ま", "み", "む", "め", "も", "や", "ゆ", "よ", "ら", "り",
        "る", "れ", "ろ", "わ", "を", "ん"
    ].enumerated().map { index, character in
        CharacterLesson(
            id: "hiragana-\(index)",
            character: character,
            order: index,
            tips: defaultTips(for: character),
            exemplarAssetName: "hiragana_\(index)"
        )
    }

    private static func defaultTips(for character: String) -> [String] {
        switch character {
        case "あ": ["1画目は少し右上がりに", "縦線は中央より少し左", "最後の曲線を広げすぎない"]
        case "い": ["1画目は細く短く", "2画目はゆったり右へ", "最後は軽く止める"]
        default: ["マスの中心を意識しましょう", "線の始まりと終わりを丁寧に", "ゆっくり大きく書きましょう"]
        }
    }
}
