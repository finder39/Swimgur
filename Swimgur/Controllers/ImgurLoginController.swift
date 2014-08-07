//
//  ImgurLoginController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/5/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit

// Type of authentication
public enum ImgurLoginAuthType:String {
  case ImgurLoginAuthTypeToken = "token"
  case ImgurLoginAuthTypePin = "pin"
  case ImgurLoginAuthTypeCode = "code"
}

class ImgurLoginController {
  
  var authorizationClosure:DMBlockBool?
  var authType:ImgurLoginAuthType = .ImgurLoginAuthTypeCode
  var webView:UIWebView = UIWebView()
  
  func authorizeWithViewController(viewController:UIViewController, completionBlock:DMBlockBool) {
    authorizationClosure = completionBlock
    
    // https://api.imgur.com/oauth2/authorize?client_id=49fe065e4663928&response_type=code&state=auth
    
    let urlString = "\(DataManager.sharedInstance.restConfig.serviceURLString())/\(DataManager.sharedInstance.restConfig.serviceAuthorize)/\(DataManager.sharedInstance.restConfig.authorizeURI)?client_id=49fe065e4663928&response_type=\(authType.toRaw())&state=auth"
    
    println(urlString)
  }
}