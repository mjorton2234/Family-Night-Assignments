//
//  FamilyNightSettingsView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 7/10/26.
//

import SwiftUI
import SwiftData
import EventKit
import EventKitUI

struct FamilyNightSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [UserSettings]

    var body: some View {
        Group {
            if let settings = settings.first {
                FamilyNightSettingsContent(settings: settings)
            } else {
                ProgressView()
                    .task {
                        let newSettings = UserSettings()
                        modelContext.insert(newSettings)
                        try? modelContext.save()
                    }
            }
        }
        .navigationTitle("Family Night")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct CalendarEventEditView: UIViewControllerRepresentable {
    let eventStore: EKEventStore
    let eventDate: Date

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        
        let viewController = EKEventEditViewController()
        viewController.eventStore = eventStore

        let event = EKEvent(eventStore: eventStore)
        event.title = "Family Night"
        event.startDate = eventDate
        event.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: eventDate) ?? eventDate
        event.notes = "Family Night"
        event.addRecurrenceRule(
            EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: nil)
        )

        viewController.event = event
        viewController.editViewDelegate = context.coordinator

        return viewController
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {
    }

    final class Coordinator: NSObject, EKEventEditViewDelegate {
        func eventEditViewController(
            _ controller: EKEventEditViewController,
            didCompleteWith action: EKEventEditViewAction
        ) {
            controller.dismiss(animated: true)
        }
    }
}

private struct FamilyNightSettingsContent: View {
    @Bindable var settings: UserSettings

    @State private var showingCalendar = false
    @State private var eventStore = EKEventStore()

    private var nextFamilyNightDate: Date {
        FamilyNightScheduler.nextFamilyNight(
            day: settings.familyNightDay,
            time: settings.familyNightTime
        )
    }

    var body: some View {
        Form {
            Section("Schedule") {
                Picker("Day", selection: $settings.familyNightDay) {
                    ForEach(FamilyNightDay.allCases) { day in
                        Text(day.title)
                            .tag(day.rawValue)
                    }
                }
                .onChange(of: settings.familyNightDay) { _, _ in
                    NotificationManager.shared.scheduleNotification(using: settings)
                }

                DatePicker(
                    "Time",
                    selection: $settings.familyNightTime,
                    displayedComponents: .hourAndMinute
                )
                .onChange(of: settings.familyNightTime) { _, _ in
                    NotificationManager.shared.scheduleNotification(using: settings)
                }
            }

            Section("Calendar") {
                Button {
                    showingCalendar = true
                } label: {
                    Label(
                        "Add Family Night to Calendar",
                        systemImage: "calendar.badge.plus")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.primary)
            }
        }
        .sheet(isPresented: $showingCalendar) {
            CalendarEventEditView(
                eventStore: eventStore,
                eventDate: nextFamilyNightDate
            )
        }
    }
}

#Preview {
    FamilyNightSettingsView()
        .modelContainer(for: UserSettings.self, inMemory: true)
}
