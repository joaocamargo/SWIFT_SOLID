//
//  SignUpMapper.swift
//  Presentation
//
//  Created by joao camargo on 17/12/20.
//
import Domain
import Foundation


public final class SignUpMapper {
    static func toAddAccountModel(viewModel: SignUpViewModel) -> AddAccountModel {
        return AddAccountModel(name: viewModel.name!, email: viewModel.email!, password: viewModel.password!, passwordConfirmation: viewModel.passwordConfirmation!)
    }
}
