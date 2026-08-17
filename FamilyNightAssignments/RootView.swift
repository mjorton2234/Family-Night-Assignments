//
//  RootView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 7/30/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Query
    private var settings: [UserSettings]
    
    var body: some View {
        MainTabView()
            .preferredColorScheme(settings.first?.colorScheme)
    }
}

#Preview {
    RootView()
        .modelContainer(for: UserSettings.self, inMemory: true)
}
