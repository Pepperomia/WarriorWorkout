import Foundation

struct ExerciseModes: Codable, Hashable {
    let gym: String
    let homeMin: String
    let homeNone: String
}

struct ExampleImages: Codable, Hashable {
    let gym: [String]
    let homeMin: [String]
    let homeNone: [String]
}

extension ExampleImages {
    func forMode(_ mode: WorkoutMode) -> [String] {
        switch mode {
        case .gym: return gym
        case .homeMin: return homeMin
        case .homeNone: return homeNone
        }
    }
}

struct WorkoutBlock: Codable, Identifiable, Hashable {
    let blockId: String
    let orderIndex: Int
    let muscleGroup: String
    let difficulty: String
    let title: String
    let notes: String?
    let exercises: ExerciseModes
    let minEquipment: String?
    let exampleImages: ExampleImages?

    var id: String { blockId }
}
