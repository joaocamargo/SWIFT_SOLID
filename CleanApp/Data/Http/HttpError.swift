//
//  HttpError.swift
//  Data
//
//  Created by joao camargo on 21/11/20.
//

import Foundation

public enum HttpError: Error {
    case noConnectivity
    case badRequest
    case serverError
    case unauthorized
    case forbidden
}
