//
//  File.swift
//  
//
//  Created by Maher Santina on 11/17/19.
//

import Foundation
import Vapor
import FluentMySQL

public protocol DSAuthDatabaseConfigurable {
    var dsAuthDatabaseHostName: String { get }
    var dsAuthDatabasePort: Int { get }
    var dsAuthDatabaseUsername: String { get }
    var dsAuthDatabasePassword: String { get }
    var dsAuthDatabaseDatabase: String { get }
    var dsAuthDatabaseTestDatabase: String { get }
}

public protocol DSAuthServerConfigurable {
    var dsAuthServerPort: Int { get }
}

public class DSAuthMain {

    let dataSource: (DSAuthDatabaseConfigurable & DSAuthServerConfigurable)

    public init(dataSource: (DSAuthDatabaseConfigurable & DSAuthServerConfigurable)) {
        self.dataSource = dataSource
    }

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
            databaseName = dataSource.dsAuthDatabaseTestDatabase
        default:
            databaseName = dataSource.dsAuthDatabaseDatabase
        }

        let mysql = MySQLDatabase(config: MySQLDatabaseConfig(
            hostname: dataSource.dsAuthDatabaseHostName,
            port: dataSource.dsAuthServerPort,
            username: dataSource.dsAuthDatabaseUsername,
            password: dataSource.dsAuthDatabasePassword,
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

        let serviceConfiguration = NIOServerConfig.default(hostname: "0.0.0.0", port: dataSource.dsAuthServerPort)
        services.register(serviceConfiguration)
    }
}
