import XCTest
@testable import DSAuth
import FluentMySQL

final class DSAuthTests: WMSTestCase {
    func testLogin_ShouldLoginProperly() throws {
        let user1 = try UserRow(id: nil, email: "user1@gmail.com").save(on: conn).wait()
        let user2 = try UserRow(id: nil, email: "user2@gmail.com").save(on: conn).wait()
        let org = try OrganizationRow(id: nil, name: "Org 1").save(on: conn).wait()
        let _ = try LoginRow(id: nil, userID: try user1.requireID(), password: "asdfgh", organizationID: try org.requireID(), roleID: RoleRowValue.Admin.index!).save(on: conn).wait()
        let _ = try LoginRow(id: nil, userID: try user2.requireID(), password: "123456", organizationID: nil, roleID: RoleRowValue.Admin.index!).save(on: conn).wait()

        let login1 = try User_LoginRow.find(email: "user1@gmail.com", password: "asdfgh", organizationID: 1, on: app).wait()
        XCTAssertNotNil(login1)

        let login2 = try User_LoginRow.find(email: "user1@gmail.com", password: "asdfgh", organizationID: nil, on: app).wait()
        XCTAssertNil(login2)

        let login3 = try User_LoginRow.find(email: "user2@gmail.com", password: "123456", organizationID: nil, on: app).wait()
        XCTAssertNotNil(login3)
    }

    func testRegister_NewUser_NewLogin_OrganizationDoesntExist_ShouldShowError() throws {
        do {
            let _ = try DSAuthMain.register(user: UserRow.Register(email: "maher.santina90@gmail.com", password: "123456", organizationID: 1), on: conn, container: app).wait()
            XCTFail()
        }
        catch {
            guard let e = error as? MySQLError else { XCTFail(); return }
            XCTAssertEqual(e.identifier, "server (1452)")
        }

    }

    func testRegister_NewUser_NewLogin_OrganizationExists_ShouldRegisterProperly() throws {
        let org = try OrganizationRow(id: nil, name: "Org 1").save(on: conn).wait()
        let _ = try DSAuthMain.register(user: UserRow.Register(email: "maher.santina90@gmail.com", password: "123456", organizationID: try org.requireID()), on: conn, container: app).wait()
    }

    func testRegister_ExistingUser_NewLogin_ShouldRegisterProperly() throws {
        let org = try OrganizationRow(id: nil, name: "Org 1").save(on: conn).wait()
        let _ = try UserRow(id: nil, email: "maher.santina90@gmail.com").save(on: conn).wait()
        let newUser = UserRow.Register(email: "maher.santina90@gmail.com", password: "123123", organizationID: try org.requireID())
        let _ = try DSAuthMain.register(user: newUser, on: conn, container: app).wait()
        let users = try UserRow.query(on: conn).all().wait()
        XCTAssertEqual(users.count, 1)
        let logins = try LoginRow.query(on: conn).all().wait()
        XCTAssertEqual(logins.count, 1)
    }

    func testRegister_ExistingUser_ExistingLogin_ShouldShowError() throws {
        do {
        let org = try OrganizationRow(id: nil, name: "Org 1").save(on: conn).wait()
        let user = try UserRow(id: nil, email: "maher.santina90@gmail.com").save(on: conn).wait()
        let _ = try LoginRow(id: nil, userID: try user.requireID(), password: "123123", organizationID: try org.requireID(), roleID: 1).save(on: conn).wait()

        let newUser = UserRow.Register(email: "maher.santina90@gmail.com", password: "123123", organizationID: try org.requireID())
        let _ = try DSAuthMain.register(user: newUser, on: conn, container: app).wait()
        }
        catch {
            let e = error as! MySQLError
            XCTAssertEqual(e.identifier, "server (1062)")
        }
    }

    func testConvertAccessDto_ShouldConvertProperly() throws {
        let org = try OrganizationRow(id: nil, name: "Org 1").save(on: conn).wait()
        let user = try UserRow(id: nil, email: "maher.santina90@gmail.com").save(on: conn).wait()
        let _ = try LoginRow(id: nil, userID: try user.requireID(), password: "123123", organizationID: try org.requireID(), roleID: 1).save(on: conn).wait()

        let accessDto = try DSAuthMain.login(user: LoginRow.Post(email: "maher.santina90@gmail.com", password: "123123", organizationID: try org.requireID()), on: app).wait()

        let userFromToken = try TokenHelpers.getUser(fromPayloadOf: accessDto.accessToken)
        XCTAssertEqual(userFromToken.organizationID, try org.requireID())
        XCTAssertEqual(userFromToken.userID, try user.requireID())
    }

    static let allTests = [
        ("testLogin_ShouldLoginProperly", testLogin_ShouldLoginProperly)
    ]
}
