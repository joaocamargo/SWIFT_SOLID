//
//  InfraTests.swift
//  InfraTests
//
//  Created by joao camargo on 30/11/20.
//

import XCTest
import Alamofire
import Data

class AlamofireAdapter {
    private let session: Session
    
    init(session: Session = .default){
        self.session = session
    }
    
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void){
        session.request(url,method: .post, parameters: data?.toJson(), encoding: JSONEncoding.default).responseData { dataResponse in
            switch dataResponse.result {
                case .failure: completion(.failure(.noConnectivity))
                case .success: break
            }
        }
    }
}

class AlamofireAdapterTests: XCTestCase {
    
    func test_post_should_make_request_with_valid_and_method() {
        let url = makeURL()
        testRequestFor(url: url, data: makeValidData()) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_make_request_with_no_data() {
        testRequestFor(data: nil) { (request) in
            XCTAssertNil(request.httpBodyStream)
        }
    }
    
    
    func test_post_should_complete_with_error_when_request_completes_with_error() {
        let sut = makeSut()
        URLProtocolStub.simulate(data: nil, response: nil,error: makeError())
        let exp = expectation(description: "waiting")
        sut.post(to: makeURL(), with: makeValidData()){ result in
            switch result{
                case .success(_):  XCTFail("Expected error, got \(result) instead")
                case .failure(let error): XCTAssertEqual(error, .noConnectivity)
            }
        }
        exp.fulfill()        
        wait(for: [exp],timeout: 1)
    }
}

//          data  response  error
// valido:   ok      ok       x
// valido:    x       x       ok
// invalido: resto
// invalido:  ok       ok     ok
// invalido:  ok       x      ok
// invalido:  ok       x      x
// invalido:  x        ok     ok
// invalido:  x        ok     x
// invalido:  x        x      x

extension AlamofireAdapterTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut =  AlamofireAdapter(session: session)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func testRequestFor(url: URL = makeURL(), data: Data?, action: @escaping(URLRequest) -> Void){
        let sut = makeSut()
        sut.post(to: url, with: data) { _ in }
        let exp = expectation(description: "waiting")
            URLProtocolStub.observeRequest { (request) in
                action(request)
                exp.fulfill()
            }
        wait(for: [exp], timeout: 1)
    }
}

class URLProtocolStub : URLProtocol {
    
    static var emit: ((URLRequest)-> Void)?
    static var error: Error?
    static var data: Data?
    static var response: HTTPURLResponse?
    
    static func observeRequest(completion: @escaping (URLRequest)->Void){
        URLProtocolStub.emit = completion
    }
    
    static func simulate(data: Data?, response: HTTPURLResponse?, error: Error?){
        URLProtocolStub.data = data
        URLProtocolStub.response = response
        URLProtocolStub.error = error
    }
    
    override open class func canInit(with request: URLRequest) -> Bool { //class func = estatico static
        return true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override open func startLoading() {
        URLProtocolStub.emit?(request)
        if let data = URLProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = URLProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = URLProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)    }
    
    override open func stopLoading() {

    }
}
