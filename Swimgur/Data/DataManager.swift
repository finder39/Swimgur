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
public typealias DMAccountBlock = (account:Account)->()
public typealias DMErrorStringBlock = (error:NSError, desciption:String)->()
public typealias DMTokenBlock = (token:Token)->()

enum DMEngineMode {
  case Authentication
  case Query
}

class DataManager {
  
  var restConfig = RestConfig()
  let session = NSURLSession.sharedSession()
  
  class var sharedInstance:DataManager {
    struct Static {
      static let instance = DataManager()
    }
    return Static.instance
  }
  
  init() {
  }
  
  /*func setupSession(#authorization:String?) {
    var config = NSURLSessionConfiguration.defaultSessionConfiguration()
    config.HTTPAdditionalHeaders = ["Authorization" : authorization!]
  }*/
  
  func createEndpointFor(uri:String) -> String {
    return "\(self.restConfig.serviceEndpointQuery)/\(DataManager.sharedInstance.restConfig.authorizeURI)"
  }
  
  func getTokensWithForm(form:CodeForm, onCompletion:DMTokenBlock, onError:DMErrorStringBlock) {
    // TODO:
  }
  
  func getAccountWithCompletion(onCompletion:DMAccountBlock, onError:DMErrorStringBlock) {
    // TODO:
    //let data: Dictionary<String, AnyObject>? = account["data"] as AnyObject? as Dictionary<String, AnyObject>?
    
    let url = NSURL(string: self.createEndpointFor(self.restConfig.accountMeURI))
    var request = NSMutableURLRequest(URL: url)
    request.setValue("Bearer \(SIUserDefaults().token)", forHTTPHeaderField: "Authorization")
    var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
      if error {
        println(error.localizedDescription)
      }
      var err: NSError?
      var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? Dictionary<String, AnyObject>
      if err != nil {
        println(err)
        println("JSON Error \(err!.localizedDescription)")
      }
      var results: Dictionary = jsonResult! as Dictionary
      let data: Dictionary<String, AnyObject>? = results["data"] as AnyObject? as Dictionary<String, AnyObject>?
      // here is where I'd call the callback or delegate method
      dispatch_async(dispatch_get_main_queue(), {
        //doing main thread things
        onCompletion(account: Account(dictionary: data!))
      })
    })
    task.resume()
  }
}