//
//  File.swift
//  
//
//  Created by Maher Santina on 11/17/19.
//

import Foundation
import Vapor
import FluentMySQL

/// Called before your application initializes.
public func authConfigure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentProvider())
    try services.register(MySQLProvider())

    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)

    var databases = DatabasesConfig()

    var databaseName: String = ""
    switch env {
    case .testing:
        databaseName = Configuration.Database.testDatabase
    default:
        databaseName = Configuration.Database.database
    }

    let mysql = MySQLDatabase(config: MySQLDatabaseConfig(
        hostname: Configuration.Database.hostName,
        port: Configuration.Database.port,
        username: Configuration.Database.username,
        password: Configuration.Database.password,
        database: databaseName
        )
    )
    databases.add(database: mysql, as: .mysql)
    services.register(databases)


    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(migration: EnableReferencesMigration.self, database: .mysql)
    migrations.add(model: OrganizationRow.self, database: .mysql)
    migrations.add(model: UserRow.self, database: .mysql)
    migrations.add(model: RoleRow.self, database: .mysql)
    migrations.add(model: LoginRow.self, database: .mysql)
    services.register(migrations)

    let serviceConfiguration = NIOServerConfig.default(hostname: "0.0.0.0", port: Configuration.Server.port)
    services.register(serviceConfiguration)
}
