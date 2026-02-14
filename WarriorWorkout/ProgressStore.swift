import Foundation
import Combine


final class ProgressStore: ObservableObject {
    @Published var workoutsCount: Int {
        didSet { UserDefaults.standard.set(workoutsCount, forKey: "workoutsCount") }
    }
    @Published var healthPoints: Int {
        didSet { UserDefaults.standard.set(healthPoints, forKey: "healthPoints") }
    }
    @Published var beautyPoints: Int {
        didSet { UserDefaults.standard.set(beautyPoints, forKey: "beautyPoints") }
    }

    // Для "по порядку" и "удиви меня"
    @Published var orderPointer: Int {
        didSet { UserDefaults.standard.set(orderPointer, forKey: "orderPointer") }
    }
    @Published var lastBlockId: String {
        didSet { UserDefaults.standard.set(lastBlockId, forKey: "lastBlockId") }
    }
    @Published var lastMuscleGroup: String {
        didSet { UserDefaults.standard.set(lastMuscleGroup, forKey: "lastMuscleGroup") }
    }

    init() {
        workoutsCount = UserDefaults.standard.integer(forKey: "workoutsCount")
        healthPoints = UserDefaults.standard.integer(forKey: "healthPoints")
        beautyPoints = UserDefaults.standard.integer(forKey: "beautyPoints")
        orderPointer = UserDefaults.standard.integer(forKey: "orderPointer")
        lastBlockId = UserDefaults.standard.string(forKey: "lastBlockId") ?? ""
        lastMuscleGroup = UserDefaults.standard.string(forKey: "lastMuscleGroup") ?? ""
    }

    func resetAll() {
        workoutsCount = 0
        healthPoints = 0
        beautyPoints = 0
        orderPointer = 0
        lastBlockId = ""
        lastMuscleGroup = ""
    }
}

//
//  ProgressStore.swift
//  WarriorWorkout
//
//  Created by Анна Кухтарова on 25.01.2026.
//

