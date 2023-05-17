//
//  WeightTracker.swift
//  IF project
//
//  Created by Misha on 21.12.2022.
//

import UIKit

// Структура считает изменения веса юзера
struct WeightTracker {
    
    var leveling = LevelingLogic()
    
    var currentWeight: Double? {
        Double(UserDefaults.standard.string(forKey: "currentWeight") ?? "0")
    }
    private var startingWeight: Double? {
        Double(UserDefaults.standard.string(forKey: "startingWeight") ?? "NA")
    }
    var goalWeight: Double? {
        Double(UserDefaults.standard.string(forKey: "goalWeight") ?? "0")
    }
    var weightDifference: Double? {
        UserDefaults.standard.double(forKey: "stableWeightDifference")
    }
    var userUpdatedCurrentWeight: Double? {
        Double(UserDefaults.standard.string(forKey: "userUpdatedWeight") ?? String(currentWeight ?? .nan))
    }
    private var prettyPercent: String? {
        get {
            UserDefaults.standard.string(forKey: "prettyPecent")
        } set {
            UserDefaults.standard.set(newValue, forKey: "prettyPecent")
        }
    }
    private var wasGoalReached: Bool? {
        get {
            UserDefaults.standard.bool(forKey: "wasGoalReached")
        } set {
            UserDefaults.standard.set(newValue, forKey: "wasGoalReached")
        }
    }
    var currentProgress: Float = 0
    
    let toPercent = PercentageFormatter()
    
    mutating func calculateWeight() {
        let difference = (startingWeight ?? .nan) - (goalWeight ?? .nan)
        UserDefaults.standard.set(difference, forKey: "stableWeightDifference")
    }
    
    // функция обновляет данные юзера, переводит их в проценты для заполнения прогресс бара, если бар заполнен сбрасывает его и отправляет запрос добавить лвлпоинты
    mutating func updateWeight(_ progressView: UIProgressView, addLevelPointsTo levelProgressView: UIProgressView = .init(), newWeight: String, progressLabel: UILabel) {
        let updatedDifference = (startingWeight ?? .nan) - Double(newWeight)!
        let rawPercentage = updatedDifference / (weightDifference ?? .nan)
        let percentage = abs(rawPercentage)
        let prettyPercent = toPercent.format(percentage)
        self.prettyPercent = prettyPercent
        if percentage < 1 {
            progressView.setProgress(Float(percentage), animated: true)
            currentProgress = progressView.progress
            UserDefaults.standard.set(currentProgress, forKey: "goalProgress")
            // leveling.addLevelPoints(points: 0.1, progressView: levelProgressView)
        } else {
            self.prettyPercent = ""
            goalWasReached(progressView, addLevelPointsTo: levelProgressView, progressLabel: progressLabel)
        }
    }
    // сброс всего
    mutating func resetAll(_ weightProgressView: UIProgressView) {
        UserDefaults.standard.set("NA", forKey: "startingWeight")
        UserDefaults.standard.set("NA", forKey: "goalWeight")
        weightProgressView.setProgress(0, animated: true)
        currentProgress = 0
        UserDefaults.standard.set(currentProgress, forKey: "goalProgress")
        UserDefaults.standard.set("", forKey: "prettyPecent")
    }
    // цель достигнута
    mutating func goalWasReached(_ weightProgressView: UIProgressView, addLevelPointsTo levelProgressView: UIProgressView, progressLabel: UILabel) {
        wasGoalReached = true
        resetAll(weightProgressView)
        leveling.addLevelPoints(points: 0.25, progressView: levelProgressView)
    }
    // сбросить только прогресс
    mutating func resetWeightProgress(_ weightProgressView: UIProgressView) {
        weightProgressView.setProgress(0, animated: true)
        currentProgress = 0
        UserDefaults.standard.set("", forKey: "prettyPecent")
        UserDefaults.standard.set(currentProgress, forKey: "goalProgress")
    }
}
