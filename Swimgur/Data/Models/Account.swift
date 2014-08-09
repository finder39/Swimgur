//
//  Account.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/8/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

public class Account {
  var id: Int
  var username: String
  var bio: String?
  var reputation: Int
  var created: Int
  var proExpiration: Int?
  
  init(dictionary:Dictionary<String, AnyObject>) {
    id = dictionary["id"] as AnyObject! as Int!
    username = dictionary["url"] as AnyObject! as String!
    bio = dictionary["bio"] as AnyObject? as? String
    reputation = dictionary["reputation"] as AnyObject! as Int!
    created = dictionary["created"] as AnyObject! as Int!
    proExpiration = dictionary["pro_expiration"] as AnyObject? as? Int
  }
}