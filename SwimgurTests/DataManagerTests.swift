//
//  DataManagerTests.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/29/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit
import XCTest

class DataManagerTests: XCTestCase {
  
  // Helpers
  func createUniqueInstance() -> DataManager {
    return DataManager()
  }
  
  func getSharedInstance() -> DataManager {
    return DataManager.sharedInstance
  }
  
  // Tests
  func testSingletonSharedInstanceCreated() {
    XCTAssertNotNil(getSharedInstance())
  }
  
  func testSingletonUniqueInstanceCreated() {
    XCTAssertNotNil(createUniqueInstance())
  }
  
  func testSingletonReturnsSameSharedInstances() {
    var s1 = getSharedInstance()
    var s2 = getSharedInstance()
    XCTAssertEqual(s1, s2)
  }
  
  func testSingletonSharedInstanceSameAsUniqueInstance() {
    var s1 = getSharedInstance()
    var s2 = createUniqueInstance()
    XCTAssertNotEqual(s1, s2)
  }
  
  func testSingletonReturnsSameUniqueInstances() {
    var s1 = createUniqueInstance()
    var s2 = createUniqueInstance()
    XCTAssertNotEqual(s1, s2)
  }
}
