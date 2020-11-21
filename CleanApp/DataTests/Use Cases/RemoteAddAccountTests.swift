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
        let url = URL(string: "http://any-url.com")!
        let (sut,httpClientSpy) = makeSut(url: url)
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel)
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    


func test_add_should_call_httpClient_with_correct_data() {
        let (sut,httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel)
    XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }

}


extension RemoteAddAccountTests{
    //FACTORY
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, HttpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sut,httpClientSpy)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "Joao", email: "joao.camargo@gmail.com", password: "123456", passwordConfirmation: "123456")
    }
    
    class HttpClientSpy: HttpPostClient {
        var urls = [URL]()
        var data: Data?
        
        func post(to url: URL,with data: Data?) {
            self.urls.append(url)
            self.data = data
        }
    }
}

