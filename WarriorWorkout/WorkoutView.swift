import SwiftUI

struct WorkoutView: View {
    let block: WorkoutBlock
    let selectionDifficulty: String
    @ObservedObject var store: ProgressStore
    let mode: WorkoutMode

    @Environment(\.dismiss) private var dismiss

    @StateObject private var mainTimer = Stopwatch()
    @StateObject private var restTimer = Stopwatch()

    @State private var showExamples = false
    @State private var showResult = false

    private var exercisesText: String {
        switch mode {
        case .gym: return block.exercises.gym
        case .homeMin: return block.exercises.homeMin
        case .homeNone: return block.exercises.homeNone
        }
    }

    private var exampleImageNames: [String] {
        // Метод forMode должен быть в ExampleImages (мы его добавляли).
        // Если у тебя его нет, скажи, я дам кусок WorkoutBlock.swift.
        block.exampleImages?.forMode(mode) ?? []
    }

    var body: some View {
        ZStack {
            MagicBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {

                    // MARK: Таймеры
                    GlassCard {
                        VStack(spacing: 10) {

                            // Общий таймер
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("⏱ Тренировка")
                                        .foregroundStyle(.white.opacity(0.9))
                                    Text(mainTimer.formatted)
                                        .font(.title2).bold()
                                        .foregroundStyle(.white)
                                }

                                Spacer()

                                Button(mainTimer.isRunning ? "Стоп" : "Поехали") {
                                    if mainTimer.isRunning {
                                        mainTimer.stop()
                                    } else {
                                        mainTimer.start()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Theme.accent1) // если Theme.accent1 нет — скажи, подправим Theme
                            }

                            Divider().opacity(0.2)

                            // Таймер отдыха
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("🛟 Отдых")
                                        .foregroundStyle(.white.opacity(0.9))
                                    Text(restTimer.formatted)
                                        .font(.title3).bold()
                                        .foregroundStyle(.white)
                                }

                                Spacer()

                                Button(restTimer.isRunning ? "Стоп" : "Старт") {
                                    if restTimer.isRunning {
                                        restTimer.stop()
                                        restTimer.reset()   // стоп + сброс до нуля
                                    } else {
                                        restTimer.start()
                                    }
                                }
                                .buttonStyle(.bordered)
                                .tint(.white.opacity(0.9))
                            }
                        }
                    }

                    // MARK: Заголовок блока
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(block.title)
                                .font(.headline)
                                .foregroundStyle(.white)

                            let groupText = (block.muscleGroup == "upper") ? "верх" : "низ"
                            let diffText = (block.difficulty == "hard") ? "тяжёлая" : "лёгкая"

                            Text("Группа: \(groupText) • \(diffText)")
                                .foregroundStyle(.white.opacity(0.8))
                                .font(.subheadline)
                        }
                    }

                    // MARK: Инвентарь
                    if mode != .gym,
                       let eq = block.minEquipment,
                       !eq.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        GlassCard {
                            Text("Минимальный инвентарь: \(eq)")
                                .foregroundStyle(.white.opacity(0.9))
                        }
                    }

                    // MARK: Заметки
                    if !((block.notes ?? "").trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty {
                        GlassCard {
                            Text(block.notes ?? "")
                                .foregroundStyle(.white.opacity(0.9))
                        }
                    }

                    // MARK: Упражнения
                    GlassCard {
                        Text(exercisesText)
                            .foregroundStyle(.white.opacity(0.95))
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // MARK: Примеры
                    GlassCard {
                        Button {
                            showExamples = true
                        } label: {
                            HStack {
                                Text("Показать примеры")
                                Spacer()
                                Image(systemName: "photo.on.rectangle.angled")
                            }
                            .foregroundStyle(.white)
                        }
                    }
                    .disabled(exampleImageNames.isEmpty)
                    .opacity(exampleImageNames.isEmpty ? 0.5 : 1)

                    // MARK: Завершение тренировки
                    Button {
                        mainTimer.stop()
                        restTimer.stop()
                        showResult = true
                    } label: {
                        Text("Вот и всё!")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.accent2)
                    .disabled(!mainTimer.hasEverStarted)

                    Spacer(minLength: 16)
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)

        // Примеры
        .sheet(isPresented: $showExamples) {
            ExamplesView(imageNames: exampleImageNames)
        }

        // Результат
        .sheet(isPresented: $showResult) {
            ResultView(
                totalTime: mainTimer.elapsed,
                difficulty: selectionDifficulty,
                onDone: {
                    showResult = false
                    dismiss()
                },
                store: store
            )
        }

        .onDisappear {
            // чтобы таймеры не продолжали тикать, если ушли назад
            mainTimer.stop()
            restTimer.stop()
        }
    }
}
