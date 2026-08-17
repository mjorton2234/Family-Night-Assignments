//
//  FamilyMember.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 6/6/26.
//

import Foundation
import SwiftData

@Model
final class FamilyMember {
    @Attribute(.unique) var id: UUID

    var name: String
    var assignment: String

    @Attribute(.externalStorage)
    var avatarImageData: Data?

    var sortOrder: Int
    var createdAt: Date

    init(
        name: String,
        assignment: String,
        avatarImageData: Data? = nil,
        sortOrder: Int = 0,
        createdAt: Date = Date()
    ) {
        self.id = UUID()
        self.name = name
        self.assignment = assignment
        self.avatarImageData = avatarImageData
        self.sortOrder = sortOrder
        self.createdAt = createdAt
    }
}
