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
    
    public struct Registration: Content {
        public private(set) var email: String
        public private(set) var password: String

        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
    
    public struct Login: Content {
        public var email: String
        public var password: String

        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
    
    public var id: Int?
    public private(set) var email: String

    public init(id: Int?, email: String) {
        self.id = id
        self.email = email
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
