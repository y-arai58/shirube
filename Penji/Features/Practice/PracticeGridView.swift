import SwiftUI

struct PracticeGridView: View {
    var body: some View {
        Canvas { context, size in
            let bounds = CGRect(origin: .zero, size: size).insetBy(dx: 1, dy: 1)
            let border = Path(roundedRect: bounds, cornerRadius: 12)
            context.stroke(border, with: .color(.secondary.opacity(0.45)), lineWidth: 2)

            var guide = Path()
            guide.move(to: CGPoint(x: size.width / 2, y: 0))
            guide.addLine(to: CGPoint(x: size.width / 2, y: size.height))
            guide.move(to: CGPoint(x: 0, y: size.height / 2))
            guide.addLine(to: CGPoint(x: size.width, y: size.height / 2))
            context.stroke(guide, with: .color(.secondary.opacity(0.25)), style: StrokeStyle(lineWidth: 1.5, dash: [7, 5]))
        }
        .accessibilityHidden(true)
    }
}
