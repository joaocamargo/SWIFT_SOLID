//
//  SignUpViewController.swift
//  UI
//
//  Created by joao camargo on 20/12/20.
//

import Foundation
import UIKit
import Presentation

public final class SignUpViewController: UIViewController {
    
    @IBOutlet public weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet public weak var saveButton: UIButton!
    @IBOutlet public weak var nameTextField: UITextField!
    @IBOutlet public weak var emailTextField: UITextField!
    @IBOutlet public weak var passwordTextField: UITextField!
    @IBOutlet public weak var confirmPasswordTextField: UITextField!
    
    
    var signUp: ((SignUpViewModel) -> Void)?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        saveButton?.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.layer.cornerRadius = 5
    }
    
    @objc private func saveButtonTapped() {
        signUp?(SignUpViewModel(name: nameTextField.text, email: emailTextField.text, password: passwordTextField.text, passwordConfirmation: confirmPasswordTextField.text))
    }
}


extension SignUpViewController: LoadingView {
    public func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}

extension SignUpViewController: AlertView {
    public func showMessage(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert,animated: true)
    }
}
