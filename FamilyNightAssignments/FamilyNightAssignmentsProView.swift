//
//  FamilyNightAssignmentsProView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 8/10/26.
//

import SwiftUI

struct FamilyNightAssignmentsProView: View {
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Get more from Family Night Assignments.")
                        .font(.headline)
                    
                    Text("Family Night Assignments Pro will unlock additional features and customization options to make Family Night even easier to organize.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            
            Section("Notifications") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Advanced Notifications & Integration")
                        .font(.headline)
                    
                    Text("Unlock advanced reminders, calendar integration, widgets, Family Sync, and other features designed to make organizing Family Night easier.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            
            Section("Background Themes") {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundStyle(.yellow)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Coming Soon!")
                        
                        Text("Unlock seasonal themes and custom backgrounds with Pro.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            
            Section {
                VStack(spacing: 8) {
                    Text("More Pro Features Coming Soon")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text("We're continuing to add new ways to make Family Night Assignments more useful for your family.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Family Night Assignments Pro")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FamilyNightAssignmentsProView()
    }
}
