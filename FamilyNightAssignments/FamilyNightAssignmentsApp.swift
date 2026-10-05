//
//  FamilyNightAssignmentsApp.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 6/5/26.
//

import SwiftUI
import SwiftData

@main
struct FamilyNightAssignmentsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema(versionedSchema: FamilyNightAssignmentsSchema.V2.self)
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, migrationPlan: FamilyNightAssignmentsMigrationPlan.self, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
