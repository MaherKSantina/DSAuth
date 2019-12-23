//
//  OrganizationRow.swift
//  App
//
//  Created by Maher Santina on 7/13/19.
//

import Vapor
import FluentMySQL
import DSCore

public struct OrganizationRow: MySQLModel {
    public var id: Int?
    public var name: String

    public init(id: Int?, name: String) {
        self.id = id
        self.name = name
    }
}

extension OrganizationRow: DSModel {
    public static func routePath() throws -> String {
        return "organization"
    }

    public static var defaultDatabase: DatabaseIdentifier<MySQLDatabase>? = .mysql
    public static var entity: String = "Organization"
}
