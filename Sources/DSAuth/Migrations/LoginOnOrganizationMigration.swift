//
//  File.swift
//  
//
//  Created by Maher Santina on 11/24/19.
//

import Foundation
import FluentMySQL

class LoginOnOrganizationMigration: Migration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return Database.update(LoginRow.self, on: conn) { (builder) in
            builder.reference(from: \LoginRow.organizationID, to: \OrganizationRow.id)
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return conn.future()
    }

    typealias Database = MySQLDatabase


}
