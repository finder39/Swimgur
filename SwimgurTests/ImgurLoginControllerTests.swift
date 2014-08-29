//
//  ImgurLoginControllerTests.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/29/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit
import XCTest

class ImgurLoginControllerTests: XCTestCase {
  func testLogin() {
    var telc = TestableImgurLoginController()
    XCTAssertNotNil(telc, "TestableImgurLoginController not loaded")
    
    var expectation = self.expectationWithDescription("login")
    
    
    telc.authorizeWithViewController(UIViewController()) { (success) -> () in
      XCTAssertTrue(success, "Login failed")
      XCTAssertNotNil(SIUserDefaults().code?, "Code does not exist")
      XCTAssertNotNil(SIUserDefaults().token?.accessToken, "Token does not exist")
      expectation.fulfill()
    }
    
    self.waitForExpectationsWithTimeout(5.0, handler: nil)
  }
}

class TestableImgurLoginController: ImgurLoginController {
  func webViewDidFinishLoad(webView: UIWebView!) {
    webView.stringByEvaluatingJavaScriptFromString("document.getElementById('username').value = 'testthewest'")
    webView.stringByEvaluatingJavaScriptFromString("document.getElementById('password').value = 'supertesters'")
    webView.stringByEvaluatingJavaScriptFromString("document.getElementById('allow').click()")
  }
}