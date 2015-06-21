//
//  jsonDictionaryHelpers.swift
//  iCracked
//
//  Created by Joe Neuman on 10/30/14.
//  Copyright (c) 2014. All rights reserved.
//

import Foundation

func getBool(object:AnyObject?) -> Bool? {
  if let temp = object as? Bool {
    return temp
  } else if let temp = object as? NSNumber {
    return temp.boolValue
  } else if let temp = object as? Int {
    return Bool(temp)
  } else if let temp = object as? String {
    return (temp as NSString).boolValue
  } else {
    return nil
  }
}

// TODO: Currently using getDateFormatter() from Constants singleton. This should be seperated out. Possibly added to ICNetworking singleton?
// Reason for this is because NSDateFormatter is expensive to alloc
/*func getDate(object:AnyObject?) -> NSDate? {
  if let tempObject = getString(object) {
    return  ICNetworking.getDateFormatter().dateFromString(tempObject)
  } else {
    return nil
  }
}*/

func getDictionary(object:AnyObject?) -> Dictionary<String, AnyObject>? {
  return object as AnyObject? as? Dictionary<String, AnyObject>
}

func getString(object:AnyObject?) -> String? {
  if let temp: AnyObject = object as AnyObject? {
    if let temp2 = temp as? String {
      return temp2
    } else if let temp2 = temp as? Float {
      // check if it is actually an int
      if temp2 == Float(Int(temp2)) {
        return String(Int(temp2))
      } else {
        return "\(temp2)"
      }
    } else if let temp2 = temp as? Int {
      return String(temp2)
    } else {
      return nil
    }
  } else {
    return nil
  }
}

func getDouble(object:AnyObject?) -> Double? {
  if let temp: AnyObject = object as AnyObject? {
    if let temp2 = temp as? Double {
      return temp2
    } else if let temp2 = temp as? Int {
      return Double(temp2)
    } else if let temp2 = temp as? String {
      return (temp2 as NSString).doubleValue
    } else if let temp2 = temp as? NSNumber {
      // NSNumber behaves strangely, 123.456 will become 123.456001281738
      return Double(temp2)
    }else {
      return nil
    }
  } else {
    return nil
  }
}

func getFloat(object:AnyObject?) -> Float? {
  if let temp: AnyObject = object as AnyObject? {
    if let temp2 = temp as? Float {
      return temp2
    } else if let temp2 = temp as? Int {
      return Float(temp2)
    } else if let temp2 = temp as? String {
      return (temp2 as NSString).floatValue
    } else {
      return nil
    }
  } else {
    return nil
  }
}

func getArray(object:AnyObject?) -> [AnyObject]? {
  if let temp: [AnyObject] = object as? [AnyObject] {
    return temp
  } else {
    return nil
  }
}