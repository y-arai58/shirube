import SwiftData
import SwiftUI

struct HistoryView: View {
    @Query(sort: \PracticeRecord.createdAt, order: .reverse) private var records: [PracticeRecord]

    var body: some View {
        let sections = HistoryViewModel().sections(for: records)
        NavigationStack {
            Group {
                if records.isEmpty {
                    ContentUnavailableView("まだ練習記録がありません", systemImage: "pencil.line", description: Text("文字を選んで、最初の一文字を書いてみましょう。"))
                } else {
                    List {
                        ForEach(sections) { group in
                            Section(group.date.penjiSectionTitle) {
                                ForEach(group.records) { record in
                                    NavigationLink {
                                        CharacterHistoryView(character: record.character)
                                    } label: {
                                        PracticeRecordCard(record: record)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("練習の履歴")
        }
    }
}
