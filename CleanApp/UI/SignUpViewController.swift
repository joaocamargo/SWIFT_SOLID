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

    var signUp: ((SignUpViewModel) -> Void)?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        saveButton?.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped() {
        signUp?(SignUpViewModel(name: nil, email: nil, password: nil, passwordConfirmation: nil))
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
        
    }
}
