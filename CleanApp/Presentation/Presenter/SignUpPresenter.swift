//
//  SignUpPresenter.swift
//  Presentation
//
//  Created by joao camargo on 06/12/20.
//

import Foundation

public class SignUpPresenter {
    
    private let alertView: AlertView
    
    public init(alertView: AlertView){
        self.alertView = alertView
    }
    
    public func signUp(viewModel: SignUpViewModel){
        if let message = validate(viewModel: viewModel) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        }
    }
    
    private func validate(viewModel: SignUpViewModel) -> String? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
             return "Nome é obrigatório"
        }
        
        if viewModel.email == nil || viewModel.email!.isEmpty {
             return "Email é obrigatório"
        }
        
        if viewModel.password == nil || viewModel.password!.isEmpty {
             return "Senha é obrigatório"
        }
        
        if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
             return "Confirmação de senha é obrigatório"
        }
        
        if viewModel.password != viewModel.passwordConfirmation {
             return "Confirmação de senha não coincide com senha"
        }
        
        
        return nil
    }
}


public struct SignUpViewModel {
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
