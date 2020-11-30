//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by joao camargo on 30/11/20.
//

import Foundation
import Domain



func makeAccountModel() -> AccountModel {
    return AccountModel(id: "any_id", name: "Joao", email: "joao.camargo@gmail.com", password: "123456")
}
