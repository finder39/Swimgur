//
//  SWUserDefaults.swift
//  Swimgur
//
//  Created by Joseph Neuman on 9/27/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

public enum SIDefault: String {
  case AccountKey = "account"
  case TokenKey = "token"
  case CodeKey = "code"
}

public class SIUserDefaults {
  public init() {
    
  }
  
  public var account: Account? {
    get {
      let outData = NSUserDefaults.standardUserDefaults().objectForKey(SIDefault.AccountKey.rawValue) as AnyObject? as! NSData?
      if let outData = outData {
        let accountDict = NSKeyedUnarchiver.unarchiveObjectWithData(outData) as? Dictionary<String, AnyObject>
        if let accountDict = accountDict {
          return Account(dictionary: accountDict)
        } else {
          return nil
        }
      } else {
        return nil
      }
    }
    set {
      let accountDict = newValue?.asDictionary()
      if let accountDict = accountDict {
        let data = NSKeyedArchiver.archivedDataWithRootObject(accountDict)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: SIDefault.AccountKey.rawValue)
      } else {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SIDefault.AccountKey.rawValue)
      }
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  public var token: Token? {
    get {
      let outData = NSUserDefaults.standardUserDefaults().objectForKey(SIDefault.TokenKey.rawValue) as AnyObject? as! NSData?
      if let outData = outData {
        let tokenDict = NSKeyedUnarchiver.unarchiveObjectWithData(outData) as? Dictionary<String, AnyObject>
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
        let data = NSKeyedArchiver.archivedDataWithRootObject(tokenDict)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: SIDefault.TokenKey.rawValue)
      } else {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SIDefault.TokenKey.rawValue)
      }
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  public var code: String? {
    get {
      return NSUserDefaults.standardUserDefaults().objectForKey(SIDefault.CodeKey.rawValue) as AnyObject? as! String?
    }
    set {
      if let newValue = newValue {
        NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: SIDefault.CodeKey.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
      } else {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SIDefault.CodeKey.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
      }
    }
  }
}