//
//  UITests.swift
//  UITests
//
//  Created by joao camargo on 20/12/20.
//

import XCTest
import UIKit


@testable import UI

class SignUpViewControllerTests: XCTestCase {
    func test_loading_is_hidden_on_start() throws {
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = sb.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.loadingIndicator.isAnimating)
    }

}
