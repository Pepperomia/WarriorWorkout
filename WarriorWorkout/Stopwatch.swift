import Foundation
import SwiftUI
import Combine

final class Stopwatch: ObservableObject {
    @Published private(set) var elapsed: TimeInterval = 0
    @Published private(set) var isRunning: Bool = false
    @Published private(set) var hasEverStarted: Bool = false

    private var startDate: Date?
    private var cancellable: AnyCancellable?

    var formatted: String {
        let total = Int(elapsed)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
        
    }

    func start() {
        guard !isRunning else { return }
        hasEverStarted = true
        isRunning = true
        startDate = Date().addingTimeInterval(-elapsed)

        cancellable = Timer.publish(every: 0.2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, let start = self.startDate else { return }
                self.elapsed = Date().timeIntervalSince(start)
            }
    }

    func stop() {
        isRunning = false
        cancellable?.cancel()
        cancellable = nil
    }

    func reset() {
        stop()
        elapsed = 0
        startDate = nil
        hasEverStarted = false
    }
}
