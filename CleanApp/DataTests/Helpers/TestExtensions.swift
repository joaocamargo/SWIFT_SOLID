//
//  TestExtensions.swift
//  DataTests
//
//  Created by joao camargo on 30/11/20.
//

import Foundation
import XCTest

extension XCTestCase {
    
    func checkMemoryLeak(for instance: AnyObject,file: StaticString = #filePath, line: UInt = #line){
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance)
        }
    }
}
