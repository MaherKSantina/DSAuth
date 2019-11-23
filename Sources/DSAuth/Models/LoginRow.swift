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

public struct LoginRow {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case userID
        case password
        case organizationID
        case roleID
    }
    
    public var id: Int?
    public var userID: UserRow.ID
    public var password: String
    public var organizationID: OrganizationRow.ID?
    public var roleID: RoleRow.ID

    public init(id: Int?, userID: UserRow.ID, password: String, organizationID: OrganizationRow.ID?, roleID: RoleRow.ID) {
        self.id = id
        self.userID = userID
        self.password = password
        self.organizationID = organizationID
        self.roleID = roleID
    }
    
    public struct Post: Content {
        public private(set) var email: String
        public private(set) var password: String
        public var organizationID: OrganizationRow.ID

        public init(email: String, password: String, organizationID: OrganizationRow.ID) {
            self.email = email
            self.password = password
            self.organizationID = organizationID
        }
        
//        func user(on connection: DatabaseConnectable) -> UserRow? {
//            return UserRow.query(on: connection).filter
//        }
    }
    
//    var jwt: JWT {
//        return JWT(userID: userID, organizationID: organizationID)
//    }
//
    public struct JWT: Content {
        public private(set) var userID: UserRow.ID
        public var organizationID: OrganizationRow.ID?

        public init(userID: UserRow.ID, organizationID: OrganizationRow.ID?) {
            self.userID = userID
            self.organizationID = organizationID
        }

        public func accessDto() throws -> AccessDto {
            let accessToken = try TokenHelpers.createAccessToken(from: self)
            let expiredAt = try TokenHelpers.expiredDate(of: accessToken)
            return AccessDto(accessToken: accessToken, expiredAt: expiredAt)
        }
    }
}

extension LoginRow: DSModel {
    public static func routePath() throws -> String {
        return "login"
    }

    public static var entity: String = "Login"
}
