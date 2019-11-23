//
//  LoginRow.swift
//  App
//
//  Created by Maher Santina on 7/21/19.
//

import Vapor
import Fluent
import FluentMySQL
import Authentication
import JWT
import DSCore

struct LoginRow {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case userID
        case password
        case organizationID
        case roleID
    }
    
    var id: Int?
    var userID: UserRow.ID
    var password: String
    var organizationID: OrganizationRow.ID?
    var roleID: RoleRow.ID
    
    struct Post: Content {
        private(set) var email: String
        private(set) var password: String
        var organizationID: OrganizationRow.ID
        
//        func user(on connection: DatabaseConnectable) -> UserRow? {
//            return UserRow.query(on: connection).filter
//        }
    }
    
//    var jwt: JWT {
//        return JWT(userID: userID, organizationID: organizationID)
//    }
//
    struct JWT: Content {
        private(set) var userID: UserRow.ID
        var organizationID: OrganizationRow.ID?

        func accessDto() throws -> AccessDto {
            let accessToken = try TokenHelpers.createAccessToken(from: self)
            let expiredAt = try TokenHelpers.expiredDate(of: accessToken)
            return AccessDto(accessToken: accessToken, expiredAt: expiredAt)
        }
    }
}

extension LoginRow: DSModel {
    static func routePath() throws -> String {
        return "login"
    }

    static var entity: String = "Login"
}
