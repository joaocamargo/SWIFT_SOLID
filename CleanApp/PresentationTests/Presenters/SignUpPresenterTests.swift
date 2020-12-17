//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by joao camargo on 06/12/20.
//

import XCTest
import Presentation
import Domain
//import Data

class SignUpPresenterTests: XCTestCase {
    
    func test_signUp_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe {  viewModel in
            XCTAssertEqual(viewModel,makeRequiredAlertViewModel(fieldName: "Nome"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(name: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel,makeRequiredAlertViewModel(fieldName: "Email"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(email: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeRequiredAlertViewModel(fieldName: "Senha"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel(password: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_password_confirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe {  viewModel in
            XCTAssertEqual(viewModel,makeRequiredAlertViewModel(fieldName: "Confirmar Senha"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_password_confirmation_doesnt_match() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe {  viewModel in
            XCTAssertEqual(viewModel,makeInvalidAlertViewModel(fieldName: "Confirmar Senha"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "other"))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_call_emailvalidator_with_correct_email() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(signUpViewModel.email, emailValidatorSpy.email)
    }
    
    func test_signUp_should_show_error_message_when_email_is_invalid() {
        let emailValidatorSpy = EmailValidatorSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeInvalidAlertViewModel(fieldName: "Email"))
            exp.fulfill()
        }
        emailValidatorSpy.simulateInvalidEmail()
        sut.signUp(viewModel: makeSignUpViewModel(email: "invalid_one@gmail.com"))
        wait(for: [exp], timeout: 1)
        
    }
        
    func test_signUp_should_call_addAccount_with_correct_values() {
        let email = "\(UUID().uuidString)@gmail.com"
        let addAccountSpy = AddAccountSpy()
        var accountModel = makeAddAccountModel()
        accountModel.email = email
        let sut = makeSut(addAccount: addAccountSpy)
        sut.signUp(viewModel: makeSignUpViewModel(email: email))
        XCTAssertEqual(addAccountSpy.addAccountModel,accountModel)
    }
    
    func test_signUp_should_show_error_message_id_addAccount_fails() {
        let addAccountSpy = AddAccountSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy,addAccount: addAccountSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel,makeErrorAlertViewModel(message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWithError(.unexpected)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_loading_before_and_after_call_addAccount() {
        let loadingViewSpy = LoadingViewSpy()
        let addAccountSpy = AddAccountSpy()

        let sut = makeSut(addAccount: addAccountSpy, loadingView: loadingViewSpy)
        let exp = expectation(description: "waiting")
        
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel())
        wait(for: [exp], timeout: 1)
        
        
        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            exp2.fulfill()
        }
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
        
    }
    
    func test_signUp_should_show_success_message_if_addAccount_succeds() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()

        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel,makeSuccessAlertViewModel(message: "Conta criada com sucesso."))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWithAccount(makeAccountModel())
        wait(for: [exp], timeout: 1)
    }
    
    
    
}

extension SignUpPresenterTests{
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(), emailValidator: EmailValidatorSpy = EmailValidatorSpy(),addAccount: AddAccountSpy = AddAccountSpy(), loadingView: LoadingViewSpy = LoadingViewSpy(),file: StaticString = #filePath, line: UInt = #line) -> SignUpPresenter {
        let sut = SignUpPresenter(alertView: alertView, emailValidator: emailValidator, addAccount: addAccount, loadingView: loadingView)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    } 



}
