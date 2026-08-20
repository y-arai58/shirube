import Foundation

extension Date {
    var penjiShortTimestamp: String {
        Self.penjiTimestampFormatter.string(from: self)
    }

    var penjiSectionTitle: String {
        Self.penjiSectionFormatter.string(from: self)
    }

    private static let penjiTimestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    private static let penjiSectionFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
