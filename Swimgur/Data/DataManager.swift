//
//  DataManager.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/4/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit


public typealias DMBlockBool = (success:Bool)->()

enum DMEngineMode {
  case Authentication
  case Query
}

// Type of authentication
enum VWWImgurControllerAuthType {
  case VWWImgurControllerAuthTypeToken
  case VWWImgurControllerAuthTypePin
  case VWWImgurControllerAuthTypeCode
}

class DataManager {
  var authorizationClosure:DMBlockBool?
  
  class var sharedInstance:DataManager {
    struct Static {
      static let instance = DataManager()
    }
    return Static.instance
  }
  
  init() {
    
  }
  
  let session = NSURLSession.sharedSession()
  
  class func authorizeWithViewController(viewController:UIViewController, completionBlock:DMBlockBool) {
    sharedInstance.authorizationClosure = completionBlock
  }
}