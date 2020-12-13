//
//  LoadingView.swift
//  Presentation
//
//  Created by joao camargo on 13/12/20.
//

import Foundation

public protocol LoadingView {
    func display(viewModel: LoadingViewModel)
}

public struct LoadingViewModel: Equatable{
    public var isLoading: Bool
    
    public init(isLoading: Bool){
        self.isLoading = isLoading        
    }
}
