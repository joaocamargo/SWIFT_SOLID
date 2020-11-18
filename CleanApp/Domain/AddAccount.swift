//
//  AddAccount.swift
//  Domain
//
//  Created by joao camargo on 18/11/20.
//

import Foundation

protocol AddAccount {
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel,Error>)-> Void)
}

struct AddAccountModel {
    var name: String
    var email: String
    var password: String
    var passwordConfirmation: String
}


