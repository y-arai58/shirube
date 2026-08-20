import SwiftData
import SwiftUI

struct CharacterHistoryView: View {
    let character: String
    @Query private var records: [PracticeRecord]
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    init(character: String) {
        self.character = character
        _records = Query(filter: #Predicate<PracticeRecord> { $0.character == character }, sort: \PracticeRecord.createdAt, order: .reverse)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(records) { record in
                    PracticeRecordCard(record: record, showsDate: true)
                }
            }
            .padding()
        }
        .navigationTitle("「\(character)」の練習")
    }
}
