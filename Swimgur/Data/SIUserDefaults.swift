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
      if let newValue = newValue {
        NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: SIDefault.AccountKey.toRaw())
        NSUserDefaults.standardUserDefaults().synchronize()
      } else {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SIDefault.AccountKey.toRaw())
        NSUserDefaults.standardUserDefaults().synchronize()
      }
    }
  }
  
  var token: Token? {
    get {
      let outData = NSUserDefaults.standardUserDefaults().objectForKey(SIDefault.TokenKey.toRaw()) as AnyObject? as NSData?
      if let outData = outData {
        let tokenDict = NSKeyedUnarchiver.unarchiveObjectWithData(outData) as AnyObject? as Dictionary<String, AnyObject>?
        if let tokenDict = tokenDict {
          return Token(dictionary: tokenDict)
        } else {
          return nil
        }
      } else {
        return nil
      }
    }
    set {
      let tokenDict = newValue?.asDictionary()
      if let tokenDict = tokenDict {
        var data = NSKeyedArchiver.archivedDataWithRootObject(tokenDict)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: SIDefault.TokenKey.toRaw())
      } else {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SIDefault.TokenKey.toRaw())
      }
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  var username: String? {
    get {
      return NSUserDefaults.standardUserDefaults().objectForKey(SIDefault.UsernameKey.toRaw()) as AnyObject? as String?
    }
    set {
      if let newValue = newValue {
        NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: SIDefault.UsernameKey.toRaw())
        NSUserDefaults.standardUserDefaults().synchronize()
      } else {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SIDefault.UsernameKey.toRaw())
        NSUserDefaults.standardUserDefaults().synchronize()
      }
    }
  }
  
  var code: String? {
    get {
      return NSUserDefaults.standardUserDefaults().objectForKey(SIDefault.CodeKey.toRaw()) as AnyObject? as String?
    }
    set {
      if let newValue = newValue {
        NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: SIDefault.CodeKey.toRaw())
        NSUserDefaults.standardUserDefaults().synchronize()
      } else {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SIDefault.CodeKey.toRaw())
        NSUserDefaults.standardUserDefaults().synchronize()
      }
    }
  }
}