//
//  AlbumImage.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/19/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

public class AlbumImage {
  public var id: String = ""
  public var title: String?
  public var description: String?
  public var datetime: Int = 0
  public var link: String = ""
  public var ups: Int?
  public var downs: Int?
  public var score: Int?
  public var views: Int?
  public var vote: String?
  public var nsfw: Bool?
  public let type: String?
  public let animated: Bool?
  public let width: Int
  public let height: Int
  public let size: Int
  public let bandwidth: Int
  public let deletehash: String?
  public let section: String?
  
  public init(dictionary:Dictionary<String, AnyObject>) {
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