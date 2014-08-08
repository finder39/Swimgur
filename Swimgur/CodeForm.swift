//
//  CodeForm.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/8/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

private let codeFormCodeKey = "code"
private let codeFormClientIDKey = "client_id"
private let codeFormClientSecretKey = "client_secret"
private let codeFormGrantTypeKey = "grant_type"

class CodeForm {
  var code: String?
  var clientID: String?
  var clientSecret: String?
  var grantType: String?
  
  init() {
    
  }
  
  func httpParametersDictionary() -> Dictionary<String, String> {
    var dictionary:Dictionary<String, String> = Dictionary()
    if let codeUnwrapped = code { dictionary[codeFormCodeKey] = codeUnwrapped }
    if let clientIDUnwrapped = clientID { dictionary[codeFormClientIDKey] = clientIDUnwrapped }
    if let clientSecretUnwrapped = code { dictionary[codeFormClientSecretKey] = clientSecretUnwrapped }
    if let grantTypeUnwrapped = grantType { dictionary[codeFormGrantTypeKey] = grantTypeUnwrapped }
    return dictionary
  }
  
  func JSONString() -> String {
    return ""
  }
}