import SwiftUI

enum ExemplarFont {
    static let postScriptName = "KleeOne-SemiBold"

    static func font(size: CGFloat) -> Font {
        .custom(postScriptName, size: size)
    }
}
