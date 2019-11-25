//
//  File.swift
//  
//
//  Created by Maher Santina on 11/17/19.
//

import Foundation
import Vapor
import FluentMySQL

public class DSAuthMain {

    public func authConfigure(migrations: inout MigrationConfig) {
        migrations.add(migration: EnableReferencesMigration.self, database: .mysql)

        migrations.add(model: UserRow.self, database: .mysql)

        migrations.add(model: OrganizationRow.self, database: .mysql)

        migrations.add(model: RoleRow.self, database: .mysql)
        migrations.add(migration: RolesMigration.self, database: .mysql)

        migrations.add(model: LoginRow.self, database: .mysql)

        migrations.add(migration: LoginOnOrganizationMigration.self, database: .mysql)

        migrations.add(migration: Login_RoleRow.self, database: .mysql)
        migrations.add(migration: User_LoginRow.self, database: .mysql)

        migrations.add(migration: UniqueLoginMigration.self, database: .mysql)
    }
}
