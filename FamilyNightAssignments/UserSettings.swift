//
//  UserSettings.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 7/10/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final  class UserSettings {
    var familyNightDay: Int
    var familyNightTime: Date
    
    var appearance: String
    
    var notificationsEnabled: Bool
    
    init(
        familyNightDay: Int = 1,
        familyNightTime: Date = Calendar.current.date(
            bySettingHour: 19,
            minute: 0,
            second: 0,
            of: Date()
        ) ?? Date(),
        appearance: String = "System",
        notificationsEnabled: Bool = true
    ) {
        self.familyNightDay = familyNightDay
        self.familyNightTime = familyNightTime
        self.appearance = appearance
        self.notificationsEnabled = notificationsEnabled
    }
    
    var colorScheme: ColorScheme? {
        switch appearance {
        case "Light":
            return .light
            
        case "Dark":
            return .dark
            
        default:
            return nil
        }
    }
}
