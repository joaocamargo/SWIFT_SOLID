//
//  InfraTests.swift
//  InfraTests
//
//  Created by joao camargo on 30/11/20.
//

import XCTest
import Alamofire

class AlamofireAdapter {
    private let session: Session
    
    init(session: Session = .default){
        self.session = session
    }
    
    func post(to url: URL, with data: Data?){
        let json = data == nil ? nil :  try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
        session.request(url,method: .post, parameters: json, encoding: JSONEncoding.default).resume()
    }
}

class AlamofireAdapterTests: XCTestCase {
    
    func test_post_should_make_request_with_valid_and_method() {
        let url = makeURL()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        sut.post(to: url, with: makeValidData())
        let exp = expectation(description: "waiting")
            URLProtocolStub.observeRequest { (request) in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
                exp.fulfill()
            }
        wait(for: [exp], timeout: 1)
    }
    
    func test_post_should_make_request_with_no_data() {
        let url = makeURL()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        sut.post(to: url, with: makeInvalidData())
        let exp = expectation(description: "waiting")
            URLProtocolStub.observeRequest { (request) in
            XCTAssertEqual(url, request.url)
            XCTAssertNil(request.httpBodyStream)
                exp.fulfill()
            }
        wait(for: [exp], timeout: 1)
    }
    
}

class URLProtocolStub : URLProtocol {
    
    static var emit: ((URLRequest)-> Void)?
    
    static func observeRequest(completion: @escaping (URLRequest)->Void){
        URLProtocolStub.emit = completion
    }
    
    override open class func canInit(with request: URLRequest) -> Bool { //class func = estatico static
        return true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override open func startLoading() {
        URLProtocolStub.emit?(request)
    }
    
    override open func stopLoading() {
        
    }
}
