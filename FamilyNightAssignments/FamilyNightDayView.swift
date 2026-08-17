//
//  FamilyNightDayView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 7/17/26.
//

import SwiftUI
import SwiftData

struct FamilyNightDayView: View {
    @Bindable var settings: UserSettings
    
    var body: some View {
        List {
            ForEach(FamilyNightDay.allCases) { day in
                Button {
                    settings.familyNightDay = day.rawValue
                    NotificationManager.shared.scheduleNotification(using: settings)
                } label: {
                    HStack {
                        Text(day.title)
                        
                        Spacer()
                        
                        if settings.familyNightDay == day.rawValue {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
        }
        .navigationTitle("Family Night Day")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let settings = UserSettings()
    
    NavigationStack {
        FamilyNightDayView(settings: settings)
    }
    .modelContainer(for: UserSettings.self, inMemory: true)
}
