import SwiftUI

enum Theme {
    // База фона
    static let bgTop = Color(red: 0.05, green: 0.04, blue: 0.07)
    static let bgBottom = Color(red: 0.08, green: 0.02, blue: 0.05)

    // Акценты (магентовый + бирюза)
    static let accent = Color(red: 0.78, green: 0.32, blue: 0.92)
    static let accent2 = Color(red: 0.25, green: 0.86, blue: 0.84)
    static var accent1: Color { accent2 }

    static let glow = Color.white.opacity(0.12)
    static let cardStroke = Color.white.opacity(0.14)

    static func bgGradient() -> LinearGradient {
        LinearGradient(colors: [bgTop, bgBottom], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
