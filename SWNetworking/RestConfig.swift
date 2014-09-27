//
//  RestConfig.swift
//  Swimgur
//
//  Created by Joseph Neuman on 9/27/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

public class RestConfig {
  var server = "api.imgur.com"
  let serviceSecure = true
  
  private let serviceAuthorize = "oauth2"
  public var serviceAuthorizeEndpoint = ""
  private let serviceQuery = "3"
  public var serviceQueryEndpoint = ""
  
  let accountURI = "account"
  public let accountMeURI = "account/me"
  public let authorizeURI = "authorize"
  
  let albumURI = "album"
  let albumsURI = "albums"
  let imagesURI = "images"
  public let tokenURI = "token"
  public let galleryURI = "gallery"
  
  public init() { // required for initiliaze in self
    serviceAuthorizeEndpoint = serviceSecure ? "https://\(server)/\(serviceAuthorize)" : "http://\(server)/\(serviceAuthorize)"
    serviceQueryEndpoint = serviceSecure ? "https://\(server)/\(serviceQuery)" : "http://\(server)/\(serviceQuery)"
  }
  
  func configureAuthorizeMode() {
    server = "api.imgur.com"
  }
}