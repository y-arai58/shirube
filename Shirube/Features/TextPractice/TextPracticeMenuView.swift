import SwiftUI

/// Personal practice text is stored only in the device's local app storage.
struct TextPracticeMenuView: View {
    @AppStorage("personalPracticeName") private var name = ""
    @AppStorage("personalPracticeAddress") private var address = ""
    @State private var freeText = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("定型文") {
                    NavigationLink {
                        PresetTextPracticeListView()
                    } label: {
                        Label("定型文から選ぶ", systemImage: "text.book.closed")
                    }
                    Text("日常・仕事・手紙・宛名など、\(PresetPracticePhrases.all.count)文を用意しています。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("よく書く言葉") {
                    TextField("例：山田 花子", text: $name)
                        .textInputAutocapitalization(.never)
                        .accessibilityLabel("練習する名前")
                    practiceLink(text: name, title: "この名前を練習する", icon: "person")

                    TextField("例：東京都○○区…", text: $address, axis: .vertical)
                        .lineLimit(1...3)
                        .accessibilityLabel("練習する住所")
                    practiceLink(text: address, title: "この住所を練習する", icon: "house")
                }

                Section("自由入力") {
                    TextField("練習したい文章を入力", text: $freeText, axis: .vertical)
                        .lineLimit(1...4)
                        .accessibilityLabel("自由入力の練習文")
                    practiceLink(text: freeText, title: "この文章を練習する", icon: "pencil.line")
                }

                Section {
                    Label("名前と住所は、このiPad内にだけ保存されます。", systemImage: "lock")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("文章を練習")
        }
    }

    @ViewBuilder
    private func practiceLink(text: String, title: String, icon: String) -> some View {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.isEmpty {
            Label(title, systemImage: icon)
                .foregroundStyle(.tertiary)
        } else {
            NavigationLink {
                TextPracticeView(text: trimmedText)
            } label: {
                Label(title, systemImage: icon)
            }
        }
    }
}
