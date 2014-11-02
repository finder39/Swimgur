//
//  SWNetworking.swift
//  Swimgur
//
//  Created by Joseph Neuman on 9/27/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

public typealias SWArrayBlock = (array:[AnyObject])->()
public typealias SWBoolBlock = (success:Bool)->()
public typealias SWDictionaryBlock = (dictionary:Dictionary<String, AnyObject>)->()
public typealias SWAccountBlock = (account:Account)->()
public typealias SWAlbumBlock = (album:GalleryAlbum)->()
public typealias SWGalleryItemArrayBlock = (galleryItems:[GalleryItem])->()
public typealias SWErrorStringBlock = (error:NSError, description:String)->()
public typealias SWTokenBlock = (token:Token)->()

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

public class SWNetworking: NSObject {
  
  public var restConfig = RestConfig()
  var configuration:NSURLSessionConfiguration!
  var session:AFHTTPSessionManager!
  var sessionUpload:AFURLSessionManager!
  
  var lastPageLoaded = -1
  
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
    session.requestSerializer = AFJSONRequestSerializer() as AFHTTPRequestSerializer
    session.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
    self.updateSessionConfigurationToken()
    
    sessionUpload = AFURLSessionManager(sessionConfiguration: configuration)
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
  
  // MARK: Image views
  
  public func setImageView(imageView:UIImageView?, withURL imageURL:String) {
    let url = NSURL(string: imageURL)
    imageView?.sd_setImageWithURL(url)
  }
  
  // MARK: Account
  
  public func getTokensWithForm(form:CodeForm, onCompletion:SWTokenBlock, onError:SWErrorStringBlock) {
    let url = self.createAuthenticationEndpointFor(self.restConfig.tokenURI)
    session.POST(url, parameters: form.httpParametersDictionary(), success: { (operation, responseObject) -> Void in
      if let responseObject = responseObject as? Dictionary<String, AnyObject> {
        SIUserDefaults().token = Token(dictionary: responseObject)
        self.updateSessionConfigurationToken()
        dispatch_async(dispatch_get_main_queue(), {
          onCompletion(token: Token(dictionary: responseObject))
        })
      }
    }) { (operation, error) -> Void in
      
    }
  }
  
  public func getTokensWithForm(form:RefreshTokenForm, onCompletion:SWTokenBlock, onError:SWErrorStringBlock) {
    let url = self.createAuthenticationEndpointFor(self.restConfig.tokenURI)
    session.POST(url, parameters: form.httpParametersDictionary(), success: { (operation, responseObject) -> Void in
      if let responseObject = responseObject as? Dictionary<String, AnyObject> {
        SIUserDefaults().token = Token(dictionary: responseObject)
        self.updateSessionConfigurationToken()
        dispatch_async(dispatch_get_main_queue(), {
          onCompletion(token: Token(dictionary: responseObject))
        })
      }
      }) { (operation, error) -> Void in
        
    }
  }
  
  public func getAccountWithCompletion(onCompletion:SWAccountBlock, onError:SWErrorStringBlock) {
    let url = self.createQueryEndpointFor(self.restConfig.accountMeURI)
    session.GET(url, parameters: nil, success: { (operation, responseObject) -> Void in
      if let data = responseObject["data"] as? Dictionary<String, AnyObject> {
        dispatch_async(dispatch_get_main_queue(), {
          onCompletion(account: Account(dictionary: data as AnyObject as Dictionary<String, AnyObject>))
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
  }
  
  public func logout() {
    SIUserDefaults().code = nil
    SIUserDefaults().token = nil
    SIUserDefaults().account = nil
    self.updateSessionConfigurationToken()
  }
  
  // MARK: Gallery
  
  public func getGalleryImagesWithSection(section:ImgurSection, sort:ImgurSort, window:ImgurWindow, page:Int, showViral:Bool, onCompletion:SWGalleryItemArrayBlock, onError:SWErrorStringBlock) {
    let url = self.createQueryEndpointFor("\(self.restConfig.galleryURI)/\(section.rawValue)/\(sort.rawValue)/\(window.rawValue)/\(page)?showViral=\(showViral)")
    session.GET(url, parameters: nil, success: { (operation, responseObject) -> Void in
      if let data = responseObject["data"] as? [AnyObject] {
        var galleryItems:[GalleryItem] = []
        for galleryDict in data {
          if (galleryDict["is_album"] as AnyObject! as Int! == 1) {
            let theDict = galleryDict as Dictionary<String, AnyObject>
            if checkForValidAlbumDictionary(theDict) {
              galleryItems.append(GalleryAlbum(dictionary: galleryDict as Dictionary<String, AnyObject>))
            }
          } else {
            galleryItems.append(GalleryImage(dictionary: galleryDict as Dictionary<String, AnyObject>))
          }
        }
        self.lastPageLoaded = page
        dispatch_async(dispatch_get_main_queue(), {
          onCompletion(galleryItems: galleryItems)
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
  }
  
  public func getGalleryImagesWithSectionNextPage(section:ImgurSection, sort:ImgurSort, window:ImgurWindow, showViral:Bool, onCompletion:SWGalleryItemArrayBlock, onError:SWErrorStringBlock) {
    getGalleryImagesWithSection(section, sort: sort, window: window, page: self.lastPageLoaded+1, showViral: showViral, onCompletion: onCompletion, onError: onError)
  }
  
  public func getAlbum(#albumId:String, onCompletion:SWAlbumBlock, onError:SWErrorStringBlock) {
    let url = self.createQueryEndpointFor("gallery/album/\(albumId)")
    session.GET(url, parameters: nil, success: { (operation, responseObject) -> Void in
      if let data = responseObject["data"] as? Dictionary<String, AnyObject> {
        dispatch_async(dispatch_get_main_queue(), {
          onCompletion(album: GalleryAlbum(dictionary: data as AnyObject as Dictionary<String, AnyObject>))
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
  }
  
  public func voteOnGalleryItem(#galleryItemId:String, vote:GalleryItemVote, onCompletion:SWBoolBlock?) {
    let url = self.createQueryEndpointFor("gallery/image/\(galleryItemId)/vote/\(vote.rawValue)")
    session.POST(url, parameters: nil, success: { (operation, responseObject) -> Void in
      if let onCompletion = onCompletion {
        // need to check for 200 status in response
        onCompletion(success: true)
      }
    }) { (operation, error) -> Void in
      
    }
  }
  
  // MARK: Upload
  public func uploadImage(toUpload:ImageUpload, onCompletion:SWBoolBlock) {
    let urlSetup = "upload"
    let url = NSURL(string: self.createQueryEndpointFor(urlSetup))
    var request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = Method.POST.rawValue
    if let token = SIUserDefaults().token?.accessToken {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    var progress:NSProgress? = nil;
    
    // set HTTPBody
    var err: NSError?
    if let data = NSJSONSerialization.dataWithJSONObject(toUpload.asDictionary(), options: nil, error: &err) {
      let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
      request.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
      
      var uploadTask = sessionUpload.uploadTaskWithRequest(request, fromData: data, progress: &progress, completionHandler: { (response, responseObject, error) -> Void in
        if error != nil {
          onCompletion(success: false)
        } else {
          onCompletion(success: true)
        }
      })
      uploadTask.resume()
    } else {
      onCompletion(success: false)
    }
  }
}