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
    let s1 = getSharedInstance()
    let s2 = getSharedInstance()
    XCTAssertEqual(s1, s2)
  }
  
  func testSingletonSharedInstanceSameAsUniqueInstance() {
    let s1 = getSharedInstance()
    let s2 = createUniqueInstance()
    XCTAssertNotEqual(s1, s2)
  }
  
  func testSingletonReturnsSameUniqueInstances() {
    let s1 = createUniqueInstance()
    let s2 = createUniqueInstance()
    XCTAssertNotEqual(s1, s2)
  }
}
