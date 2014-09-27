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

public class CodeForm {
  public var code: String?
  public var clientID: String?
  public var clientSecret: String?
  public var grantType: String?
  
  public init() {
    
  }
  
  public func httpParametersDictionary() -> Dictionary<String, String> {
    var dictionary:Dictionary<String, String> = Dictionary()
    if let code = code { dictionary[codeFormCodeKey] = code }
    if let clientID = clientID { dictionary[codeFormClientIDKey] = clientID }
    if let clientSecret = clientSecret { dictionary[codeFormClientSecretKey] = clientSecret }
    if let grantType = grantType { dictionary[codeFormGrantTypeKey] = grantType }
    return dictionary
  }
  
  func JSONString() -> String {
    return ""
  }
}