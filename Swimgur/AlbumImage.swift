//
//  AlbumImage.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/19/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

public class AlbumImage {
  var id: String = ""
  var title: String?
  var description: String?
  var datetime: Int = 0
  var link: String = ""
  var ups: Int?
  var downs: Int?
  var score: Int?
  var views: Int?
  var vote: String?
  var nsfw: Bool?
  let type: String?
  let animated: Bool?
  let width: Int
  let height: Int
  let size: Int
  let bandwidth: Int
  let deletehash: String?
  let section: String?
  
  init(dictionary:Dictionary<String, AnyObject>) {
    type = dictionary["type"] as AnyObject? as? String
    animated = dictionary["animated"] as AnyObject? as? Bool
    width = dictionary["width"] as AnyObject! as Int!
    height = dictionary["height"] as AnyObject! as Int!
    size = dictionary["size"] as AnyObject! as Int!
    bandwidth = dictionary["bandwidth"] as AnyObject! as Int!
    deletehash = dictionary["deletehash"] as AnyObject? as? String
    section = dictionary["section"] as AnyObject? as? String
    id = dictionary["id"] as AnyObject! as String!
    title = dictionary["title"] as AnyObject? as? String
    description = dictionary["description"] as AnyObject? as? String
    datetime = dictionary["datetime"] as AnyObject! as Int!
    link = dictionary["link"] as AnyObject! as String!
    ups = dictionary["ups"] as AnyObject? as? Int
    downs = dictionary["downs"] as AnyObject? as? Int
    score = dictionary["score"] as AnyObject? as? Int
    views = dictionary["views"] as AnyObject? as? Int
    vote = dictionary["vote"] as AnyObject? as? String
    nsfw = dictionary["nsfw"] as AnyObject? as? Bool
  }
}