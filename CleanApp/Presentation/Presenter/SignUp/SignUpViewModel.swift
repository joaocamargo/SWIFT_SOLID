//
//  SignUpViewModel.swift
//  PresentationTests
//
//  Created by joao camargo on 17/12/20.
//

import Foundation
import Domain

public struct SignUpViewModel : Model {
    public  init(name: String? = nil, email: String? = nil, password: String? = nil, passwordConfirmation: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
    
    public var name: String?
    public var email: String?
    public var password: String?
    public var passwordConfirmation: String?
}
