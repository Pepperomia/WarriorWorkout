import Foundation

final class DataLoader {
    static func loadBlocks() -> [WorkoutBlock] {
        guard let url = Bundle.main.url(forResource: "blocks", withExtension: "json") else {
            print("❌ blocks_updated.json не найден")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let blocks = try JSONDecoder().decode([WorkoutBlock].self, from: data)
            return blocks.sorted { $0.orderIndex < $1.orderIndex }
        } catch {
            print("❌ Ошибка чтения JSON: \(error)")
            return []
        }
    }
}
