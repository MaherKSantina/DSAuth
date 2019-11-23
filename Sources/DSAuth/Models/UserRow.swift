//
//  User.swift
//  App
//
//  Created by Maher Santina on 12/29/18.
//

import Foundation
import Vapor
import Fluent
import FluentMySQL
import Authentication
import JWT
import DSCore

public struct UserRow: Content {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case email
    }

    public struct Login: Content {
        public var email: String
        public var password: String

        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }

    public struct Register: Content {
        public var email: String
        public var password: String
        public var organizationID: OrganizationRow.ID?

        public init(email: String, password: String, organizationID: OrganizationRow.ID?) {
            self.email = email
            self.password = password
            self.organizationID = organizationID
        }
    }
    
    public var id: Int?
    public private(set) var email: String

    public init(id: Int?, email: String) {
        self.id = id
        self.email = email
    }

    public func saveIfNotExist(on conn: DatabaseConnectable) -> Future<UserRow> {
        return UserRow.query(on: conn).filter(\.email == email).first().flatMap { (user) -> EventLoopFuture<UserRow> in
            guard let user = user else {
                return UserRow(id: nil, email: self.email).save(on: conn)
            }
            return conn.future(user)
        }
    }
    
}

extension UserRow: RouteNameable {
    public static func routePath() throws -> String {
        return "user"
    }
}

extension UserRow: DSModel {
    public static var entity: String = "User"
}
