//
//  JWTConfig.swift
//  App
//
//  Created by Maher Santina on 7/19/19.
//

import Vapor
import JWT

enum JWTConfig {
    static let signerKey = "JWT_API_SIGNER_KEY" // Key for signing JWT Access Token
    static let header = JWTHeader(alg: "HS256", typ: "JWT") // Algorithm and Type
    static let signer = JWTSigner.hs256(key: JWTConfig.signerKey) // Signer for JWT
    static let expirationTime: TimeInterval = 100000000 // In seconds
}
