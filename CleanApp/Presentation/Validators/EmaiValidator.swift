//
//  EmaiValidator.swift
//  Presentation
//
//  Created by joao camargo on 06/12/20.
//

import Foundation

public protocol EmailValidator {
    func isValid(email: String) -> Bool
}
