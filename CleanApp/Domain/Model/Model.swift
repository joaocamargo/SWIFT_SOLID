//
//  Model.swift
//  Domain
//
//  Created by joao camargo on 21/11/20.
//

import Foundation

public protocol Model: Codable, Equatable {}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
