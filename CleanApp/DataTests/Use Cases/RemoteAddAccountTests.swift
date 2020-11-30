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
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, HttpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sut,httpClientSpy)
    }
    
    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModel,DomainError>, when action: ()-> Void){
        
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult,receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError)
            case (.success(let expectedAccount), .success(let receivedAccount)): XCTAssertEqual(expectedAccount, receivedAccount)
            default:XCTFail("Expected \(expectedResult) received \(receivedResult)")
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp],timeout: 1)
    }
    
    func makeInvalidData() -> Data {
        return Data("invalid".utf8)
    }
    
    func makeURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "Joao", email: "joao.camargo@gmail.com", password: "123456", passwordConfirmation: "123456")
    }
    
    func makeAccountModel() -> AccountModel {
        return AccountModel(id: "any_id", name: "Joao", email: "joao.camargo@gmail.com", password: "123456")
    }
    
    class HttpClientSpy: HttpPostClient {
        var urls = [URL]()
        var data: Data?
        var completion: ((Result<Data,HttpError>) -> Void)?
        
        func post(to url: URL,with data: Data?, completion: @escaping(Result<Data,HttpError>)-> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError){
            completion?(.failure(error))
        }
        
        func completeWithData(data: Data){
            completion?(.success(data))
        }
    }
}

