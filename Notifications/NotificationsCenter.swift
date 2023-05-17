//
//  NotificationsCenter.swift
//  IF project
//
//  Created by Misha on 18.01.2023.
//

import UIKit
import UserNotifications

class NotificationsCenter {
    private var isOneHourBeforeEatingNotificationGranted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isOneHourBeforeEatingNotificationGranted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isOneHourBeforeEatingNotificationGranted")
        }
    }
    private var isEatingTimeStartNotificationGranted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isEatingTimeStartNotificationGranted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isEatingTimeStartNotificationGranted")
        }
    }
    private var isOneHourBeforeFastingNotificationGranted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isOneHourBeforeFastingNotificationGranted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isOneHourBeforeFastingNotificationGranted")
        }
    }
    private var isFastingTimeStartNotificationGranted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isFastingTimeStartNotificationGranted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isFastingTimeStartNotificationGranted")
        }
    }
    private var isWaterReminderNotificationGranted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isWaterReminderNotificationGranted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isWaterReminderNotificationGranted")
        }
    }
    private var isChallengeUpdateNotificationGranted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallengeUpdateNotificationGranted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallengeUpdateNotificationGranted")
        }
    }
    private var firstFastingHour: Date? {
        get {
            UserDefaults.standard.object(forKey: "firstFastingHour") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "firstFastingHour")
        }
    }
    private var lastFastingHour: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastFastingHour") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "lastFastingHour")
        }
    }
    private var challengeStartDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "challengeStartDate") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "challengeStartDate")
        }
    }
    
    let center = UNUserNotificationCenter.current()
    
    func checkAuthorizationStatus() {
        center.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                self.scheduleNotifications()
            case .notDetermined:
                self.requestNotificationAuthorization()
            case .denied:
                break
            case .provisional:
                print("provisional")
            case .ephemeral:
                print("ephemeral")
            @unknown default:
                print("default")
            }
        }
    }
    
    func getCurrentNotifications() {
        center.getPendingNotificationRequests { (requests) in
            for request in requests {
                print("REQUEST")
                print(request)
            }
        }
    }
    
    func scheduleNotifications() {
        if isOneHourBeforeEatingNotificationGranted == true {
            sendOneHourBeforeEatingNotification()
        }
        
        if isEatingTimeStartNotificationGranted == true {
            sendEatingTimeStartNotification()
        }
        
        if isOneHourBeforeFastingNotificationGranted == true {
            sendOneHourBeforeFastingNotification()
        }
        
        if isFastingTimeStartNotificationGranted == true {
            sendFastingTimeStartNotification()
        }
        
        if isWaterReminderNotificationGranted == true {
            sendWaterReminderNotification()
        }
    }
    
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.center.requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Authorization request error: \(error)")
            }
            
            if granted == true {
                self.isOneHourBeforeEatingNotificationGranted = true
                self.isEatingTimeStartNotificationGranted = true
                self.isOneHourBeforeFastingNotificationGranted = true
                self.isFastingTimeStartNotificationGranted = true
                self.isWaterReminderNotificationGranted = true
                self.isChallengeUpdateNotificationGranted = true
            } else if granted == false {
                self.isOneHourBeforeEatingNotificationGranted = false
                self.isEatingTimeStartNotificationGranted = false
                self.isOneHourBeforeFastingNotificationGranted = false
                self.isFastingTimeStartNotificationGranted = false
                self.isWaterReminderNotificationGranted = false
                self.isChallengeUpdateNotificationGranted = false
            }
        }
    }
    
    func sendOneHourBeforeEatingNotification() {
        if let lastHour = lastFastingHour {
            let content = UNMutableNotificationContent()
            
            content.title = "1 hour of fasting left!"
            content.body = "Already cooking?"
            content.badge = 0
            
            if let notificationDate = Calendar.current.date(byAdding: .hour, value: -1, to: lastHour) {
                
                let fire = Calendar.current.dateComponents([.hour, .minute, .second], from: notificationDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: fire, repeats: true)
                
                let request = UNNotificationRequest(identifier: "oneHourBeforeEating", content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("Error adding request to NotificationsCenter(oneHourBeforeEating): \(error)")
                    }
                }
            }
        }
    }
    
    func sendEatingTimeStartNotification() {
        if let lastHour = lastFastingHour {
            let content = UNMutableNotificationContent()
            
            content.title = "Eating time!"
            content.body = "Hope you've prepared something tasty :)"
            content.badge = 0
            
            let fire = Calendar.current.dateComponents([.hour, .minute, .second], from: lastHour)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: fire, repeats: true)
            
            let request = UNNotificationRequest(identifier: "eatingTimeStart", content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Error adding request to NotificationsCenter (eatingTimeStart): \(error)")
                }
            }
        }
    }
    
    func sendOneHourBeforeFastingNotification() {
        if let firstHour = firstFastingHour {
            let content = UNMutableNotificationContent()
            
            content.title = "1 hour of eating left!"
            content.body = "Stay in your schedule :)"
            content.badge = 0
            
            if let notificationDate = Calendar.current.date(byAdding: .hour, value: -1, to: firstHour) {
                
                let fire = Calendar.current.dateComponents([.hour, .minute, .second], from: notificationDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: fire, repeats: true)
                
                let request = UNNotificationRequest(identifier: "oneHourBeforeFasting", content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("Error adding request to NotificationsCenter (oneHourBeforeFasting): \(error)")
                    }
                }
            }
        }
    }
    
    func sendFastingTimeStartNotification() {
        if let firstHour = firstFastingHour {
            let content = UNMutableNotificationContent()
            
            content.title = "Fasting starts now!"
            content.body = "Time to complete your daily goal :)"
            content.badge = 0
            
            let fire = Calendar.current.dateComponents([.hour, .minute, .second], from: firstHour)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: fire, repeats: true)
            
            let request = UNNotificationRequest(identifier: "fastingTimeStart", content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Error adding request to NotificationsCenter (fastingTimeStart): \(error)")
                }
            }
        }
    }
    
    func sendWaterReminderNotification() {
        if let firstHour = firstFastingHour {
            let content = UNMutableNotificationContent()
            
            content.title = "Hi! It's your daily water reminder"
            content.body = "Turn off this notification in settings if you don't want it :)"
            content.badge = 0
            
            if let notificationDate = Calendar.current.date(byAdding: .hour, value: -5, to: firstHour) {
                
                let fire = Calendar.current.dateComponents([.hour, .minute, .second], from: notificationDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: fire, repeats: true)
                
                let request = UNNotificationRequest(identifier: "waterReminder", content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("Error adding request to NotificationsCenter (waterReminder): \(error)")
                    }
                }
            }
        }
    }
    
    func sendChallengeUpdateNotification(challengeName: String, challengeStartDate: DateComponents, challengeID: Int) {
        let content = UNMutableNotificationContent()
        
        content.title = "\(challengeName) is done!"
        content.body = "Great job! Take a break or try another one :)"
        content.badge = 0
        
        let fire = challengeStartDate
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: fire, repeats: true)
        
        let request = UNNotificationRequest(identifier: "challenge\(challengeID)Update", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error adding request to NotificationsCenter (challengeUpdate): \(error)")
            }
        }
    }
}
