//
//  AlertView.swift
//  Presentation
//
//  Created by joao camargo on 06/12/20.
//

import Foundation

public protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

public struct AlertViewModel: Equatable{
    
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    public var title: String
    public var message: String
}
