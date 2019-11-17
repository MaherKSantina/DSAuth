//
//  OrganizationRow.swift
//  App
//
//  Created by Maher Santina on 7/13/19.
//

import Vapor
import FluentMySQL
import DSCore

struct OrganizationRow {
    var id: Int?
    var name: String
}

extension OrganizationRow: DSModel {
    static func routePath() throws -> String {
        return "organization"
    }

    static var defaultDatabase: DatabaseIdentifier<MySQLDatabase>? = .mysql
    static var entity: String = "Organization"
}
