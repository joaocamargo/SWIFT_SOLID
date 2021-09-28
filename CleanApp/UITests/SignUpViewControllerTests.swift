//
//  UITests.swift
//  UITests
//
//  Created by joao camargo on 20/12/20.
//

import XCTest
import UIKit
import Presentation

@testable import UI

class SignUpViewControllerTests: XCTestCase {
    func test_loading_is_hidden_on_start() throws {
        XCTAssertFalse(makeSut().loadingIndicator.isAnimating)
    }
    
    func test_sut_implements_loadingView() throws {
        XCTAssertNotNil(makeSut() as LoadingView)
    }
    
    func test_sut_implements_alertView() throws {
        XCTAssertNotNil(makeSut() as AlertView)
    }
    
    func test_saveButton_calls_signUp_on_tap() throws {
        var callsCount = 0
        
        let sut = makeSut(signUpSpy: { _ in
            callsCount += 1
        })
        sut.saveButton?.simulateTap()
        XCTAssertEqual(callsCount,1)
    }

}

extension SignUpViewControllerTests {
    
    func makeSut(signUpSpy: ((SignUpViewModel) -> Void)? = nil) -> SignUpViewController {
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = sb.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        sut.signUp = signUpSpy
        sut.loadViewIfNeeded()
        return sut
    }
}

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
