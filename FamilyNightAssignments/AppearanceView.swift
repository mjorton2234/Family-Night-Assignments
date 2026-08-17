//
//  AppearanceView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 7/30/26.
//

import SwiftUI
import SwiftData

struct AppearanceView: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @Query
    private var settings: [UserSettings]
    
    var body: some View {
        Group {
            if let settings = settings.first {
                AppearanceContentView(settings: settings)
            } else {
                ProgressView()
                    .task {
                        let newSettings = UserSettings()
                        modelContext.insert(newSettings)
                        
                        try? modelContext.save()
                    }
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AppearanceContentView: View {
    @Bindable var settings: UserSettings
    
    var body: some View {
        Form {
            Section("App Theme") {
                appearanceRow(
                    title: "Match System",
                    value: "System"
                )
                
                appearanceRow(
                    title: "Light",
                    value: "Light"
                )
                
                appearanceRow(
                    title: "Dark",
                    value: "Dark"
                )
            }
            
//            Section("Background Theme") {
//                
//                HStack {
//                    Image(systemName: "sparkles")
//                        .foregroundStyle(.yellow)
//                    
//                    VStack(alignment: .leading) {
//                        Text("Coming Soon!")
//                        
//                        Text("Unlock seasonal themes and custom backgrounds with Pro.")
//                            .font(.caption)
//                            .foregroundStyle(.secondary)
//                    }
//                }
//            }
            
            Section {
                Text("""
                    Changing the app theme only affects Family Night Assignments. Selecting Match System will automatically follow your iPhone's Light or Dark Mode.
                    """)
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private func appearanceRow(title: String, value: String) -> some View {
        Button {
            settings.appearance = value
        } label: {
            HStack {
                Text(title)
                Spacer()
                
                if settings.appearance == value {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.tint)
                }
            }
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    AppearanceView()
}
