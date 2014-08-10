//
//  SIUserDefaults.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/8/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

public enum SIDefault: String {
  case AccountKey = "account"
  case TokenKey = "token"
  case UsernameKey = "username"
  case CodeKey = "code"
}

public class SIUserDefaults {
  var account: Dictionary<String, String>? {
    get {
      return NSUserDefaults.standardUserDefaults().objectForKey(SIDefault.AccountKey.toRaw()) as AnyObject? as Dictionary<String, String>?
    }
    set {
      NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: SIDefault.AccountKey.toRaw())
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  var token: Token? {
    get {
      let tokenDict = NSUserDefaults.standardUserDefaults().objectForKey(SIDefault.TokenKey.toRaw()) as AnyObject? as Dictionary<String, AnyObject>?
      if let tokenDict = tokenDict {
        return Token(dictionary: tokenDict)
      } else {
        return nil
      }
    }
    set {
      NSUserDefaults.standardUserDefaults().setObject(newValue?.asDictionary(), forKey: SIDefault.TokenKey.toRaw())
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  var username: String? {
    get {
      return NSUserDefaults.standardUserDefaults().objectForKey(SIDefault.UsernameKey.toRaw()) as AnyObject? as String?
    }
    set {
      NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: SIDefault.UsernameKey.toRaw())
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  var code: String? {
    get {
      return NSUserDefaults.standardUserDefaults().objectForKey(SIDefault.CodeKey.toRaw()) as AnyObject? as String?
    }
    set {
      NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: SIDefault.CodeKey.toRaw())
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
}