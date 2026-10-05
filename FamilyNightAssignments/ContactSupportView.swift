//
//  ContactSupportView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 8/3/26.
//

import SwiftUI
import MessageUI

struct SupportEmail: Identifiable {
    let id = UUID()
    let subject: String
    let body: String
}

struct ContactSupportView: View {
    
    @State private var selectedEmail: SupportEmail?
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Need Help?")
                        .font(.title2.bold())
                    
                    Text("We'd love to hear from you! Whether you've found a bug, have an idea for a new feature, or just want to share feedback, we're here to help.")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            
            Section("Support") {
                
                SupportRow(
                    title: "Email Support",
                    subtitle: "General questions or help using the app.",
                    systemImage: "envelope") {
                        selectedEmail = SupportEmail(
                            subject: "Family Night Assignments Support",
                            body: """
                            Hi Michael,
                            
                            """
                        )
                    }
                
                SupportRow(
                    title: "Report a Bug",
                    subtitle: "Something isn't working correctly?",
                    systemImage: "ladybug") {
                        selectedEmail = SupportEmail(
                            subject: "Bug Report",
                            body: """
                            Device:
                            
                            iOS Version:
                            
                            App Version:
                            
                            Describe the issue:
                            
                            Steps to reproduce:
                            
                            Expected behavior:
                            
                            Actual behavior:
                            
                            """
                        )
                    }
                
                SupportRow(
                    title: "Request a Feature",
                    subtitle: "Have an idea that would make the app better?",
                    systemImage: "lightbulb") {
                        selectedEmail = SupportEmail(
                            subject: "Feature Request",
                            body: """
                            What feature would you like to see?
                            
                            How would you use it?
                            
                            Why would it improve the app?
                            
                            """
                        )
                    }
                
                SupportRow(
                    title: "Send Feedback",
                    subtitle: "Tell us what you love or what we can improve.",
                    systemImage: "heart") {
                        selectedEmail = SupportEmail(
                            subject: "App Feedback",
                            body: """
                            I'd like to share the following feedback:
                            
                            """
                        )
                    }
            }
            
            Section("Information") {
                LabeledContent("Developer") {
                    Text("Michael Orton")
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    Text(verbatim: "mjorton22@gmail.com")
                        .foregroundStyle(Color.primary)
                        .tint(.primary)
                }
                .foregroundStyle(Color.primary)
                .tint(.primary)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedEmail = SupportEmail(
                        subject: "",
                        body: ""
                    )
                }
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = "mjorton22@gmail.com"
                    } label: {
                        Label("Copy Email Address", systemImage: "doc.on.doc")
                    }
                }
            }
        }
        .sheet(item: $selectedEmail) { email in
            MailComposeView(
                subject: email.subject,
                body: email.body
            )
        }
        .navigationTitle("Contact Support")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct SupportRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: systemImage)
                    .frame(width: 24)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct MailComposeView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss

    let subject: String
    let body: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setToRecipients(["mjorton22@gmail.com"])
        viewController.setSubject(subject)
        viewController.setMessageBody(body, isHTML: false)
        return viewController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
    }

    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        private let parent: MailComposeView

        init(_ parent: MailComposeView) {
            self.parent = parent
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            parent.dismiss()
        }
    }
}
