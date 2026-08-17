//
//  MainTabView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 7/8/26.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    
    @Query
    private var userSettings: [UserSettings]

    var body: some View {

        TabView {

            AssignmentsView()
                .tabItem {
                    Label("Assignments",
                          systemImage: "person.3.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings",
                          systemImage: "gear")
                }
        }
        .onAppear {
            if let settings = userSettings.first {
                NotificationManager.shared.ensureNotificationIsScheduled(using: settings)
            }
        }
    }
}
#Preview {
    MainTabView()
        .modelContainer(for: [FamilyMember.self, UserSettings.self], inMemory: true)
}
