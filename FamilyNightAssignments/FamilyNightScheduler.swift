//
//  FamilyNightScheduler.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 8/6/26.
//

import Foundation

struct FamilyNightScheduler {
    
    static func nextFamilyNight(day: Int, time: Date) -> Date {
        
        let calendar = Calendar.current
        let now = Date()
        
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        var components = DateComponents()
        components.weekday = day
        components.hour = hour
        components.minute = minute
        
        guard let next = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime
        ) else {
            return now
        }
        
        return next
    }
}
