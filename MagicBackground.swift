import SwiftUI

struct MagicBackground: View {
    var body: some View {
        ZStack {
            Theme.bgGradient()
                .ignoresSafeArea()

            Blob(color: Theme.accent.opacity(0.35), x: 0.15, y: 0.20, size: 320)
            Blob(color: Theme.accent2.opacity(0.25), x: 0.85, y: 0.30, size: 300)
            Blob(color: Theme.accent.opacity(0.18), x: 0.75, y: 0.85, size: 360)

            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.12)
                .ignoresSafeArea()
        }
    }
}

private struct Blob: View {
    let color: Color
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat

    var body: some View {
        GeometryReader { geo in
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .blur(radius: 40)
                .position(x: geo.size.width * x, y: geo.size.height * y)
        }
        .ignoresSafeArea()
    }
}
