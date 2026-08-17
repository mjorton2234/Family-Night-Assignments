//
//  SettingsView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 7/8/26.
//

//
//  SettingsView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 7/8/26.
//

import SwiftUI
import SwiftData
import StoreKit

struct SettingsView: View {
    
    @State private var showingPrivacyPolicy = false
    @State private var showingAbout = false
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Environment(\.requestReview)
    private var requestReview
    
    @State private var showingShareSheet = false

    var body: some View {

        NavigationStack {

            List {

                Section("General") {

                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        Label("Notifications", systemImage: "bell.badge")
                        
                    }
                    
                    NavigationLink {
                        FamilyNightSettingsView()
                    } label: {
                        Label("Family Night", systemImage: "calendar")
                    }
                    
                    NavigationLink {
                        AppearanceView()
                    } label: {
                        Label("Appearance", systemImage: "paintbrush")
                    }
                }

                Section("Support") {
                    
                    Button {
                        showingShareSheet = true
                    } label: {
                        Label("Share App", systemImage: "square.and.arrow.up")
                    }
                    .foregroundStyle(.primary)
                    
                    Button {
                        requestReview()
                        
//                        if let url = URL(string: "https://apps.apple.com/app/id6783971683?action=write-review") {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                UIApplication.shared.open(url)
//                            }
//                        }
                    } label: {
                        HStack {
                            Image(systemName: "star")
                            Text("Rate App")
                                .foregroundStyle(.primary)
                        }
                    }
                    .tint(.accentColor)

                    NavigationLink {
                        ContactSupportView()
                    } label: {
                        Label("Contact Support", systemImage: "envelope")
                    }
                }

                Section("About") {

                    Button {
                        showingPrivacyPolicy = true
                    } label: {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }

                    Button {
                        showingAbout = true
                    } label: {
                        Label("About", systemImage: "info.circle")
                    }
                }

                Section {

                    VStack(alignment: .leading, spacing: 8) {

                        HStack {

                            Image(systemName: "star.circle.fill")
                                .foregroundStyle(.yellow)

                            Text("Family Night Assignments Pro")
                                .font(.headline)
                        }

                        Text("Unlock family syncing, advanced reminders, calendar integration, premium themes, widgets, Apple Watch support, and more.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        NavigationLink {
                            FamilyNightAssignmentsProView()
                        } label: {
                            Text("Learn More")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 4)

                    }
                    .padding(.vertical, 4)

                }

            }
            .navigationTitle("Settings")
            .tint(.primary)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [
                """
                Check out Family Night Assignments!
                A simple way to organize Family Night assignments for the whole family.
                https://apps.apple.com/us/app/family-night-assignments/id6783971683
                """
                ]
            )
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: UserSettings.self, inMemory: true)
}
