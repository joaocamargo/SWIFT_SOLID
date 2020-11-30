//
//  ExtensionHelper.swift
//  Data
//
//  Created by joao camargo on 30/11/20.
//

import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
