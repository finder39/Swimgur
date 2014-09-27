//
//  SWNetworking.swift
//  Swimgur
//
//  Created by Joseph Neuman on 9/27/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

public typealias SWArrayBlock = (array:[AnyObject])->()
public typealias SWBoolBlock = (success:Bool)->()
public typealias SWDictionaryBlock = (dictionary:Dictionary<String, AnyObject>)->()
public typealias SWAccountBlock = (account:Account)->()
public typealias SWAlbumBlock = (album:GalleryAlbum)->()
public typealias SWErrorStringBlock = (error:NSError, description:String)->()
public typealias SWTokenBlock = (token:Token)->()

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

public class SWNetworking: NSObject {
  
  var restConfig = RestConfig()
  var configuration:NSURLSessionConfiguration!
  var session:AFHTTPSessionManager!
  
  //var galleryItems:[GalleryItem] = []
  
  public class var sharedInstance:SWNetworking {
  struct Static {
    static let instance = SWNetworking()
    }
    return Static.instance
  }
  
  override init() {
    super.init()
    
    configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    session = AFHTTPSessionManager(sessionConfiguration: configuration)
    session.requestSerializer = AFJSONRequestSerializer()
    session.responseSerializer = AFJSONResponseSerializer()
    self.updateSessionConfigurationToken()
  }
  
  func updateSessionConfigurationToken() {
    if let token = SIUserDefaults().token?.accessToken {
      session.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    } else {
      session.requestSerializer.setValue(nil, forHTTPHeaderField: "Authorization")
    }
  }
  
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
  
  public func getGalleryImagesWithSection(section:ImgurSection, sort:ImgurSort, window:ImgurWindow, page:Int, showViral:Bool, onCompletion:SWArrayBlock, onError:SWErrorStringBlock) {
    let url = "\(self.restConfig.galleryURI)/\(section.toRaw())/\(sort.toRaw())/\(window.toRaw())/\(page)?showViral=\(showViral)"
    session.GET(self.createQueryEndpointFor(url), parameters: nil, success: { (operation, responseObject) -> Void in
      if let data = responseObject["data"] as? [AnyObject] {
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
          onError(error: NSError(), description: "No data was returned")
        })
      }
    }) { (operation, error) -> Void in
      dispatch_async(dispatch_get_main_queue(), {
        onError(error: error, description: error.description)
      })
    }
    
    /*self.imgurResponseParser(data: data, completionHandler: { (data, error, errorDescription) -> () in
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
    })*/
  }
}