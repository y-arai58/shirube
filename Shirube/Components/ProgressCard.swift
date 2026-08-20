import SwiftUI

struct ProgressCard: View {
    let progress: Double
    let practicedCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ひらがなの進み具合").font(.headline)
            ProgressView(value: progress)
                .tint(.mint)
            Text("\(practicedCount) / 46 文字を練習しました")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.mint.opacity(0.12), in: RoundedRectangle(cornerRadius: 18))
        .accessibilityElement(children: .combine)
    }
}
