import SwiftUI
import UIKit

/// Displays the bundled Klee One exemplar image, with a font fallback if a resource is absent.
struct ExemplarImageView: View {
    let lesson: CharacterLesson

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
            } else {
                Text(lesson.character)
                    .font(ExemplarFont.font(size: 280))
                    .minimumScaleFactor(0.2)
            }
        }
        .accessibilityLabel("お手本: \(lesson.character)")
    }

    private var image: UIImage? {
        guard let url = Bundle.main.url(forResource: lesson.exemplarAssetName, withExtension: "png") else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
}
