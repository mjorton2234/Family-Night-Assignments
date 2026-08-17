//
//  FamilyNightCalendar.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 8/6/26.
//

import Foundation

struct FamilyNightCalendar {
    
    let familyNightDay: Int
    
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        return calendar
    }
    
    func currentFamilyNight(for date: Date = Date()) -> Date {
        let startOfDay = calendar.startOfDay(for: date)
        let currentWeekday = calendar.component(.weekday, from: startOfDay)
        var daysUntilFamilyNight = familyNightDay - currentWeekday
        
        if daysUntilFamilyNight < 0 {
            daysUntilFamilyNight += 7
        }
        
        return calendar.date(byAdding: .day, value: daysUntilFamilyNight, to: startOfDay) ?? startOfDay
    }
    
    func date(weekOffset: Int = 0) -> Date {
        let currentDate = currentFamilyNight()
        
        return calendar.date(byAdding: .weekOfYear, value: weekOffset, to: currentDate) ?? currentFamilyNight()
    }
    
    func weeksPassed(since date: Date) -> Int {

        let referenceDate = calendar.startOfDay(for: date)
        let currentDate = calendar.startOfDay(for: Date())
        
        let days = calendar.dateComponents([.day], from: referenceDate, to: currentDate).day ?? 0
        
        return max(0, days / 7)
    }
    
    func formattedDate(weekOffset: Int = 0) -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        
        return formatter.string(from: date(weekOffset: weekOffset))
    }
}
