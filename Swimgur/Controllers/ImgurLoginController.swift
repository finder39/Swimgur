//
//  ImgurLoginController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/5/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit
import SWNetworking

// Type of authentication
public enum ImgurLoginAuthType:String {
  case ImgurLoginAuthTypeToken = "token"
  case ImgurLoginAuthTypePin = "pin"
  case ImgurLoginAuthTypeCode = "code"
}

class ImgurLoginController : NSObject, UIWebViewDelegate {
  
  var authorizationClosure:SWBoolBlock?
  var authType:ImgurLoginAuthType = .ImgurLoginAuthTypeCode
  var imgurLoginViewController:UIViewController = UIViewController()
  var webView:UIWebView = UIWebView()
  
  override init() {
    webView.frame = imgurLoginViewController.view.frame
    imgurLoginViewController.view.addSubview(webView)
  }
  
  func authorizeWithViewController(viewController:UIViewController, completionBlock:SWBoolBlock) {
    authorizationClosure = completionBlock
    
    // https://api.imgur.com/oauth2/authorize?client_id=541fb8cc243d820&response_type=code&state=auth
    
    let urlString = "\(SWNetworking.sharedInstance.restConfig.serviceAuthorizeEndpoint)/\(SWNetworking.sharedInstance.restConfig.authorizeURI)?client_id=\(Constants.ImgurControllerConfigClientID)&response_type=\(authType.rawValue)&state=auth"
    
    webView.delegate = self
    webView.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
    
    if viewController.view.window != nil {
      viewController.presentViewController(imgurLoginViewController, animated: true, completion: nil)
    }
  }
  
  // TODO: verifyStoredAccountWithCompletionBlock
  
  func verifyStoredAccount(onCompletion onCompletion:SWBoolBlock) {
    self.authorizationClosure = onCompletion
    
    let token:Token? = SIUserDefaults().token
    //if code == "" { code = nil }
    if let token = token {
      self.getTokensFromRefresh(token)
    } else {
      onCompletion(success: false)
    }
  }
  
  private func authorizationSucceeded(success:Bool) {
    // remove webview from view controller
    //webView.removeFromSuperview()
    //webView = UIWebView() // reinitiate
    
    // fire completion block
    if let authorizationClosureUnwrapped = authorizationClosure {
      authorizationClosureUnwrapped(success: success)
      authorizationClosure = nil;
    }
  }
  
  private func parseQuery(string:String) -> Dictionary<String, String> {
    let components:[String] = string.componentsSeparatedByString("&")
    var recievedDict:Dictionary<String, String> = Dictionary()
    for component in components {
      let parts = component.componentsSeparatedByString("=")
      if parts.count == 2 {
        recievedDict[parts[0]] = parts[1]
      }
    }
    return recievedDict
  }
  
  private func getTokensFromCode(code:String) {
    let form = CodeForm()
    form.code = code
    form.clientID = Constants.ImgurControllerConfigClientID
    form.clientSecret = Constants.ImgurControllerConfigSecret
    form.grantType = "authorization_code"
    SWNetworking.sharedInstance.getTokensWithForm(form, onCompletion: { (token) -> () in
      self.getAccount()
    }) { (error, description) -> () in
      self.authorizationSucceeded(false)
    }
  }
  
  private func getTokensFromRefresh(token:Token) {
    let form = RefreshTokenForm()
    form.refreshToken = token.refreshToken
    form.clientID = Constants.ImgurControllerConfigClientID
    form.clientSecret = Constants.ImgurControllerConfigSecret
    form.grantType = "refresh_token"
    SWNetworking.sharedInstance.getTokensWithForm(form, onCompletion: { (token) -> () in
      self.getAccount()
      }) { (error, description) -> () in
        self.authorizationSucceeded(false)
    }
  }
  
  private func getAccount() {
    SWNetworking.sharedInstance.getAccountWithCompletion({ (account) -> () in
      SIUserDefaults().account = account
      self.authorizationSucceeded(true)
      /*if account != nil {
        //println("Retrieved account information: \(account.description)")
        
        SIUserDefaults().username = account.username // TODO: store the whole account
        self.authorizationSucceeded(true)
      } else {
        self.authorizationSucceeded(false)
      }*/
    }, onError: { (error, description) -> () in
      print("Failed to retrieve account information")
      self.authorizationSucceeded(false)
    })
  }
  
  private func webView(webView:UIWebView, didAuthenticateWithRedirectURLString redirectURLString:String) {
    let responseDictionary = parseQuery(redirectURLString)
    let code = responseDictionary["code"]
    SIUserDefaults().code = code
    self.getTokensFromCode(code!) // TODO: check it can explicitly unwrap
  }
  
  // MARK: UIWebViewDelegate
  
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    // Once user logs in we will get their goodies in the ridirect URL. Example:
    // https://imgur.com/?state=auth&code=860381d0651a8c24079aa13c8732567d8a3f7bab
    let redirectedURLString  = request.URL?.absoluteString.URLDecodedString()
    if redirectedURLString?.rangeOfString("code=")?.startIndex != nil {
      self.webView(webView, didAuthenticateWithRedirectURLString: redirectedURLString!)
      webView.stopLoading()
      imgurLoginViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
        
      })
    }
    return true
  }
  
  @objc func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    // self.authorizationSucceeded(false) // causing failure of login
  }
}