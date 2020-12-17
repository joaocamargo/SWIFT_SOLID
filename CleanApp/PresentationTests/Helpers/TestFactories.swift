//
//  TestFactories.swift
//  Presentation
//
//  Created by joao camargo on 17/12/20.
//

import Foundation
import Presentation


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
