//
//  GalleryImage.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/10/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

/*
{
"account_id" = 13633050;
"account_url" = rachelfank;
animated = 0;
bandwidth = 0;
datetime = 1407636911;
description = "<null>";
downs = 133;
favorite = 0;
height = 1280;
id = 0JQMUaZ;
"is_album" = 0;
link = "http://i.imgur.com/0JQMUaZ.jpg";
nsfw = 0;
score = 6561;
section = funny;
size = 101973;
title = "My 13 year old nephew turns into a 70 year old Asian when he eats it skateboarding";
type = "image/jpeg";
ups = 5842;
views = 0;
vote = "<null>";
width = 720;
}
*/

class GalleryImage: GalleryItem {
  let type: String?
  let animated: Bool?
  let width: Int
  let height: Int
  let size: Int
  let views: Int
  let bandwidth: Int
  let deletehash: String?
  let link: String
  let vote: String?
  let favorite: Bool
  let nsfw: Bool?
  let section: String?
  let accountURL: String?
  let accountID: Int?
  let ups: Int
  let downs: Int
  let score: Int
  let isAlbum: Bool
  
  init(dictionary:Dictionary<String, AnyObject>) {
    type = dictionary["type"] as AnyObject? as? String
    animated = dictionary["animated"] as AnyObject? as? Bool
    width = dictionary["width"] as AnyObject! as Int!
    height = dictionary["height"] as AnyObject! as Int!
    size = dictionary["size"] as AnyObject! as Int!
    views = dictionary["views"] as AnyObject! as Int!
    bandwidth = dictionary["bandwidth"] as AnyObject! as Int!
    deletehash = dictionary["deletehash"] as AnyObject? as? String
    link = dictionary["link"] as AnyObject! as String!
    vote = dictionary["vote"] as AnyObject? as? String
    favorite = dictionary["favorite"] as AnyObject! as Bool!
    nsfw = dictionary["nsfw"] as AnyObject? as? Bool
    section = dictionary["section"] as AnyObject? as? String
    accountURL = dictionary["account_url"] as AnyObject? as? String
    accountID = dictionary["account_id"] as AnyObject? as? Int
    ups = dictionary["ups"] as AnyObject! as Int!
    downs = dictionary["downs"] as AnyObject! as Int!
    score = dictionary["score"] as AnyObject! as Int!
    isAlbum = dictionary["is_album"] as AnyObject! as Bool!
    super.init()
    id = dictionary["id"] as AnyObject! as String!
    title = dictionary["title"] as AnyObject! as String!
    description = dictionary["description"] as AnyObject? as? String
    datetime = dictionary["datetime"] as AnyObject! as Int!
  }
}