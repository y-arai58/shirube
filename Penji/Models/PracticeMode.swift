import Foundation

enum PracticeMode: String, Codable, CaseIterable, Identifiable {
    case trace
    case free

    var id: String { rawValue }

    var title: String {
        switch self {
        case .trace: "なぞり書き"
        case .free: "見て書く"
        }
    }
}
