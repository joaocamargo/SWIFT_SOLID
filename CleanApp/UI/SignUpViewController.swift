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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
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
