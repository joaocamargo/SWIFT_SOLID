//
//  AlertViewSpy.swift
//  PresentationTests
//
//  Created by joao camargo on 17/12/20.
//

import Foundation
import Presentation


class AlertViewSpy: AlertView {
    var emit: ((AlertViewModel) -> Void)?
    
    
    func observe(completion: @escaping(AlertViewModel)-> Void) {
        self.emit = completion
    }
    
    func showMessage(viewModel: AlertViewModel) {
        self.emit?(viewModel)
    }
}
