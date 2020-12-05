//
//  TestFactories.swift
//  DataTests
//
//  Created by joao camargo on 30/11/20.
//

import Foundation

func makeInvalidData() -> Data {
    return Data("invalid".utf8)
}

func makeValidData() -> Data {
    return Data("{\"name\":\"Joao\"}".utf8)
}

func makeURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func makeError() -> Error {
    return NSError(domain: "erro", code: 0)
}
