//
//  AccessTokenPayload.swift
//  App
//
//  Created by Maher Santina on 7/19/19.
//

import Vapor
import JWT

struct AccessTokenPayload: JWTPayload {
    
    var issuer: IssuerClaim
    var issuedAt: IssuedAtClaim
    var expirationAt: ExpirationClaim
    var user: LoginRow.JWT
    
    init(issuer: String = "WMSAPI",
         issuedAt: Date = Date(),
         expirationAt: Date = Date().addingTimeInterval(JWTConfig.expirationTime),
         user: LoginRow.JWT) {
        self.issuer = IssuerClaim(value: issuer)
        self.issuedAt = IssuedAtClaim(value: issuedAt)
        self.expirationAt = ExpirationClaim(value: expirationAt)
        self.user = user
    }
    
    func verify(using signer: JWTSigner) throws {
        try self.expirationAt.verifyNotExpired()
    }
}
