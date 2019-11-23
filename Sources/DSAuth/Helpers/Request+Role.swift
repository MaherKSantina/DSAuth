//
//  Request+Role.swift
//  App
//
//  Created by Maher Santina on 7/15/19.
//

import Vapor

extension Request {
    public func role() throws -> Future<RoleRowValue> {
        guard let token = http.headers[.authorization].first else {
            throw Abort(.unauthorized, reason: "No Access Token")
        }
        
        let user = try TokenHelpers.getUser(fromPayloadOf: token)
        return Login_RoleRow
            .find(userID: user.userID, organizationID: user.organizationID, on: self)
            .map{ try $0.unwrap(or: Abort(.unauthorized)) }
            .map{ try $0.role() }
        
    }
}
