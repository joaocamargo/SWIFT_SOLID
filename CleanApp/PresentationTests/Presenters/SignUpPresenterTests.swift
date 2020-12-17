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
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel,self?.makeRequiredAlertViewModel(fieldName: "Nome"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(name: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel,self?.makeRequiredAlertViewModel(fieldName: "Email"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(email: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel,self?.makeRequiredAlertViewModel(fieldName: "Senha"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel(password: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_password_confirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel,self?.makeRequiredAlertViewModel(fieldName: "Confirmar Senha"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_password_confirmation_doesnt_match() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel,self?.makeInvalidAlertViewModel(fieldName: "Confirmar Senha"))
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
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeInvalidAlertViewModel(fieldName: "Email"))
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
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel,self?.makeErrorAlertViewModel(message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
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
        
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel,self?.makeSuccessAlertViewModel(message: "Conta criada com sucesso."))
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
    
    func makeSignUpViewModel(name: String? = "Joao", email: String? =  "\(UUID().uuidString)@gmail.com", password: String? = "pass", passwordConfirmation: String? = "pass")-> SignUpViewModel {
        return SignUpViewModel(name: name,email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    func makeRequiredAlertViewModel(fieldName: String) -> AlertViewModel {
        return AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é obrigatório")
    }
    
    func makeInvalidAlertViewModel(fieldName: String) -> AlertViewModel {
        return AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é inválido")
    }
    
    func makeErrorAlertViewModel(message: String) -> AlertViewModel {
        return AlertViewModel(title: "Erro", message: message)
    }
    
    func makeSuccessAlertViewModel(message: String) -> AlertViewModel {
        return AlertViewModel(title: "Sucesso", message: message)
    }
    
    class LoadingViewSpy: LoadingView {
        var emit: ((LoadingViewModel) -> Void)?
        var completion: ((Result<LoadingViewModel,DomainError>) -> Void)?
        
        func observe(completion: @escaping(LoadingViewModel)-> Void) {
            self.emit = completion
        }
        
        
        func display(viewModel: LoadingViewModel) {
            self.emit?(viewModel)
        }
    }

    
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
    
    class AddAccountSpy: AddAccount {
        var addAccountModel: AddAccountModel?
        var completion: ((Result<AccountModel,DomainError>) -> Void)?
        
        func add(addAccountModel: AddAccountModel, completion: @escaping(Result<AccountModel,DomainError>) -> Void) {
            self.addAccountModel = addAccountModel
            self.completion = completion
        }
        
        func completeWithError(_ error: DomainError){
            completion?(.failure(error))
        }
        
        func completeWithAccount(_ account: AccountModel) {
            completion?(.success(account))
        }
    }
}
