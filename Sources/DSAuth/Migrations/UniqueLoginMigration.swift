//
//  File.swift
//  
//
//  Created by Maher Santina on 11/24/19.
//

import FluentMySQL
import Vapor

struct UniqueLoginMigration: Migration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return Database.update(LoginRow.self, on: conn) { (builder) in
            builder.unique(on: \LoginRow.userID, \LoginRow.organizationID)
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return conn.future()
    }

    typealias Database = MySQLDatabase


}
