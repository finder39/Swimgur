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
  
  private let serviceAuthorize = "oauth2"
  var serviceEndpointAuthorize = ""
  private let serviceQuery = "3"
  var serviceEndpointQuery = ""
  
  let accountURI = "account"
  let accountMeURI = "account/me"
  let authorizeURI = "authorize"
  
  let albumURI = "album"
  let albumsURI = "albums"
  let imagesURI = "images"
  let tokenURI = "token"
  
  init() { // required for initiliaze in self
    serviceEndpointAuthorize = serviceSecure ? "https://\(server)/\(serviceAuthorize)" : "http://\(server)/\(serviceAuthorize)"
    serviceEndpointQuery = serviceSecure ? "https://\(server)/\(serviceQuery)" : "http://\(server)/\(serviceQuery)"
  }
  
  func configureAuthorizeMode() {
    server = "api.imgur.com"
  }
}