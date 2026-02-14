import SwiftUI

struct ExamplesView: View {
    let imageNames: [String]
    @Environment(\.dismiss) private var dismiss

    private var cleanedNames: [String] {
        imageNames
            .flatMap { raw in
                raw.components(separatedBy: CharacterSet(charactersIn: "\n,;"))
            }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        ZStack {
            MagicBackground()

            VStack(spacing: 14) {
                HStack {
                    Text("Примеры")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Spacer()
                    Button("Закрыть") { dismiss() }
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(.horizontal)

                if cleanedNames.isEmpty {
                    // Заглушка
                    GlassCard {
                        VStack(spacing: 12) {
                            Text("😼 А тут догадайся сама")
                                .font(.title3).bold()
                                .foregroundStyle(.white)

                            Text("Иногда лучший пример — твоя фантазия и правильная техника.")
                                .foregroundStyle(.white.opacity(0.9))
                                .multilineTextAlignment(.center)

                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 64))
                                .foregroundStyle(.white.opacity(0.9))
                                .padding(.top, 6)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    }
                    .padding()
                } else {
                    // Нормальные картинки
                    TabView {
                        ForEach(cleanedNames, id: \.self) { name in
                            ExampleCard(imageName: name)
                                .padding()
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                }
            }
            .padding(.top, 12)
        }
    }
}

private struct ExampleCard: View {
    let imageName: String

    var body: some View {
        GlassCard {
            VStack(spacing: 10) {
                // Если ассет не найден — тоже покажем заглушку, а не черноту
                if UIImage(named: stripExtension(imageName)) != nil {
                    Image(stripExtension(imageName))
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                } else {
                    VStack(spacing: 10) {
                        Text("😺 Картинка убежала")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text("Название: \(imageName)")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                        Image(systemName: "photo.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity, minHeight: 260)
                }
            }
        }
    }

    private func stripExtension(_ s: String) -> String {
        if let dot = s.lastIndex(of: ".") {
            return String(s[..<dot])
        }
        return s
    }
}
