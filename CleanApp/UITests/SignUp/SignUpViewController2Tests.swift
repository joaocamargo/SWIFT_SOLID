//
//  SignUpViewController2Tests.swift
//  UITests
//
//  Created by joao camargo on 27/09/21.
//
import XCTest
import UIKit
import Presentation

@testable import UI

class SignUpViewController2Tests: XCTestCase {
    func test_loading_is_hidden_on_start() throws {
        XCTAssertFalse(makeSut().loadingIndicator.isAnimating)
    }
    
    func test_sut_implements_loadingView() throws {
        XCTAssertNotNil(makeSut() as LoadingView)
    }
    
    func test_sut_implements_alertView() throws {
        XCTAssertNotNil(makeSut() as AlertView)
    }
    
    func test_saveButton_calls_signUp_on_tap() throws {
        var signUpViewModel: SignUpViewModel?
        
        let sut = makeSut(signUpSpy: { signUpViewModel = $0 })
        sut.saveButton.simulateTap()
        let name = sut.nameTextField.text
        let email = sut.emailTextField.text
        let password = sut.passwordTextField.text
        let confirmPassword = sut.confirmPasswordTextField.text

        XCTAssertEqual(signUpViewModel,SignUpViewModel(name: name, email: email, password: password, passwordConfirmation: confirmPassword))
    }

}

extension SignUpViewController2Tests {
    
    func makeSut(signUpSpy: ((SignUpViewModel) -> Void)? = nil) -> SignUpViewController2 {
        let sut = SignUpViewController2().self
        sut.signUp = signUpSpy
        sut.loadViewIfNeeded()
        return sut
    }
}
