import Foundation

enum HiraganaLessons {
    private static let characters: [(roman: String, character: String)] = [
        ("a", "あ"), ("i", "い"), ("u", "う"), ("e", "え"), ("o", "お"),
        ("ka", "か"), ("ki", "き"), ("ku", "く"), ("ke", "け"), ("ko", "こ"),
        ("sa", "さ"), ("shi", "し"), ("su", "す"), ("se", "せ"), ("so", "そ"),
        ("ta", "た"), ("chi", "ち"), ("tsu", "つ"), ("te", "て"), ("to", "と"),
        ("na", "な"), ("ni", "に"), ("nu", "ぬ"), ("ne", "ね"), ("no", "の"),
        ("ha", "は"), ("hi", "ひ"), ("fu", "ふ"), ("he", "へ"), ("ho", "ほ"),
        ("ma", "ま"), ("mi", "み"), ("mu", "む"), ("me", "め"), ("mo", "も"),
        ("ya", "や"), ("yu", "ゆ"), ("yo", "よ"), ("ra", "ら"), ("ri", "り"),
        ("ru", "る"), ("re", "れ"), ("ro", "ろ"), ("wa", "わ"), ("wo", "を"), ("n", "ん")
    ]

    static let all: [CharacterLesson] = characters.enumerated().map { index, item in
        CharacterLesson(
            id: "hiragana-\(index)",
            character: item.character,
            order: index,
            tips: defaultTips(for: item.character),
            exemplarAssetName: "hiragana_\(item.roman)"
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
