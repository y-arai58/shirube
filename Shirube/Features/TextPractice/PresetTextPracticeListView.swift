import SwiftUI

struct PresetTextPracticeListView: View {
    @State private var searchText = ""

    private var categories: [PracticePhraseCategory] {
        guard !searchText.isEmpty else { return PresetPracticePhrases.categories }
        return PresetPracticePhrases.categories.compactMap { category in
            let phrases = category.phrases.filter { $0.localizedCaseInsensitiveContains(searchText) }
            guard !phrases.isEmpty else { return nil }
            return PracticePhraseCategory(title: category.title, systemImage: category.systemImage, phrases: phrases)
        }
    }

    var body: some View {
        List {
            ForEach(categories) { category in
                Section {
                    ForEach(category.phrases, id: \.self) { phrase in
                        NavigationLink {
                            TextPracticeView(text: phrase)
                        } label: {
                            Text(phrase)
                                .font(.body)
                        }
                    }
                } header: {
                    Label(category.title, systemImage: category.systemImage)
                }
            }
        }
        .navigationTitle("定型文を選ぶ")
        .searchable(text: $searchText, prompt: "定型文を検索")
    }
}
