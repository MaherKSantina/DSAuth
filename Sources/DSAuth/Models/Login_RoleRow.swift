//
//  Login_LoginRoleRow.swift
//  App
//
//  Created by Maher Santina on 8/3/19.
//

import Vapor
import DSCore
import FluentMySQL

struct Login_RoleRow {
    
    var Login_id: Int
    var Login_userID: UserRow.ID
    var Login_password: String
    var Login_organizationID: OrganizationRow.ID?
    var Login_roleID: RoleRow.ID
    
    var Role_id: RoleRow.ID
    var Role_name: String
    
    var loginRow: LoginRow {
        return LoginRow(id: Login_id, userID: Login_userID, password: Login_password, organizationID: Login_organizationID, roleID: Login_roleID)
    }
    
    var roleRow: RoleRow {
        return RoleRow(id: Role_id, name: Role_name)
    }
    
    var JWT: LoginRow.JWT {
        return LoginRow.JWT(userID: Login_userID, organizationID: Login_organizationID)
    }
    
    static func find(userID: UserRow.ID, organizationID: OrganizationRow.ID?, on conn: Container) -> Future<Login_RoleRow?> {
        
        let parameters = [
            DSQueryParameter(key: "Login_userID", operation: .equal, value: userID),
            DSQueryParameter.from(key: "Login_organizationID", operation: .equal, value: organizationID)
        ]
        
        return Login_RoleRow.query(onlyOne: true).withParameters(parameters: parameters).one(on: conn)
    }
}

extension Login_RoleRow: TwoModelJoin {
    typealias Model1 = LoginRow
    typealias Model2 = RoleRow
    
    static var model1selectFields: [String] {
        return LoginRow.CodingKeys.allCases.map{ $0.rawValue }
    }
    
    static var model2selectFields: [String] {
        return RoleRow.CodingKeys.allCases.map{ $0.rawValue }
    }
    
    static var join: JoinRelationship {
        return JoinRelationship(type: .inner, key1: Model1.CodingKeys.roleID.rawValue, key2: Model2.CodingKeys.id.rawValue)
    }
}

extension Login_RoleRow: DSModelView {
    typealias Database = MySQLDatabase
}

