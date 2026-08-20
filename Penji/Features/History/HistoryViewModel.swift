import Foundation

struct HistorySection: Identifiable {
    let date: Date
    let records: [PracticeRecord]

    var id: Date { date }
}

struct HistoryViewModel {
    func sections(for records: [PracticeRecord], calendar: Calendar = .current) -> [HistorySection] {
        let groups = Dictionary(grouping: records) { calendar.startOfDay(for: $0.createdAt) }
        return groups.map { date, records in
            HistorySection(date: date, records: records.sorted { $0.createdAt > $1.createdAt })
        }
        .sorted { $0.date > $1.date }
    }
}
