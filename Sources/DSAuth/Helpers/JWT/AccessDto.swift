//
//  AccessDto.swift
//  App
//
//  Created by Maher Santina on 7/19/19.
//

import Vapor

public struct AccessDto: Content {
    public let accessToken: String
    public let expiredAt: Date
}
