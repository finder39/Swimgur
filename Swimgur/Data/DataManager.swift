//
//  DataManager.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/4/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit


public typealias DMBlockBool = (success:Bool)->()
public typealias DMDictionaryBlock = (dictionary:Dictionary<String, AnyObject>)->()
public typealias DMErrorStringBlock = (error:NSError, desciption:String)->()
public typealias DMTokenBlock = (token:Token)->()

enum DMEngineMode {
  case Authentication
  case Query
}

class DataManager {
  
  var restConfig = RestConfig()
  let session = NSURLSession.sharedSession()
  var apiPath: NSString = ""
  
  class var sharedInstance:DataManager {
    struct Static {
      static let instance = DataManager()
    }
    return Static.instance
  }
  
  init() {
    apiPath = restConfig.serviceAuthorize
  }
  
  func setMode(mode:DMEngineMode) {
    switch(mode) {
      case .Authentication:
        apiPath = restConfig.serviceAuthorize
      case .Query:
        apiPath = restConfig.serviceQuery
    }
  }
  
  func getTokensWithForm(form:CodeForm, onCompletion:DMTokenBlock, onError:DMErrorStringBlock) {
    // TODO:
  }
  
  func getAccountWithCompletion(onCompletion:DMDictionaryBlock, onError:DMErrorStringBlock) {
    // TODO:
  }
}