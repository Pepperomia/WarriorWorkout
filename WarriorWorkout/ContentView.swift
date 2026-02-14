import SwiftUI

struct ContentView: View {
    private let blocks = DataLoader.loadBlocks()
    @StateObject private var store = ProgressStore()

    @State private var selectedBlock: WorkoutBlock?
    @State private var selectedDifficultyForResult: String = "easy"

    @AppStorage("workoutMode") private var workoutModeRaw: String = WorkoutMode.homeMin.rawValue
    private var workoutMode: WorkoutMode { WorkoutMode(rawValue: workoutModeRaw) ?? .homeMin }

    var body: some View {
        NavigationStack {
            ZStack {
                MagicBackground()

                VStack(alignment: .leading, spacing: 16) {

                    Text("Приветствую, воин!")
                        .font(.title2).bold()
                        .foregroundStyle(.white)
                    
                    Text("Блоков: \(blocks.count)")
                        .foregroundStyle(.white.opacity(0.7))
                        .font(.caption)
                    
                    // Таблетка режимов
                    GlassCard {
                        Picker("Режим", selection: $workoutModeRaw) {
                            Text("🏠➕🪢 Дом+инвентарь").tag(WorkoutMode.homeMin.rawValue)
                            Text("🏠🙌 Дом без").tag(WorkoutMode.homeNone.rawValue)
                            Text("🏋️ Зал").tag(WorkoutMode.gym.rawValue)
                        }
                        .pickerStyle(.segmented)
                    }

                    // Статус
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Твой статус:")
                                .foregroundStyle(.white).bold()

                            Text("• тренировок: \(store.workoutsCount)")
                                .foregroundStyle(.white.opacity(0.9))

                            statRow(title: "здоровье", icon: "🫀", value: store.healthPoints)
                            statRow(title: "привлекательность", icon: "💎", value: store.beautyPoints)
                        }
                        .font(.subheadline)
                    }

                    // 4 плитки
                    GlassCard {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            actionTile(title: "По порядку", icon: "list.number", emoji: "📜") { pickNextInOrder() }
                            actionTile(title: "Полегче", icon: "leaf", emoji: "🍃") { pickRandom(difficulty: "easy") }
                            actionTile(title: "Хардкор", icon: "flame", emoji: "🔥") { pickRandom(difficulty: "hard") }
                            actionTile(title: "Удиви меня", icon: "shuffle", emoji: "🎲") { pickSurprise() }
                        }
                    }

                    Spacer()

                    Button(role: .destructive) {
                        store.resetAll()
                    } label: {
                        Text("Сброс прогресса")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.white.opacity(0.9))
                }
                .padding()
            }
            .navigationDestination(item: $selectedBlock) { block in
                WorkoutView(
                    block: block,
                    selectionDifficulty: selectedDifficultyForResult,
                    store: store,
                    mode: workoutMode
                )
            }
        }
    }

    // MARK: - UI helpers

    private func statRow(title: String, icon: String, value: Int) -> some View {
        let progress = Double(value % 100) / 100.0

        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("• \(title): \(icon) \(value)")
                    .foregroundStyle(.white.opacity(0.9))
                Spacer()
            }
            ProgressView(value: progress)
                .tint(Theme.accent2.opacity(0.9))
        }
    }

    private func actionTile(title: String, icon: String, emoji: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))

                Text("\(emoji) \(title)")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, minHeight: 64)
        }
        .buttonStyle(.borderedProminent)
        .tint(Theme.accent)
    }

    // MARK: - Selection logic

    private func pickNextInOrder() {
        guard !blocks.isEmpty else { return }
        let sorted = blocks.sorted { $0.orderIndex < $1.orderIndex }

        var idx = store.orderPointer
        if idx < 0 || idx >= sorted.count { idx = 0 }

        let block = sorted[idx]
        store.orderPointer = (idx + 1) % sorted.count

        selectedDifficultyForResult = block.difficulty
        store.lastBlockId = block.blockId
        store.lastMuscleGroup = block.muscleGroup

        selectedBlock = block
    }

    private func pickRandom(difficulty: String) {
        let pool = blocks.filter { $0.difficulty == difficulty }
        guard let block = pool.randomElement() else { return }

        selectedDifficultyForResult = difficulty
        store.lastBlockId = block.blockId
        store.lastMuscleGroup = block.muscleGroup

        selectedBlock = block
    }

    private func pickSurprise() {
        guard !blocks.isEmpty else { return }

        let withoutLast = blocks.filter { $0.blockId != store.lastBlockId }
        if withoutLast.isEmpty { return }

        let targetGroup: String
        if store.lastMuscleGroup == "upper" { targetGroup = "lower" }
        else if store.lastMuscleGroup == "lower" { targetGroup = "upper" }
        else { targetGroup = "" }

        let preferred = targetGroup.isEmpty ? withoutLast : withoutLast.filter { $0.muscleGroup == targetGroup }
        let pool = preferred.isEmpty ? withoutLast : preferred

        guard let block = pool.randomElement() else { return }

        selectedDifficultyForResult = block.difficulty
        store.lastBlockId = block.blockId
        store.lastMuscleGroup = block.muscleGroup

        selectedBlock = block
    }
}
