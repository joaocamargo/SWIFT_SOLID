//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by joao camargo on 06/12/20.
//

import XCTest

class SignUpPresenter {
    
    private let alertView: AlertView
    
    init(alertView: AlertView){
        self.alertView = alertView
    }
    
    func signUp(viewModel: SignUpViewModel){
        if viewModel.name == nil || viewModel.name!.isEmpty {
             alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "Nome é obrigatório"))
        }
    }
}

protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable{
    var title: String
    var message: String
}


public struct SignUpViewModel {
    var name: String?
    var email: String?
    var password: String?
    var passwordConfirmation: String?
}

class SignUpPresenterTests: XCTestCase {
    
    func test_signUp_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(email: "\(UUID().uuidString)@gmail.com", password: "secret", passwordConfirmation: "secret")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Nome é obrigatório"))
    }
    
}

extension SignUpPresenterTests{
    class AlertViewSpy: AlertView {
        
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
