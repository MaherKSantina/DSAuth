//
//  RoleRow.swift
//  App
//
//  Created by Maher Santina on 7/21/19.
//

import Vapor
import FluentMySQL
import DSCore

public struct RoleRow {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
    }
    
    public var id: Int?
    public var name: String
}

extension RoleRow: DSModel {

    public static func routePath() throws -> String {
        return "role"
    }
    
    public static var entity: String = "Role"
}
