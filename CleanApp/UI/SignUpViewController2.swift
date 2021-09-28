//
//  SignUpViewController2.swift
//  UI
//
//  Created by joao camargo on 27/09/21.
//

import UIKit
import Presentation

public final class SignUpViewController2: UIViewController {
    
    public weak var loadingIndicator: UIActivityIndicatorView!
    public weak var saveButton: UIButton!
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
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
