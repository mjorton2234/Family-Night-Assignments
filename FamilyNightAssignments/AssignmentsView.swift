//
//  ContentView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 6/5/26.
//

import SwiftUI
import SwiftData
import UIKit
import UniformTypeIdentifiers

let defaultAssignments = [
    "🎤 Conducting",
    "🎶 Songs",
    "🙏🏼 Prayers",
    "📖 Scripture",
    "💡 Lesson",
    "🎲 Activity",
    "🍪 Treat"
]

func normalizedAssignment(_ assignment: String) -> String {
    assignment.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
}

enum FamilyMemberFormField: Hashable {
    case name
    case customAssignment
}

struct AssignmentsView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \FamilyMember.sortOrder)
    private var familyMembers: [FamilyMember]
    
    @Query
    private var userSettings: [UserSettings]
    
    @State private var weekOffset = 0
    @State private var showingAddFamilyMember = false
    @State private var editingSelection: EditMemberSelection?
    @State private var draggedMember: FamilyMember?
    
    struct EditMemberSelection: Identifiable {
        let id: UUID
        let familyMember: FamilyMember
        let currentAssignment: String

        init(familyMember: FamilyMember, currentAssignment: String) {
            self.id = familyMember.id
            self.familyMember = familyMember
            self.currentAssignment = currentAssignment
        }
    }

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Text("Family Night Assignments")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 44)

                Button {
                    showingAddFamilyMember = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .frame(width: 36, height: 36)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white.opacity(0.2)))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
                .disabled(weekOffset != 0)
            }
            .padding(.top, -10)

            HStack {
                Button {
                    weekOffset -= 1
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .frame(width: 36, height: 36)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white.opacity(0.2)))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Text(familyNightCalendar.formattedDate(weekOffset: weekOffset))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    weekOffset += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .frame(width: 36, height: 36)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white.opacity(0.2)))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.vertical)
            
            ZStack(alignment: .bottom) {
                if familyMembers.isEmpty {
                    ScrollView {
                        emptyState
                            .padding(.bottom, weekOffset == 0 ? 16 : 96)
                    }
                    .ignoresSafeArea(.container, edges: .bottom)
                } else {
                    assignmentList
                }
                
                if weekOffset != 0 {
                    thisWeekButton
                        .padding(.bottom, 12)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.top)
        .padding(.horizontal)
        .background(
            LinearGradient(
                colors: [Color(.systemGray6), Color(.systemGray5)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .sheet(isPresented: $showingAddFamilyMember) {
            AddFamilyMemberView()
        }
        .sheet(item: $editingSelection) { selection in
            EditFamilyMemberView(
                familyMember: selection.familyMember,
                currentAssignment: selection.currentAssignment
            )
        }
        .animation(.smooth, value: familyMembers.map(\.sortOrder))
        .onAppear {
            initializeSortOrdersIfNeeded()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image("FamilyNightAssignments")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text("Looks like there are no family members added. Tap the + button to add a family member and their Family Night Assignment.")
                .font(.headline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 56)
        .padding(.horizontal)
    }
    
    private var thisWeekButton: some View {
        Button {
            weekOffset = 0
        } label: {
            Text("This Week")
                .fontWeight(.semibold)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(.white.opacity(0.2), lineWidth: 1))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
    }
    
    private var assignmentList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(Array(familyMembers.enumerated()), id: \.element.id) { index, familyMember in
                    let assignment = rotatedAssignment(for: index)

                    FamilyMemberRow(
                        familyMember: familyMember,
                        assignment: assignment
                    )
                    .padding(.horizontal, 4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard weekOffset == 0 else { return }
                        editingSelection = EditMemberSelection(familyMember: familyMember, currentAssignment: assignment)
                    }
                    .contextMenu {
                        if weekOffset == 0 {
                            Button("Edit") {
                                editingSelection = EditMemberSelection(familyMember: familyMember, currentAssignment: assignment)
                            }

                            Button("Delete", role: .destructive) {
                                delete(familyMember)
                            }
                        }
                    }
                    .onDrag {
                        guard weekOffset == 0 else {
                            return NSItemProvider()
                        }
                        
                        draggedMember = familyMember
                        return NSItemProvider(object: familyMember.id.uuidString as NSString)
                    }
                    .onDrop(of: [.text], delegate: FamilyMemberDropDelegate(
                        item: familyMember,
                        familyMembers: familyMembers,
                        draggedMember: $draggedMember,
                        moveAction: moveMembers,
                        isEditingEnabled: weekOffset == 0
                    ))
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private var familyNightCalendar: FamilyNightCalendar {
        FamilyNightCalendar(familyNightDay: userSettings.first?.familyNightDay ?? 1)
    }
    
private struct FamilyMemberDropDelegate: DropDelegate {
    let item: FamilyMember
    let familyMembers: [FamilyMember]
    @Binding var draggedMember: FamilyMember?
    let moveAction: (IndexSet, Int) -> Void
    let isEditingEnabled: Bool

    func dropEntered(info: DropInfo) {
        guard isEditingEnabled else {
            return
        }
        
        guard let draggedMember,
              draggedMember.id != item.id,
              let from = familyMembers.firstIndex(where: { $0.id == draggedMember.id }),
              let to = familyMembers.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        moveAction(IndexSet(integer: from), to > from ? to + 1 : to)
    }

    func performDrop(info: DropInfo) -> Bool {
        draggedMember = nil

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        return true
    }
}

    private func rotatedAssignment(for memberIndex: Int) -> String {
        let assignments = familyMembers.map(\.assignment)
        
        guard !assignments.isEmpty else {
            return ""
        }
        
        let weeksPassed = weeksPassed() + weekOffset
        let rotatedIndex = ((memberIndex - weeksPassed) % assignments.count + assignments.count) % assignments.count
        
        return assignments[rotatedIndex]
    }

    private func delete(_ familyMember: FamilyMember) {
        withAnimation {
            modelContext.delete(familyMember)
            try? modelContext.save()
        }
    }
    
    private func moveMembers(
        from source: IndexSet,
        to destination: Int
    ) {
        var reordered = familyMembers

        reordered.move(
            fromOffsets: source,
            toOffset: destination
        )

        for (index, member) in reordered.enumerated() {
            member.sortOrder = index
        }

        Task {
            try? modelContext.save()
        }
    }
    
    private func initializeSortOrdersIfNeeded() {
        guard familyMembers.count > 1 else { return }
        let maxOrder = familyMembers.map(\.sortOrder).max() ?? 0
        guard maxOrder == 0 else { return }
        for (index, member) in familyMembers.enumerated() {
            member.sortOrder = index
        }
        try? modelContext.save()
    }
    
    private func weeksPassed() -> Int {
        guard let created = familyMembers.map(\.createdAt).min() else {
            return 0
        }
        
        return familyNightCalendar.weeksPassed(since: created)
    }
}


private struct FamilyMemberRow: View {
    let familyMember: FamilyMember
    let assignment: String
    
    var body: some View {
        HStack {
            if let imageData = familyMember.avatarImageData,
               let uiImage = UIImage(data: imageData) {

                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .clipShape(Circle())
            } else {

                Text(initials)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(avatarColor)
                    .clipShape(Circle())
            }
            
            Text(familyMember.name)
                .font(.title3)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text(assignment)
                .font(.title3)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
    
    private var initials: String {
        familyMember.name
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
            .uppercased()
    }
    
    private var avatarColor: Color {
        let colors: [Color] = [.blue, .green, .orange, .pink, .purple, .teal, .indigo]
        let index = abs(familyMember.name.hashValue) % colors.count
        
        return colors[index]
    }
}

#Preview {
    AssignmentsView()
        .modelContainer(for: FamilyMember.self, inMemory: true)
}
