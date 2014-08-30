//
//  DataManager.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/4/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit

public typealias DMArrayBlock = (array:[AnyObject])->()
public typealias DMBoolBlock = (success:Bool)->()
public typealias DMDictionaryBlock = (dictionary:Dictionary<String, AnyObject>)->()
public typealias DMAccountBlock = (account:Account)->()
public typealias DMAlbumBlock = (album:GalleryAlbum)->()
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

public enum GalleryItemVote: String {
  case Up = "up"
  case Down = "down"
}

class DataManager: NSObject {
  
  var restConfig = RestConfig()
  let session = NSURLSession.sharedSession()
  var galleryItems:[GalleryItem] = []
  
  class var sharedInstance:DataManager {
    struct Static {
      static let instance = DataManager()
    }
    return Static.instance
  }
  
  override init() {
  }
  
  func setImageView(imageView:UIImageView?, withURL imageURL:String) {
    let url = NSURL(string: imageURL)
    var dataTask = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
      if !(error != nil) {
        dispatch_async(dispatch_get_main_queue(), {
          if let imageView = imageView {
            let image = UIImage(data: data)
            imageView.image = image
          }
        })
      }
    })
    dataTask.resume()
  }
  
  func setImageViewAnimated(imageView:FLAnimatedImageView?, withURL imageURL:String) {
    let url = NSURL(string: imageURL)
    var dataTask = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
      if !(error != nil) {
        dispatch_async(dispatch_get_main_queue(), {
          if let imageView = imageView {
            let image = FLAnimatedImage(animatedGIFData: data)
            imageView.animatedImage = image
          }
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
  
  private func imgurResponseParser(#data:NSData, completionHandler:((data:AnyObject, error:NSError?, errorDescription:String?) -> ())) {
    var err: NSError?
    var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? Dictionary<String, AnyObject>
    //println(NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err))
    if let err = err {
      completionHandler(data: "", error: err, errorDescription: err.localizedDescription)
      return
    }
    if let jsonResult = jsonResult {
      var results: Dictionary = jsonResult as Dictionary
      if results["success"] as AnyObject? as? Int == 0 {
        let data: Dictionary<String, AnyObject>? = results["data"] as AnyObject? as? Dictionary<String, AnyObject>
        let error = data!["error"] as AnyObject? as String?
        if let error = error {
          completionHandler(data: "", error: NSError(), errorDescription: error)
        } else {
          dispatch_async(dispatch_get_main_queue(), {
            completionHandler(data: "", error: NSError(), errorDescription: "error")
          })
        }
        return
      }
      let data: AnyObject? = results["data"] as AnyObject?
      if let data: AnyObject = data {
        completionHandler(data: data, error: nil, errorDescription: nil)
      } else {
        completionHandler(data: "", error: NSError(), errorDescription: "data is nil")
      }
    } else {
      completionHandler(data: "", error: NSError(), errorDescription: "jsonResult is nil")
    }
  }
  
  // MARK: Account
  
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
      if (error != nil) {
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
      if (error != nil) {
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
      /*if error {
        onError(error: error, description: error.localizedDescription)
        return
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
      })*/
      
      if (error != nil) {
        onError(error: error, description: error.localizedDescription)
        return
      }
      self.imgurResponseParser(data: data, completionHandler: { (data, error, errorDescription) -> () in
        if errorDescription != nil {
          dispatch_async(dispatch_get_main_queue(), {
            onError(error: error!, description: errorDescription!)
          })
        } else {
          let data = data as Dictionary<String, AnyObject>
          dispatch_async(dispatch_get_main_queue(), {
            onCompletion(account: Account(dictionary: data))
          })
        }
      })
    })
    task.resume()
  }
  
  func logout() {
    SIUserDefaults().code = nil
    SIUserDefaults().token = nil
    SIUserDefaults().account = nil
  }
  
  // MARK: Gallery
  
  func getGalleryImagesWithSection(section:ImgurSection, sort:ImgurSort, window:ImgurWindow, page:Int, showViral:Bool, onCompletion:DMArrayBlock, onError:DMErrorStringBlock) {
    let urlSetup = "\(self.restConfig.galleryURI)/\(section.toRaw())/\(sort.toRaw())/\(window.toRaw())/\(page)?showViral=\(showViral)"
    let url = NSURL(string: self.createQueryEndpointFor(urlSetup))
    var request = NSMutableURLRequest(URL: url)
    if let token = SIUserDefaults().token?.accessToken {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
      if (error != nil) {
        onError(error: error, description: error.localizedDescription)
        return
      }
      self.imgurResponseParser(data: data, completionHandler: { (data, error, errorDescription) -> () in
        if errorDescription != nil {
          dispatch_async(dispatch_get_main_queue(), {
            onError(error: error!, description: errorDescription!)
          })
        } else {
          let data = data as [AnyObject]
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
        }
      })
    })
    task.resume()
  }
  
  func getAlbum(#albumId:String, onCompletion:DMAlbumBlock, onError:DMErrorStringBlock) {
    let urlSetup = "gallery/album/\(albumId)"
    let url = NSURL(string: self.createQueryEndpointFor(urlSetup))
    var request = NSMutableURLRequest(URL: url)
    if let token = SIUserDefaults().token?.accessToken {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
      if (error != nil) {
        onError(error: error, description: error.localizedDescription)
        return
      }
      self.imgurResponseParser(data: data, completionHandler: { (data, error, errorDescription) -> () in
        if errorDescription != nil {
          dispatch_async(dispatch_get_main_queue(), {
            onError(error: error!, description: errorDescription!)
          })
        } else {
          let data = data as Dictionary<String, AnyObject>
          dispatch_async(dispatch_get_main_queue(), {
            onCompletion(album: GalleryAlbum(dictionary: data as AnyObject as Dictionary<String, AnyObject>))
          })
        }
      })
    })
    task.resume()
  }
  
  // https://api.imgur.com/3/gallery/{id}/vote/{vote}
  
  func voteOnGalleryItem(#galleryItemId:String, vote:GalleryItemVote, onCompletion:DMBoolBlock?) {
    let urlSetup = "gallery/image/\(galleryItemId)/vote/\(vote.toRaw())"
    let url = NSURL(string: self.createQueryEndpointFor(urlSetup))
    var request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = Method.POST.toRaw()
    if let token = SIUserDefaults().token?.accessToken {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
      if let onCompletion = onCompletion {
        // need to check for 200 status in response
        onCompletion(success: true)
      }
    })
    task.resume()
  }
}