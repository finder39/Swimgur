//
//  DataManager.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/4/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit

public typealias DMArrayBlock = (array:[AnyObject])->()
public typealias DMBlockBool = (success:Bool)->()
public typealias DMDictionaryBlock = (dictionary:Dictionary<String, AnyObject>)->()
public typealias DMAccountBlock = (account:Account)->()
public typealias DMErrorStringBlock = (error:NSError, description:String)->()
public typealias DMTokenBlock = (token:Token)->()

public enum Method: String {
  case OPTIONS = "OPTIONS"
  case GET = "GET"
  case HEAD = "HEAD"
  case POST = "POST"
  case PUT = "PUT"
  case PATCH = "PATCH"
  case DELETE = "DELETE"
  case TRACE = "TRACE"
  case CONNECT = "CONNECT"
}

public enum ImgurSection: String {
  case Hot = "hot"
  case Top = "top"
  case User = "user"
}

public enum ImgurSort: String {
  case Viral = "viral"
  case Time = "time"
}

public enum ImgurWindow: String {
  case Day = "day"
  case Week = "week"
  case Month = "month"
  case Year = "year"
  case All = "all"
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
  
  func setImageView(imageView:UIImageView, withURL imageURL:String) {
    let url = NSURL(string: imageURL)
    var dataTask = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
      if !error {
        dispatch_async(dispatch_get_main_queue(), {
          let image = UIImage(data: data)
          imageView.image = image
        })
      }
    })
    dataTask.resume()
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
    let url = NSURL(string: self.createAuthenticationEndpointFor(self.restConfig.tokenURI))
    var request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = Method.POST.toRaw()
    
    // set HTTPBody
    var err: NSError?
    if let data = NSJSONSerialization.dataWithJSONObject(form.httpParametersDictionary(), options: nil, error: &err) {
      let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
      request.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
      request.HTTPBody = data
    }
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
  
  func getTokensWithForm(form:RefreshTokenForm, onCompletion:DMTokenBlock, onError:DMErrorStringBlock) {
    let url = NSURL(string: self.createAuthenticationEndpointFor(self.restConfig.tokenURI))
    var request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = Method.POST.toRaw()
    
    // set HTTPBody
    var err: NSError?
    if let data = NSJSONSerialization.dataWithJSONObject(form.httpParametersDictionary(), options: nil, error: &err) {
      let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
      request.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
      request.HTTPBody = data
    }
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
    let url = NSURL(string: self.createQueryEndpointFor(self.restConfig.accountMeURI))
    var request = NSMutableURLRequest(URL: url)
    if let token = SIUserDefaults().token?.accessToken {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
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
  
  func getGalleryImagesWithSection(section:ImgurSection, sort:ImgurSort, window:ImgurWindow, page:Int, showViral:Bool, onCompletion:DMArrayBlock, onError:DMErrorStringBlock) {
    let urlSetup = "\(self.restConfig.galleryURI)/\(section.toRaw())/\(sort.toRaw())/\(window.toRaw())/\(page)?showViral=\(showViral)"
    let url = NSURL(string: self.createQueryEndpointFor(urlSetup))
    var request = NSMutableURLRequest(URL: url)
    if let token = SIUserDefaults().token?.accessToken {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
      if error {
        onError(error: error, description: error.localizedDescription)
        return
      }
      var err: NSError?
      var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? Dictionary<String, AnyObject>
      //println(NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err))
      if let err = err {
        onError(error: err, description: err.localizedDescription)
        return
      }
      if let jsonResult = jsonResult {
        var results: Dictionary = jsonResult as Dictionary
        if results["success"] as AnyObject? as? Int == 0 {
          let data: Dictionary<String, AnyObject>? = results["data"] as AnyObject? as? Dictionary<String, AnyObject>
          let error = data!["error"] as AnyObject? as String?
          if let error = error {
            dispatch_async(dispatch_get_main_queue(), {
              onError(error: NSError(), description: error)
            })
          } else {
            dispatch_async(dispatch_get_main_queue(), {
              onError(error: NSError(), description: "error")
            })
          }
          return
        }
        let data: [AnyObject]? = results["data"] as AnyObject? as? [AnyObject]
        
        
        if let data = data {
          var galleryItems:[GalleryItem] = []
          for galleryDict in data {
            if (galleryDict["is_album"] as AnyObject! as Int! == 1) {
              galleryItems.append(GalleryAlbum(dictionary: galleryDict as Dictionary<String, AnyObject>))
            } else {
              galleryItems.append(GalleryImage(dictionary: galleryDict as Dictionary<String, AnyObject>))
            }
          }
          dispatch_async(dispatch_get_main_queue(), {
            onCompletion(array: galleryItems)
          })
        } else {
          dispatch_async(dispatch_get_main_queue(), {
            onError(error: NSError(), description: "Data is nil")
          })
          return
        }
      } else {
        dispatch_async(dispatch_get_main_queue(), {
          onError(error: NSError(), description: "jsonResult is nil")
          })
        return
      }
    })
    task.resume()
  }
}