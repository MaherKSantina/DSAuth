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

struct UserRow: Content {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case email
    }
    
    struct Registration: Content {
        private(set) var email: String
        private(set) var password: String
    }
    
    struct Login: Content {
        var email: String
        var password: String
    }
    
    var id: Int?
    private(set) var email: String
    
}

extension UserRow: RouteNameable {
    static func routePath() throws -> String {
        return "user"
    }
}

extension UserRow: DSModel {
    static var entity: String = "User"
}
