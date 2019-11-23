//
//  RolesMigration.swift
//  App
//
//  Created by Maher Santina on 7/21/19.
//

import Fluent
import FluentMySQL

struct RolesMigration: Migration {
    
    typealias Database = MySQLDatabase
    
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return RoleRowValue.allCases.map{ RoleRow(id: nil, name: $0.rawValue) }.save(on: conn).transform(to: ())
    }
    
    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return conn.future()
    }
}
