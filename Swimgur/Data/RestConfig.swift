//
//  RestConfig.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/7/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

class RestConfig {
  var server = "api.imgur.com"
  let serviceSecure = true
  
  var serviceEndpoint = RestConfig().server
  let serviceAuthorize = "oauth2"
  let serviceQuery = "3"
  
  let accountURI = "account"
  let accountMeURI = "account/me"
  let authorizeURI = "authorize"
  
  let albumURI = "album"
  let albumsURI = "albums"
  let imagesURI = "images"
  let tokenURI = "token"
  
  init() { // required for initiliaze in self
    
  }
  
  func configureAuthorizeMode() {
    server = "api.imgur.com"
  }
  
  func configureQueryMods() {
    serviceEndpoint = "\(server)/\(serviceAuthorize)"
  }
  
  func serviceURLString() -> String {
    return serviceSecure ? "https://\(serviceEndpoint)" : "http://\(serviceEndpoint)"
  }
}