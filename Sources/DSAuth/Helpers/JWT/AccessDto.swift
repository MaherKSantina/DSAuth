//
//  AccessDto.swift
//  App
//
//  Created by Maher Santina on 7/19/19.
//

import Vapor

struct AccessDto: Content {
    let accessToken: String
    let expiredAt: Date
}
