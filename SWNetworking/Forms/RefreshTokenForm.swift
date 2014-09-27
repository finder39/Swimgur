//
//  RefreshTokenForm.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/9/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

private let refreshTokenFornRefreshTokenKey = "refresh_token"
private let refreshTokenFornClientIDKey = "client_id"
private let refreshTokenFornClientSecretKey = "client_secret"
private let refreshTokenFornGrantTypeKey = "grant_type"

public class RefreshTokenForm {
  public var refreshToken: String?
  public var clientID: String?
  public var clientSecret: String?
  public var grantType: String?
  
  public init() {
    
  }
  
  public func httpParametersDictionary() -> Dictionary<String, String> {
    var dictionary:Dictionary<String, String> = Dictionary()
    if let refreshToken = refreshToken { dictionary[refreshTokenFornRefreshTokenKey] = refreshToken }
    if let clientID = clientID { dictionary[refreshTokenFornClientIDKey] = clientID }
    if let clientSecret = clientSecret { dictionary[refreshTokenFornClientSecretKey] = clientSecret }
    if let grantType = grantType { dictionary[refreshTokenFornGrantTypeKey] = grantType }
    return dictionary
  }
  
  func JSONString() -> String {
    return ""
  }
}