//
//  EditFamilyMemberView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 8/17/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditFamilyMemberView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FamilyMember.sortOrder) private var familyMembers: [FamilyMember]
    
    let familyMember: FamilyMember
    let currentAssignment: String
    
    @State private var name: String
    @State private var selectedAssignment: String
    @State private var customAssignment: String
    @State private var isUsingCustomAssignment = false
    @State private var avatarImageData: Data?
    @FocusState private var focusedField: FamilyMemberFormField?
    
    init(familyMember: FamilyMember, currentAssignment: String) {
        self.familyMember = familyMember
        self.currentAssignment = currentAssignment
        
        let activeAssignment = currentAssignment.isEmpty ? familyMember.assignment : currentAssignment
        let isDefaultAssignment = defaultAssignments.contains(activeAssignment)
        
        _name = State(initialValue: familyMember.name)
        _selectedAssignment = State(initialValue: isDefaultAssignment ? activeAssignment : defaultAssignments[0])
        _customAssignment = State(initialValue: isDefaultAssignment ? "" : activeAssignment)
        _isUsingCustomAssignment = State(initialValue: !isDefaultAssignment)
        _avatarImageData = State(initialValue: familyMember.avatarImageData)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()

                        AvatarPickerView(imageData: $avatarImageData)

                        Spacer()
                    }
                }
                Section {
                    TextField("Family member name", text: $name)
                        .textInputAutocapitalization(.words)
                        .focused($focusedField, equals: .name)
                }
                
                Section("Assignment") {
                    AssignmentMenu(
                        selectedAssignment: $selectedAssignment,
                        customAssignment: $customAssignment,
                        isUsingCustomAssignment: $isUsingCustomAssignment,
                        unavailableAssignments: usedAssignments,
                        focusedField: $focusedField
                    )
                }
            }
            .navigationTitle("Edit Family Member")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveChanges()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .disabled(!canSave)
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    if isUsingCustomAssignment {
                        Button {
                            focusedField = .name
                        } label: {
                            Image(systemName: "chevron.up")
                        }
                        .disabled(focusedField == .name)
                        
                        Button {
                            focusedField = .customAssignment
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                        .disabled(focusedField == .customAssignment)
                    }
                    
                    Spacer()
                    
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
    }
    
    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var assignmentToSave: String {
        if isUsingCustomAssignment {
            return customAssignment.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return selectedAssignment
    }
    
    private var usedAssignments: Set<String> {
        Set(
            familyMembers
                .filter { $0.id != familyMember.id }
                .map { normalizedAssignment($0.assignment) }
        )
    }
    
    private var assignmentAlreadyUsed: Bool {
        usedAssignments.contains(normalizedAssignment(assignmentToSave))
    }
    
    private var canSave: Bool {
        !trimmedName.isEmpty && !assignmentToSave.isEmpty && !assignmentAlreadyUsed
    }
    
    private func saveChanges() {
        familyMember.name = trimmedName
        familyMember.assignment = assignmentToSave
        familyMember.avatarImageData = avatarImageData
        try? modelContext.save()
        dismiss()
    }
}

