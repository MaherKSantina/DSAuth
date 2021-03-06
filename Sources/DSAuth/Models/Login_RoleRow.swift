//
//  Login_LoginRoleRow.swift
//  App
//
//  Created by Maher Santina on 8/3/19.
//

import Vapor
import DSCore
import FluentMySQL

public struct Login_RoleRow {
    
    public var Login_id: Int
    public var Login_userID: UserRow.ID
    public var Login_password: String
    public var Login_organizationID: OrganizationRow.ID?
    public var Login_roleID: RoleRow.ID
    
    public var Role_id: RoleRow.ID
    public var Role_name: String

    public init(Login_id: Int, Login_userID: UserRow.ID, Login_password: String, Login_organizationID: OrganizationRow.ID?, Login_roleID: RoleRow.ID, Role_id: RoleRow.ID, Role_name: String) {
        self.Login_id = Login_id
        self.Login_userID = Login_userID
        self.Login_password = Login_password
        self.Login_organizationID = Login_organizationID
        self.Login_roleID = Login_roleID
        self.Role_id = Role_id
        self.Role_name = Role_name
    }

    public func role() throws -> RoleRowValue {
        return try RoleRowValue(id: Role_id)
    }
    
    public var loginRow: LoginRow {
        return LoginRow(id: Login_id, userID: Login_userID, password: Login_password, organizationID: Login_organizationID, roleID: Login_roleID)
    }
    
    public var roleRow: RoleRow {
        return RoleRow(id: Role_id, name: Role_name)
    }
    
    public var JWT: LoginRow.JWT {
        return LoginRow.JWT(userID: Login_userID, organizationID: Login_organizationID)
    }
}

extension Login_RoleRow: DSTwoModelView {
    public static var entity: String {
        return tableName
    }

    public typealias Model1 = LoginRow
    public typealias Model2 = RoleRow
    
    public static var model1selectFields: [String] {
        return LoginRow.CodingKeys.allCases.map{ $0.rawValue }
    }
    
    public static var model2selectFields: [String] {
        return RoleRow.CodingKeys.allCases.map{ $0.rawValue }
    }
    
    public static var join: DSJoinRelationship {
        return DSJoinRelationship(type: .inner, key1: Model1.CodingKeys.roleID.rawValue, key2: Model2.CodingKeys.id.rawValue)
    }
}

