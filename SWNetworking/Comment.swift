//
//  Comment.swift
//  Swimgur
//
//  Created by Joseph Neuman on 11/2/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

public class Comment {
  public var id: Int!
  public var imageID: String?
  public var comment: String?
  public var author: String?
  public var authorID: String?
  public var onAlbum: Bool?
  public var albumCover: String?
  public var ups: Int?
  public var downs: Int?
  public var points: Int?
  public var datetime: Int = 0
  public var parentID: String?
  public var deleted: Bool?
  public var vote: String?
  public var children: [Comment] = []
  
  public init(dictionary:Dictionary<String, AnyObject>) {
    id = dictionary["id"] as AnyObject! as Int!
    imageID = dictionary["image_id"] as AnyObject? as? String
    comment = dictionary["comment"] as AnyObject? as? String
    author = dictionary["author"] as AnyObject? as? String
    authorID = dictionary["author_id"] as AnyObject? as? String
    onAlbum = dictionary["on_album"] as AnyObject? as? Bool
    albumCover = dictionary["album_cover"] as AnyObject? as? String
    ups = dictionary["ups"] as AnyObject? as? Int
    downs = dictionary["downs"] as AnyObject? as? Int
    points = dictionary["points"] as AnyObject? as? Int
    datetime = dictionary["datetime"] as AnyObject! as Int!
    parentID = dictionary["parent_id"] as AnyObject? as? String
    deleted = dictionary["deleted"] as AnyObject? as? Bool
    vote = dictionary["vote"] as AnyObject? as? String
    if let children = (dictionary["children"] as AnyObject?) as? [Dictionary<String, AnyObject>] {
      for child in children {
        self.children.append(Comment(dictionary: child))
      }
    }
  }
}