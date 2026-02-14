import SwiftUI

enum Mascot {
    static let home = "Rat"
    static let workout = "Monkey"
    static let result = "Deer"
}

struct MascotSticker: View {
    let name: String
    var width: CGFloat = 140
    var opacity: Double = 0.95

    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: width)
            .opacity(opacity)
            .allowsHitTesting(false) // чтобы не мешал нажимать кнопки
    }
}
