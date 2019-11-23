//
//  Role.swift
//  App
//
//  Created by Maher Santina on 7/15/19.
//

import Vapor

public enum RoleRowValue: String, CaseIterable {
    case Admin
    case OrganizationAdmin
    case OrganizationTechnician
    case OrganizationAccounting
    
    public init(id: Int) throws {
        guard id < RoleRowValue.allCases.count else {
            throw Abort(.badRequest)
        }
        self = RoleRowValue.allCases[id-1]
    }
}
