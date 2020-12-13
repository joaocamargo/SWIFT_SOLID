//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by joao camargo on 30/11/20.
//

import Foundation
import Domain



func makeAccountModel() -> AccountModel {
    return AccountModel(name: "Joao", accessToken: "") //: "joao.camargo@gmail.com", password: "123456")
}

func makeAddAccountModel() -> AddAccountModel {
    return AddAccountModel(name: "Joao", email: "joao.camargo@gmail.com", password: "123456", passwordConfirmation: "123456")
}
