//
//  User_LoginRow.swift
//  App
//
//  Created by Maher Santina on 7/21/19.
//

import Vapor
import FluentMySQL
import DSCore

public struct User_LoginRow {
    
    public var User_id: UserRow.ID
    public var User_email: String
    
    public var Login_id: LoginRow.ID
    public var Login_userID: UserRow.ID
    public var Login_password: String
    public var Login_organizationID: OrganizationRow.ID?
    public var Login_roleID: LoginRow.ID

    public init(
        User_id: UserRow.ID
    , User_email: String
    , Login_id: LoginRow.ID
    , Login_userID: UserRow.ID
    , Login_password: String
    , Login_organizationID: OrganizationRow.ID?
    , Login_roleID: LoginRow.ID)
    {
        self.User_id = User_id
        self.User_email = User_email
        self.Login_id = Login_id
        self.Login_userID = Login_userID
        self.Login_password = Login_password
        self.Login_organizationID = Login_organizationID
        self.Login_roleID = Login_roleID
    }
    
    public var userRow: UserRow {
        return UserRow(id: User_id, email: User_email)
    }
    
    public var loginRow: LoginRow {
        return LoginRow(id: Login_id, userID: Login_userID, password: Login_password, organizationID: Login_organizationID, roleID: Login_roleID)
    }
    
    public var JWT: LoginRow.JWT {
        return LoginRow.JWT(userID: Login_userID, organizationID: Login_organizationID)
    }
    
    public static func find(email: String, password: String, organizationID: OrganizationRow.ID?, on conn: Container) -> Future<User_LoginRow?> {
        let parameters: [QueryParameter] = [
            DSQueryParameter(key: "User_email", operation: .equal, value: email),
            DSQueryParameter(key: "Login_password", operation: .equal, value: password),
            DSQueryParameter.from(key: "Login_organizationID", operation: .equal, value: organizationID)
        ]
        
        return User_LoginRow.query(onlyOne: true).withParameters(parameters: parameters).one(on: conn)
    }

    public static func find(email: String, organizationID: OrganizationRow.ID?, on conn: Container) -> Future<User_LoginRow?> {
        let parameters: [QueryParameter] = [
            DSQueryParameter(key: "User_email", operation: .equal, value: email),
            DSQueryParameter.from(key: "Login_organizationID", operation: .equal, value: organizationID)
        ]

        return User_LoginRow.query(onlyOne: true).withParameters(parameters: parameters).one(on: conn)
    }
}

extension User_LoginRow: TwoModelJoin {
    
    public typealias Model1 = UserRow
    public typealias Model2 = LoginRow
    
    public static var model1selectFields: [String] {
        return UserRow.CodingKeys.allCases.map{ $0.rawValue }
    }
    
    public static var model2selectFields: [String] {
        return LoginRow.CodingKeys.allCases.map{ $0.rawValue }
    }
    
    public static var join: JoinRelationship {
        return JoinRelationship(type: .inner, key1: UserRow.CodingKeys.id.rawValue, key2: LoginRow.CodingKeys.userID.rawValue)
    }
}

extension User_LoginRow: DSModelView {
    public typealias Database = MySQLDatabase
}
