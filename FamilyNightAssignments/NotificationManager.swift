//
//  NotificationManager.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 7/9/26.
//

import Foundation
import UserNotifications
import UIKit

final class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Notification authorization failed:", error)
            return false
        }
    }
    
    func notificationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        UIApplication.shared.open(url)
    }
    
    func removeAllNotifications() {
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }
    
    func scheduleNotification(using settings: UserSettings) {
        
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["FamilyNightReminder"])
        
        let calendar = Calendar.current
        
        let familyNightHour = calendar.component(.hour, from: settings.familyNightTime)
        let familyNightMinute = calendar.component(.minute, from: settings.familyNightTime)
        
        let weekday = settings.familyNightDay
        var reminderHour: Int
        var reminderMinute: Int
        
        if familyNightHour < 10 {
            reminderHour = max(familyNightHour - 1, 0)
            reminderMinute = familyNightMinute
        } else {
            reminderHour = 10
            reminderMinute = 0
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Family Night Reminder"
        content.body = "Don't forget about Family Night today!"
        content.sound = .default
        
        var components = DateComponents()
        components.weekday = weekday
        components.hour = reminderHour
        components.minute = reminderMinute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "FamilyNightReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func ensureNotificationIsScheduled(using settings: UserSettings) {
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            
            let alreadyScheduled = requests.contains { $0.identifier == "FamilyNightReminder"
            }
            guard !alreadyScheduled else { return }
            
            DispatchQueue.main.async {
                self.scheduleNotification(using: settings)
            }
        }
    }
}
