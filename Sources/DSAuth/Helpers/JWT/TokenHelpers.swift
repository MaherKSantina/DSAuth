//
//  TokenHelpers.swift
//  App
//
//  Created by Maher Santina on 7/19/19.
//

import Vapor
import JWT

class TokenHelpers {
    
    /// Create payload for Access Token
    fileprivate class func createPayload(from user: LoginRow.JWT) throws -> AccessTokenPayload {
        return AccessTokenPayload(user: user)
    }
    
    /// Create Access Token for user
    class func createAccessToken(from user: LoginRow.JWT) throws -> String {
        let payload = try TokenHelpers.createPayload(from: user)
        let header = JWTConfig.header
        let signer = JWTConfig.signer
        let jwt = JWT<AccessTokenPayload>(header: header, payload: payload)
        let tokenData = try signer.sign(jwt)
        
        if let token = String(data: tokenData, encoding: .utf8) {
            return token
        } else {
            throw JWTError.createJWT
        }
    }
    
    /// Get expiration date of token
    class func expiredDate(of token: String) throws -> Date {
        let receivedJWT = try JWT<AccessTokenPayload>(from: token, verifiedUsing: JWTConfig.signer)
        
        return receivedJWT.payload.expirationAt.value
    }
    
    /// Verify token is valid or not
    class func verifyToken(_ token: String) throws {
        do {
            let _ = try JWT<AccessTokenPayload>(from: token, verifiedUsing: JWTConfig.signer)
        } catch {
            throw JWTError.verificationFailed
        }
    }
    
    /// Get user ID from token
    class func getUser(fromPayloadOf token: String) throws -> LoginRow.JWT {
        do {
            let receivedJWT = try JWT<AccessTokenPayload>(from: token, verifiedUsing: JWTConfig.signer)
            let payload = receivedJWT.payload
            
            return payload.user
        } catch {
            throw JWTError.verificationFailed
        }
    }
}

