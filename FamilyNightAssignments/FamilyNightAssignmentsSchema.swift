//
//  FamilyNightAssignmentsSchema.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 9/11/26.
//

import Foundation
import SwiftData

enum FamilyNightAssignmentsSchema {
    
    // MARK: - Version 1.0
    
    enum V1: VersionedSchema {
        static var versionIdentifier = Schema.Version(1, 0, 0)
        static var models: [any PersistentModel.Type] { [FamilyMember.self]
        }
        
        @Model
        final class FamilyMember {
            var name: String
            var assignment: String
            var avatarImageData: Data?
            var sortOrder: Int
            var createdAt: Date
            
            init(name: String, assignment: String, avatarImageData: Data? = nil, sortOrder: Int = 0, createdAt: Date = Date()) {
                self.name = name
                self.assignment = assignment
                self.avatarImageData = avatarImageData
                self.sortOrder = sortOrder
                self.createdAt = createdAt
            }
        }
    }
    
    // MARK: - Version 1.1
    
    enum V2: VersionedSchema {
        static var versionIdentifier = Schema.Version(1, 1, 0)
        static var models: [any PersistentModel.Type] { [FamilyMember.self, UserSettings.self]
        }
        
        @Model
        final class FamilyMember {
            @Attribute(.unique) var id: UUID
            
            var name: String
            var assignment: String
            var avatarImageData: Data?
            
            var sortOrder: Int
            var assignmentOrder: Int
            var createdAt: Date
            
            init(name: String, assignment: String, avatarImageData: Data? = nil, sortOrder: Int = 0, assignmentOrder: Int = 0, createdAt: Date = Date()) {
                self.id = UUID()
                self.name = name
                self.assignment = assignment
                self.avatarImageData = avatarImageData
                self.sortOrder = sortOrder
                self.assignmentOrder = assignmentOrder
                self.createdAt = createdAt
            }
        }
        
        @Model
        final class UserSettings {
            var familyNightDay: Int
            var familyNightTime: Date
            
            var appearance: String
            var notificationsEnabled: Bool
            
            init(familyNightDay: Int = 1, familyNightTime: Date = Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date()) ?? Date(), appearance: String = "System", notificationsEnabled: Bool = true) {
                self.familyNightDay = familyNightDay
                self.familyNightTime = familyNightTime
                self.appearance = appearance
                self.notificationsEnabled = notificationsEnabled
            }
        }
    }
}