struct AddFamilyMemberView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FamilyMember.sortOrder) private var familyMembers: [FamilyMember]
    
    @State private var name = ""
    @State private var selectedAssignment = defaultAssignments[0]
    @State private var customAssignment = ""
    @State private var isUsingCustomAssignment = false
    @State private var avatarImageData: Data?
    @FocusState private var focusedField: FamilyMemberFormField?
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()

                        AvatarPickerView(imageData: $avatarImageData)

                        Spacer()
                    }
                }
                Section {
                    TextField("Family member name", text: $name)
                        .textInputAutocapitalization(.words)
                        .focused($focusedField, equals: .name)
                }
                
                Section("Assignment") {
                    AssignmentMenu(
                        selectedAssignment: $selectedAssignment,
                        customAssignment: $customAssignment,
                        isUsingCustomAssignment: $isUsingCustomAssignment,
                        unavailableAssignments: usedAssignments,
                        focusedField: $focusedField
                    )
                    
                    if assignmentAlreadyUsed {
                        Text("That assignment is already being used.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Add New Family Member")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                selectFirstAvailableAssignment()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        addFamilyMember()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .disabled(!canSave)
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    if isUsingCustomAssignment {
                        Button {
                            focusedField = .name
                        } label: {
                            Image(systemName: "chevron.up")
                        }
                        .disabled(focusedField == .name)
                        
                        Button {
                            focusedField = .customAssignment
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                        .disabled(focusedField == .customAssignment)
                    }
                    
                    Spacer()
                    
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
    }
    
    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var assignmentToSave: String {
        if isUsingCustomAssignment {
            return customAssignment.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return selectedAssignment
    }
    
    private var usedAssignments: Set<String> {
        Set(familyMembers.map { normalizedAssignment($0.assignment) })
    }
    
    private var assignmentAlreadyUsed: Bool {
        usedAssignments.contains(normalizedAssignment(assignmentToSave))
    }
    
    private var canSave: Bool {
        !trimmedName.isEmpty && !assignmentToSave.isEmpty && !assignmentAlreadyUsed
    }
    
    private func selectFirstAvailableAssignment() {
        guard usedAssignments.contains(normalizedAssignment(selectedAssignment)) else {
            return
        }
        
        if let availableAssignment = defaultAssignments.first(where: { !usedAssignments.contains(normalizedAssignment($0)) }) {
            selectedAssignment = availableAssignment
            isUsingCustomAssignment = false
        } else {
            isUsingCustomAssignment = true
        }
    }
    
    private func addFamilyMember() {
        let familyMember = FamilyMember(
            name: trimmedName,
            assignment: assignmentToSave,
            avatarImageData: avatarImageData
        )
        familyMember.sortOrder = familyMembers.count
        
        modelContext.insert(familyMember)
        try? modelContext.save()
        dismiss()
    }
}

struct AssignmentMenu: View {
    @Binding var selectedAssignment: String
    @Binding var customAssignment: String
    @Binding var isUsingCustomAssignment: Bool
    
    let unavailableAssignments: Set<String>
    let focusedField: FocusState<FamilyMemberFormField?>.Binding
    
    var body: some View {
        Menu {
            ForEach(defaultAssignments, id: \.self) { assignment in
                Button {
                    selectedAssignment = assignment
                    isUsingCustomAssignment = false
                    focusedField.wrappedValue = nil
                } label: {
                    if !isUsingCustomAssignment && selectedAssignment == assignment {
                        Label(assignment, systemImage: "checkmark")
                    } else {
                        Text(assignment)
                    }
                }
                .disabled(isUnavailable(assignment))
            }
            
            Divider()
            
            Button {
                isUsingCustomAssignment = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    focusedField.wrappedValue = .customAssignment
                }
            } label: {
                if isUsingCustomAssignment {
                    Label("Custom Assignment", systemImage: "checkmark")
                } else {
                    Label("Custom Assignment", systemImage: "plus")
                }
            }
        } label: {
            HStack {
                Text("Family Night Assignment")
                    .foregroundStyle(.primary)

                Spacer()

                Text(menuTitle)
                    .foregroundStyle(.primary)
            }
        }
        .tint(.primary)
        
        if isUsingCustomAssignment {
            TextField("Custom assignment", text: $customAssignment)
                .textInputAutocapitalization(.words)
                .focused(focusedField, equals: .customAssignment)
        }
    }
    
    private var menuTitle: String {
        if isUsingCustomAssignment {
            return customAssignment.isEmpty ? "Custom" : customAssignment
        }
        
        return selectedAssignment
    }
    
    private func isUnavailable(_ assignment: String) -> Bool {
        unavailableAssignments.contains(normalizedAssignment(assignment))
    }
}

private struct AvatarPickerView: View {

    @Binding var imageData: Data?

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showCamera = false
    @State private var showOptions = false
    @State private var showPhotoPicker = false

    var body: some View {
        VStack(spacing: 8) {
            if let imageData,
               let uiImage = UIImage(data: imageData) {

                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.largeTitle)
                    }
            }

            Button("Edit Avatar") {
                showOptions = true
            }
            .foregroundStyle(.primary)
        }
        .confirmationDialog("Select Avatar", isPresented: $showOptions) {
            Button("Take Photo") {
                showCamera = true
            }

            Button("Photo Library") {
                showPhotoPicker = true
            }

            Button("Cancel", role: .cancel) { }
        }
        .onChange(of: selectedPhoto) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhoto,
            matching: .images
        )
        .sheet(isPresented: $showCamera) {
            CameraPicker(imageData: $imageData)
        }
    }
}

private struct CameraPicker: UIViewControllerRepresentable {

    @Environment(\.dismiss) private var dismiss
    @Binding var imageData: Data?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        let parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                parent.imageData = image.jpegData(compressionQuality: 0.8)
            }

            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
