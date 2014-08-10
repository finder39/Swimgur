//
//  Token.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/8/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

private let tokenAccessTokenKey = "access_token";
private let tokenAccountUsernameKey = "account_username";
private let tokenExpiresInKey = "expires_in";
private let tokenRefreshTokenKey = "refresh_token";
private let tokenScopeKey = "scope";
private let tokenTokenTypeKey = "token_type";

public class Token {
  var accessToken: String?
  var accountUsername: String?
  var expiresIn: UInt?
  var refreshToken: String?
  var scope: String?
  var tokenType: String?
  
  init(dictionary:Dictionary<String, AnyObject>) {
    accessToken = dictionary[tokenAccessTokenKey] as AnyObject? as String?
    accountUsername = dictionary[tokenAccountUsernameKey] as AnyObject? as String?
    expiresIn = dictionary[tokenExpiresInKey] as AnyObject? as UInt?
    refreshToken = dictionary[tokenRefreshTokenKey] as AnyObject? as String?
    scope = dictionary[tokenScopeKey] as AnyObject? as? String
    tokenType = dictionary[tokenTokenTypeKey] as AnyObject? as String?
  }
  
  func asDictionary() -> Dictionary<String, AnyObject> {
    var dictionary:Dictionary<String, AnyObject> = Dictionary()
    if let accessToken = accessToken { dictionary[tokenAccessTokenKey] = accessToken }
    if let accountUsername = accountUsername { dictionary[tokenAccountUsernameKey] = accountUsername }
    if let expiresIn = expiresIn { dictionary[tokenExpiresInKey] = expiresIn }
    if let refreshToken = refreshToken { dictionary[tokenRefreshTokenKey] = refreshToken }
    if let scope = scope { dictionary[tokenScopeKey] = scope }
    if let tokenType = tokenType { dictionary[tokenTokenTypeKey] = tokenType }
    return dictionary
  }
}