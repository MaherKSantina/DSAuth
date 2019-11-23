//
//  File.swift
//  
//
//  Created by Maher Santina on 11/23/19.
//

import Vapor
import FluentMySQL
import Fluent

class AuthController {
//    func login(_ req: Request) throws -> Future<AccessDto> {
//        return try req.content.decode(UserRow.Login.self)
//            .flatMap{ User_LoginRow.find(email: $0.email, password: $0.password, organizationID: $0.organizationID, on: req) }
//            .unwrap(or: Abort(.notFound))
//            .map{ $0.JWT }
//            .map{ try $0.accessDto() }
//    }
}

//func authLogin(email: String, password: String, organizationID: OrganizationRow.ID) {
//    return User_Login
//    return UserRow.filter
//}

public func authRegister(user: UserRow.Register, on conn: DatabaseConnectable, container: Container) -> Future<User_LoginRow> {
    return UserRow(id: nil, email: user.email).saveIfNotExist(on: conn).flatMap { (userRow) -> EventLoopFuture<LoginRow> in
        return LoginRow(id: nil, userID: try userRow.requireID(), password: user.password, organizationID: user.organizationID, roleID: 1).save(on: conn)
    }.flatMap{ _ in return User_LoginRow.find(email: user.email, organizationID: user.organizationID, on: container) }.unwrap(or: Abort(.notFound))
}

public func authLogin(user: LoginRow.Post, on conn: Container) throws -> Future<AccessDto> {
    return User_LoginRow.find(email: user.email, password: user.password, organizationID: user.organizationID, on: conn).unwrap(or: Abort(.unauthorized)).map{ try $0.JWT.accessDto() }
}
