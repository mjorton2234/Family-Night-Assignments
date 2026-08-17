//
//  NotificationSettingsView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 7/9/26.
//

import SwiftUI
import UserNotifications
import SwiftData

struct NotificationSettingsView: View {
    @State private var status: UNAuthorizationStatus = .notDetermined
    @Query
    private var userSettings: [UserSettings]
    
    var body: some View {
        List {
            
            Section {
                VStack(spacing: 18) {
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 55))
                        .foregroundStyle(.orange)
                    
                    Text("""

Family Night Assignments can remind you about your upcoming Family Night assignment.

You can enable or disable notifications anytime in the Settings app.

""")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                    statusView
                    
                    Button("Open Settings") {
                        NotificationManager.shared.openSettings()
                    }
                    .buttonStyle(.borderedProminent)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
            
//            Section("Family Night Assignments Pro") {
//                Label("Multiple reminders", systemImage: "bell.and.waves.left.and.right")
//                Label("Custom reminder times", systemImage: "clock")
//                Label("Reminder day selection", systemImage: "calendar")
//                Label("Reminder for each family member", systemImage: "person.3")
//            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            NotificationManager.shared.notificationStatus { status in
                self.status = status
            }
        }
    }
    
    @ViewBuilder
    private var statusView: some View {
        switch status {
        case .authorized:
            Label("Notifications are enabled.", systemImage: "checkmark.circle.fill")
                .foregroundStyle(.green)
            
        case .denied:
            Label("Notifications are turned off.", systemImage: "xmark.circle.fill")
                .foregroundStyle(.red)
            
        case .notDetermined:
            Button("Enable Notifications") {
                Task {
                    let _ = await NotificationManager.shared.requestAuthorization()
                    
                    if let settings = userSettings.first {
                        NotificationManager.shared.scheduleNotification(
                            using: settings)
                    }
                    
                    NotificationManager.shared.notificationStatus {
                        self.status = $0
                    }
                }
            }
            .buttonStyle(.bordered)
            
        default:
            Label("Notification status unavailable.", systemImage: "questionmark.circle")
        }
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
}
