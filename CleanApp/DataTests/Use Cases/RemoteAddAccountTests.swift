//
//  DataTests.swift
//  DataTests
//
//  Created by joao camargo on 18/11/20.
//

import XCTest
import Domain
import Data
//@testable import Data



class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpClient_with_correct_url() {
        let url = makeURL()
        let (sut,httpClientSpy) = makeSut(url: url)
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel) { _ in}
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    
    
    func test_add_should_call_httpClient_with_correct_data() {
        let (sut,httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel){ _ in}
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }
    
    func test_add_should_complete_with_error_if_client_fails_with_error(){
        let (sut,httpClientSpy) = makeSut()
        expect(sut,completeWith: .failure(.unexpected),when: {
            httpClientSpy.completeWithError(.noConnectivity)
        })
    }
    
    func test_add_should_complete_with_error_if_client_fails_with_invalid_data(){
        let (sut,httpClientSpy) = makeSut()
        expect(sut,completeWith: .failure(.unexpected),when: {
            httpClientSpy.completeWithData(data: makeInvalidData())
        })
    }
    
    func test_add_should_NOT_complete_with_error_if_sut_has_been_deallocated(){
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: makeURL(), httpClient: httpClientSpy)
        var result: Result<AccountModel, DomainError>?
        sut?.add(addAccountModel: makeAddAccountModel()) { result = $0 }
        sut = nil  //atribui a nil, simular um usuario que saiu da tela, e quanto o codigo acima terminar de executar, ele tem q tar nil, pq nao é pra executar
        httpClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(result)        
    }
    
    
    func test_add_should_complete_with_account_if_client_complete_with_data(){
        let (sut,httpClientSpy) = makeSut()
        let account = makeAccountModel()
        expect(sut,completeWith: .success(account),when: {
            httpClientSpy.completeWithData(data: account.toData()!)
        })
    }
    
}


extension RemoteAddAccountTests{
    //FACTORY
    func makeSut(url: URL = URL(string: "http://any-url.com")!,file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteAddAccount, HttpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        
        return (sut,httpClientSpy)
    }
    
    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModel,DomainError>, when action: ()-> Void,file: StaticString = #filePath, line: UInt = #line){
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult,receivedResult) {
    case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)): XCTAssertEqual(expectedAccount, receivedAccount,file: file, line: line)
            default:XCTFail("Expected \(expectedResult) received \(receivedResult)",file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp],timeout: 1)
    }    


}

