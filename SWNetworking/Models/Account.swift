//
//  Account.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/8/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

public class Account {
  public var id: Int
  public var username: String
  public var bio: String?
  public var reputation: Int
  public var created: Int
  public var proExpiration: Int?
  
  public init(dictionary:Dictionary<String, AnyObject>) {
    id = dictionary["id"] as AnyObject! as! Int!
    username = dictionary["url"] as AnyObject! as! String!
    bio = dictionary["bio"] as AnyObject? as? String
    reputation = dictionary["reputation"] as AnyObject! as! Int!
    created = dictionary["created"] as AnyObject! as! Int!
    proExpiration = dictionary["pro_expiration"] as AnyObject? as? Int
  }
  
  public func asDictionary() -> Dictionary<String, AnyObject> {
    var dictionary:Dictionary<String, AnyObject> = Dictionary()
    dictionary["id"] = id
    dictionary["url"] = username
    if let bio = bio { dictionary["bio"] = bio }
    dictionary["reputation"] = reputation
    dictionary["created"] = created
    dictionary["pro_expiration"] = proExpiration
    return dictionary
  }
}