//
//  Text+Ext.swift
//  UITests
//
//  Created by joao camargo on 28/09/21.
//

import UIKit

extension UIControl {
    
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
    
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            self.actions(forTarget: target, forControlEvent: event)?.forEach { action in
                (target as NSObject).perform(Selector(action))
            }
        }
    }
    
}
