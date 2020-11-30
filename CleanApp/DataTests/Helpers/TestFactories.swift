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

func makeURL() -> URL {
    return URL(string: "http://any-url.com")!
}
