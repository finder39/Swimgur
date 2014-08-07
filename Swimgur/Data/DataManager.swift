//
//  DataManager.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/4/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit


public typealias DMBlockBool = (success:Bool)->()

enum DMEngineMode {
  case Authentication
  case Query
}

internal var restConfig = RestConfig()

class DataManager {
  
  let session = NSURLSession.sharedSession()
  var apiPath:NSString = restConfig.serviceAuthorize
  
  class var sharedInstance:DataManager {
    struct Static {
      static let instance = DataManager()
    }
    return Static.instance
  }
  
  init() {
    
  }
  
  func setMode(mode:DMEngineMode) {
    switch(mode) {
      case .Authentication:
        self.apiPath = restConfig.serviceAuthorize
      case .Query:
        self.apiPath = restConfig.serviceQuery
    }
  }
}