import Foundation

struct PracticePhraseCategory: Identifiable {
    let title: String
    let systemImage: String
    let phrases: [String]

    var id: String { title }
}

enum PresetPracticePhrases {
    static let categories: [PracticePhraseCategory] = [
        PracticePhraseCategory(
            title: "日常のあいさつ",
            systemImage: "sun.max",
            phrases: [
                "おはようございます", "こんにちは", "こんばんは", "おやすみなさい",
                "いってきます", "いってらっしゃい", "ただいま", "おかえりなさい"
            ]
        ),
        PracticePhraseCategory(
            title: "お礼とお詫び",
            systemImage: "heart",
            phrases: [
                "ありがとうございます", "ありがとうございました", "心より感謝いたします", "いつもありがとうございます",
                "ご迷惑をおかけしました", "申し訳ありません", "お待たせしました", "どうぞお気遣いなく"
            ]
        ),
        PracticePhraseCategory(
            title: "仕事で使う言葉",
            systemImage: "briefcase",
            phrases: [
                "お世話になっております", "よろしくお願いいたします", "承知いたしました", "かしこまりました",
                "ご確認をお願いいたします", "お手数をおかけします", "ご連絡ありがとうございます", "引き続きよろしくお願いいたします"
            ]
        ),
        PracticePhraseCategory(
            title: "手紙と季節のことば",
            systemImage: "envelope",
            phrases: [
                "ご無沙汰しております", "お変わりありませんか", "お元気でお過ごしください", "季節の変わり目ですので",
                "ますますご健勝のことと", "心ばかりの品をお送りします", "またお会いできる日を", "今後ともよろしくお願いいたします"
            ]
        ),
        PracticePhraseCategory(
            title: "宛名と住所の練習",
            systemImage: "mappin.and.ellipse",
            phrases: [
                "〒123-4567", "東京都○○区○○一丁目二番三号", "○○県○○市○○町一丁目", "○○株式会社 御中",
                "○○部 ○○様", "山田 花子 様", "ご担当者様", "親展"
            ]
        ),
        PracticePhraseCategory(
            title: "自己紹介と署名",
            systemImage: "person.text.rectangle",
            phrases: [
                "はじめまして", "どうぞよろしくお願いいたします", "私の名前は○○です", "趣味は読書です",
                "東京都から参りました", "本日はありがとうございます", "山田 花子", "令和八年八月二十日"
            ]
        ),
        PracticePhraseCategory(
            title: "美しい字のための文",
            systemImage: "pencil.line",
            phrases: [
                "丁寧に心を込めて書く", "一文字ずつ大切に書く", "ゆっくり美しく書く", "背筋を伸ばして書く",
                "始まりと終わりを整える", "余白を生かして書く", "今日も一文字ずつ", "読みやすい字を目指す"
            ]
        )
    ]

    static var all: [String] {
        categories.flatMap(\.phrases)
    }
}
