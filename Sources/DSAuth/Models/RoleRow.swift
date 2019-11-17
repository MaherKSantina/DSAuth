//
//  RoleRow.swift
//  App
//
//  Created by Maher Santina on 7/21/19.
//

import Vapor
import FluentMySQL
import DSCore

struct RoleRow {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
    }
    
    var id: Int?
    var name: String
}

extension RoleRow: DSModel {

    static func routePath() throws -> String {
        return "role"
    }
    
    static var entity: String = "Role"
}
