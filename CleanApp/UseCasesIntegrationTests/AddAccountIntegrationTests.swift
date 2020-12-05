//
//  UseCasesIntegrationTests.swift
//  UseCasesIntegrationTests
//
//  Created by joao camargo on 05/12/20.
//

import XCTest
import Data
import Infra
import Domain

class AddAccountIntegrationTests: XCTestCase {

    func test_add_account() {
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "https://fordevs.herokuapp.com/api/signup")!
        let sut = RemoteAddAccount(url: url,httpClient: alamofireAdapter)
        let addAccountModel = AddAccountModel(name: "Joao Camargo", email: "\(UUID().uuidString)@gmail.com", password: "secret", passwordConfirmation: "secret")
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { (result) in
            switch result{
            case .failure: XCTFail("Expect success got \(result) instead")
            case .success(let account):
               // XCTAssertNotNil(account.id)
                XCTAssertEqual(account.name, addAccountModel.name)
                //XCTAssertEqual(account.email, addAccountModel.email)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }

    func test_add_account_fail() {
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "https://fordevs.herokuapp.com/api/signup")!
        let sut = RemoteAddAccount(url: url,httpClient: alamofireAdapter)
        let addAccountModel = AddAccountModel(name: "Joao Camargo", email: "\(UUID().uuidString)@gmail.com", password: "secret", passwordConfirmation: "secret2")
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { (result) in
            switch result{
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expect success got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }

}
