import PencilKit
import SwiftUI

struct PracticeRecordCard: View {
    let record: PracticeRecord
    var showsDate = false

    private var drawing: PKDrawing? { try? PKDrawing(data: record.drawingData) }

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let drawing {
                    Image(uiImage: drawing.image(from: CGRect(x: 0, y: 0, width: 300, height: 300), scale: UIScreen.main.scale))
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "pencil.tip")
                }
            }
            .frame(width: 64, height: 64)
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text("「\(record.character)」")
                    .font(.headline)
                Text(record.practiceMode.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(record.createdAt.formatted(date: showsDate ? .abbreviated : .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}
