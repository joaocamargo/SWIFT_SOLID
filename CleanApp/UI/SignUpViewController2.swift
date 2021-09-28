//
//  SignUpViewController2.swift
//  UI
//
//  Created by joao camargo on 27/09/21.
//

import UIKit
import Presentation

public final class SignUpViewController2: UIViewController {

    init() {
           super.init(nibName: nil, bundle: nil)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    public var loadingIndicator: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        return loading
    }()
    
    public var saveButton : UIButton = {
        let button = UIButton(frame: .zero)
        return button
    }()
    
    public var nameTextField : UITextField = {
        let nameText = UITextField()
        return nameText
    }()
    
    public var emailTextField  : UITextField = {
        let emailTextField = UITextField()
        return emailTextField
    }()
    
    public var passwordTextField : UITextField = {
        let passwordTextField = UITextField()
        return passwordTextField
    }()
    
    public var confirmPasswordTextField : UITextField = {
        let confirmPasswordTextField = UITextField()
        return confirmPasswordTextField
    }()
    
    var signUp: ((SignUpViewModel) -> Void)?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped() {
        signUp?(SignUpViewModel(name: nameTextField.text, email: emailTextField.text, password: passwordTextField.text, passwordConfirmation: confirmPasswordTextField.text))
    }

}


extension SignUpViewController2: LoadingView {
    public func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}

extension SignUpViewController2: AlertView {
    public func showMessage(viewModel: AlertViewModel) {
        
    }
}
