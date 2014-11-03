//
//  GalleryImage.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/10/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

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

public class GalleryImage: GalleryItem, GalleryItemProtocol {
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
    super.init()
    id = dictionary["id"] as AnyObject! as String!
    title = dictionary["title"] as AnyObject! as String!
    description = dictionary["description"] as AnyObject? as? String
    datetime = dictionary["datetime"] as AnyObject! as Int!
    link = dictionary["link"] as AnyObject! as String!
    accountURL = dictionary["account_url"] as AnyObject? as? String
    accountID = dictionary["account_id"] as AnyObject? as? Int
    ups = dictionary["ups"] as AnyObject! as Int!
    downs = dictionary["downs"] as AnyObject! as Int!
    score = dictionary["score"] as AnyObject! as Int!
    isAlbum = dictionary["is_album"] as AnyObject! as Bool!
    views = dictionary["views"] as AnyObject! as Int!
    favorite = dictionary["favorite"] as AnyObject! as Bool!
    vote = dictionary["vote"] as AnyObject? as? String
    nsfw = dictionary["nsfw"] as AnyObject? as? Bool
    
    self.setupTableViewDataSourceArray()
  }
  
  public func squareThumbnailURIForSize(size: CGSize) -> String {
    if size.width <= 90 {
      return self.appendLetterToLink("s")
    } else if size.width <= 160 {
      return self.appendLetterToLink("b")
    } else {
      return self.link
    }
  }
  
  internal func setupTableViewDataSourceArray() {
    tableViewDataSourceArray.removeAll(keepCapacity: false)
    tableViewDataSourceArray.append(GalleryItemTableItem(type: .Image, text: link))
    if let description = description {
      tableViewDataSourceArray.append(GalleryItemTableItem(type: .Description, text: description))
    }
  }
}