import SwiftUI

struct ResultView: View {
    let totalTime: TimeInterval
    let difficulty: String
    let onDone: () -> Void

    @ObservedObject var store: ProgressStore
    @State private var applied = false   // чтобы не начислить дважды

    var body: some View {
        ZStack {
            MagicBackground()

            VStack(spacing: 18) {
                Text("Ты большая молодец!")
                    .font(.title2).bold()
                    .foregroundStyle(.white)

                Text("Сегодня ты позанималась \(formatTime(totalTime))")
                    .foregroundStyle(.white.opacity(0.9))

                Text("Твоя тренировка сегодня была \(difficulty == "hard" ? "тяжёлая" : "лёгкая")")
                    .foregroundStyle(.white.opacity(0.9))

                Divider().overlay(Color.white.opacity(0.2))
                    .padding(.vertical, 6)

                VStack(spacing: 10) {
                    if difficulty == "hard" {
                        statLine(text: "+5 к здоровью 🫀")
                        statLine(text: "+5 к привлекательности 💎")
                    } else {
                        statLine(text: "+2 к здоровью 🫀")
                        statLine(text: "+2 к привлекательности 💎")
                    }
                }

                Spacer()

                Button("Ок") {
                    applyIfNeeded()
                    onDone()
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.accent)
            }
            .padding()
        }
        .overlay(alignment: .bottomTrailing) {
            MascotSticker(name: Mascot.result, width: 150, opacity: 0.9)
                .padding(.trailing, 10)
                .padding(.bottom, 6)
        }
    }

    // MARK: - начисление результата

    private func applyIfNeeded() {
        guard !applied else { return }
        applied = true

        store.workoutsCount += 1

        let add = (difficulty == "hard") ? 5 : 2
        store.healthPoints += add
        store.beautyPoints += add
    }

    // MARK: - UI

    private func statLine(text: String) -> some View {
        Text(text)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Theme.cardStroke, lineWidth: 1)
            )
    }

    private func formatTime(_ t: TimeInterval) -> String {
        let total = Int(t)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}
