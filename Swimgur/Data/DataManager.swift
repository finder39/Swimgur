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
  
  func createQueryEndpointFor(uri:String) -> String {
    return "\(self.restConfig.serviceQueryEndpoint)/\(uri)"
  }
  
  func createAuthenticationEndpointFor(uri:String) -> String {
    return "\(self.restConfig.serviceAuthorizeEndpoint)/\(uri)"
  }
  
  func getTokensWithForm(form:CodeForm, onCompletion:DMTokenBlock, onError:DMErrorStringBlock) {
    // TODO:
    let url = NSURL(string: self.createAuthenticationEndpointFor(self.restConfig.tokenURI))
    var request = NSMutableURLRequest(URL: url)
    for (key, value) in form.httpParametersDictionary() { // TODO: This needs to be the body, not headers
      request.setValue(value, forHTTPHeaderField: key)
    }
    println(request)
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
      // here is where I'd call the callback or delegate method
      dispatch_async(dispatch_get_main_queue(), {
        //doing main thread things
        onCompletion(token: Token(dictionary: results))
      })
    })
    task.resume()
  }
  
  func getAccountWithCompletion(onCompletion:DMAccountBlock, onError:DMErrorStringBlock) {
    // TODO:
    //let data: Dictionary<String, AnyObject>? = account["data"] as AnyObject? as Dictionary<String, AnyObject>?
    
    let url = NSURL(string: self.createQueryEndpointFor(self.restConfig.accountMeURI))
    var request = NSMutableURLRequest(URL: url)
    request.setValue("Bearer \(SIUserDefaults().token)", forHTTPHeaderField: "Authorization")
    println(request)
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