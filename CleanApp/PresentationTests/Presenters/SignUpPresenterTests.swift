//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by joao camargo on 06/12/20.
//

import XCTest
import Presentation



class SignUpPresenterTests: XCTestCase {
    
    func test_signUp_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(email: "\(UUID().uuidString)@gmail.com", password: "secret", passwordConfirmation: "secret")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Nome é obrigatório"))
    }
    
    func test_signUp_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", password: "secret", passwordConfirmation: "secret")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Email é obrigatório"))
    }
    
    func test_signUp_should_show_error_message_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "\(UUID().uuidString)@gmail.com", passwordConfirmation: "secret")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Senha é obrigatório"))
    }
    
    func test_signUp_should_show_error_message_if_password_confirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "\(UUID().uuidString)@gmail.com", password: "secret")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Confirmação de senha é obrigatório"))
    }
    
    func test_signUp_should_show_error_message_if_password_confirmation_doesnt_match() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)

        let signUpViewModel = SignUpViewModel(name: "any_name", email: "\(UUID().uuidString)@gmail.com", password: "secret",passwordConfirmation: "secret2")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Confirmação de senha não coincide com senha"))
    }
    
    func test_signUp_should_call_emailvalidator_with_correct_email() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "\(UUID().uuidString)@gmail.com", password: "secret",passwordConfirmation: "secret")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(signUpViewModel.email, emailValidatorSpy.email)
    }
    
    func test_signUp_should_show_error_message_when_email_is_invalid() {
        let emailValidatorSpy = EmailValidatorSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        emailValidatorSpy.isValid = false
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "invalid_mail@gmail.com", password: "secret",passwordConfirmation: "secret")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Email inválido"))
    }
}

extension SignUpPresenterTests{
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(), emailValidator: EmailValidatorSpy = EmailValidatorSpy()) -> SignUpPresenter {
        let sut = SignUpPresenter(alertView: alertView, emailValidator: emailValidator)
        return sut
    }
    
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
    
    class EmailValidatorSpy: EmailValidator {
        var isValid = true
        var email: String?
        func isValid(email: String) -> Bool{
            self.email = email 
            return isValid
        }
    }
}
