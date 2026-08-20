import SwiftUI

struct CharacterCard: View {
    let lesson: CharacterLesson
    let isPracticed: Bool
    var isRecommended = false

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                if isRecommended { Text("おすすめ").font(.caption2.bold()).foregroundStyle(.tint) }
                Spacer()
                if isPracticed { Image(systemName: "checkmark.circle.fill").foregroundStyle(.green) }
            }
            Text(lesson.character)
                .font(.system(size: isRecommended ? 100 : 46, design: .rounded))
                .frame(maxWidth: .infinity)
            if isRecommended { Text("次はこの文字").font(.subheadline).foregroundStyle(.secondary) }
        }
        .padding()
        .frame(minHeight: isRecommended ? 180 : 90)
        .background(.background, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.quaternary))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(lesson.character)\(isPracticed ? "、練習済み" : "")")
    }
}
