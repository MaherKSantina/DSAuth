//
//  GlobalVariables.swift
//  App
//
//  Created by Maher Santina on 12/6/18.
//

import Vapor

struct Configuration {
    struct Server {
        static let port: Int = 8079
    }
    struct Database {
        static let hostName: String = "localhost"
        static let port: Int = 3306
        static let username: String = "root"
        static let password: String = "root"
        static let database: String = "wms"
        static let testDatabase: String = "wms-test"
    }
}


