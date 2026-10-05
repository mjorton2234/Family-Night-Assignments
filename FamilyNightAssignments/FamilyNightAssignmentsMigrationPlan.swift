//
//  FamilyNightAssignmentsMigrationPlan.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 9/11/26.
//

import Foundation
import SwiftData

enum FamilyNightAssignmentsMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [
            FamilyNightAssignmentsSchema.V1.self,
            FamilyNightAssignmentsSchema.V2.self
        ]
    }
    
    static var stages: [MigrationStage] {
        [
            migrateV1toV2
        ]
    }
    
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: FamilyNightAssignmentsSchema.V1.self,
        toVersion: FamilyNightAssignmentsSchema.V2.self,
        willMigrate: { context in

        },
        didMigrate: { context in
                let members = try context.fetch(
                FetchDescriptor<FamilyNightAssignmentsSchema.V2.FamilyMember>()
            )
            
            for member in members {
                member.assignmentOrder = member.sortOrder
            }
        
            try context.save()
        }
    )
}
