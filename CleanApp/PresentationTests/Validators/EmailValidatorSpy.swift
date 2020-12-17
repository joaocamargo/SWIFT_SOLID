//
//  EmailValidatorSpy.swift
//  PresentationTests
//
//  Created by joao camargo on 17/12/20.
//

import Foundation
import Presentation


class EmailValidatorSpy: EmailValidator {
    var isValid = true
    var email: String?
    func isValid(email: String) -> Bool{
        self.email = email
        return isValid
    }
    
    func simulateInvalidEmail(){
        isValid = false
    }
}
