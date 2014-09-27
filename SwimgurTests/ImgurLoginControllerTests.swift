//
//  ImgurLoginControllerTests.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/29/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit
import XCTest
import SWNetworking

class ImgurLoginControllerTests: XCTestCase {
  
  func test1Login() {
    DataManager.sharedInstance.logout()
    var tilc = TestableImgurLoginController()
    XCTAssertNotNil(tilc, "TestableImgurLoginController not loaded")
    
    var expectation = self.expectationWithDescription("Login")
    
    tilc.authorizeWithViewController(UIViewController()) { (success) -> () in
      XCTAssertTrue(success, "Login failed")
      XCTAssertNotNil(SIUserDefaults().code?, "Code does not exist")
      XCTAssertNotNil(SIUserDefaults().token?.accessToken, "Token does not exist")
      XCTAssertNotNil(SIUserDefaults().account?, "Account does not exist")
      if let username = SIUserDefaults().account?.username {
        XCTAssertEqual(username, "testthewest", "Username is incorrect")
      } else {
        XCTFail("Username not set")
      }
      expectation.fulfill()
    }
    
    self.waitForExpectationsWithTimeout(10.0, handler: nil)
  }
  
  func testGetGallery() {
    var expectation = self.expectationWithDescription("Get gallery")
    
    SWNetworking.sharedInstance.getGalleryImagesWithSection(ImgurSection.Hot, sort: ImgurSort.Viral, window: ImgurWindow.Day, page: 0, showViral: true, onCompletion: { (newGalleryItems) -> () in
      XCTAssertGreaterThan(newGalleryItems.count, 0, "None returned")
      expectation.fulfill()
    }) { (error, description) -> () in
      XCTFail("Get gallery failed")
      expectation.fulfill()
    }
    
    self.waitForExpectationsWithTimeout(5.0, handler: nil)
  }
  
  func testGetAlbum() {
    var expectation = self.expectationWithDescription("Get album")
    
    SWNetworking.sharedInstance.getAlbum(albumId: "TxQjM", onCompletion: { (album) -> () in
      XCTAssertEqual(album.images.count, 10, "Album image count incorrect")
      expectation.fulfill()
    }) { (error, description) -> () in
      XCTFail("Get album failed")
      expectation.fulfill()
    }
    
    self.waitForExpectationsWithTimeout(5.0, handler: nil)
  }
  
  func testVoting() {
    var expectation = self.expectationWithDescription("Get album")
    
    SWNetworking.sharedInstance.voteOnGalleryItem(galleryItemId: "TxQjM", vote: GalleryItemVote.Down, onCompletion: { (success) -> () in
      XCTAssertTrue(success, "Down vote failed")
      SWNetworking.sharedInstance.voteOnGalleryItem(galleryItemId: "TxQjM", vote: GalleryItemVote.Up, onCompletion: { (success) -> () in
        XCTAssertTrue(success, "Up vote failed")
        expectation.fulfill()
      })
    })
    
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