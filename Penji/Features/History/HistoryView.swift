import SwiftData
import SwiftUI

struct HistoryView: View {
    @Query(sort: \PracticeRecord.createdAt, order: .reverse) private var records: [PracticeRecord]

    private var groupedRecords: [(date: Date, records: [PracticeRecord])] {
        let calendar = Calendar.current
        let groups = Dictionary(grouping: records) { calendar.startOfDay(for: $0.createdAt) }
        return groups.map { ($0.key, $0.value.sorted { $0.createdAt > $1.createdAt }) }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            Group {
                if records.isEmpty {
                    ContentUnavailableView("まだ練習記録がありません", systemImage: "pencil.line", description: Text("文字を選んで、最初の一文字を書いてみましょう。"))
                } else {
                    List {
                        ForEach(groupedRecords, id: \.date) { group in
                            Section(group.date.formatted(date: .long, time: .omitted)) {
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
