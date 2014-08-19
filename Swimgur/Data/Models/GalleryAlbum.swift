//
//  GalleryAlbum.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/10/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

/*
{
"account_id" = 6967061;
"account_url" = MrZakoshi;
cover = PxJm8XI;
"cover_height" = 282;
"cover_width" = 500;
datetime = 1407628619;
description = "My collection of gifs from Futurama";
downs = 105;
favorite = 0;
id = p0vDZ;
"is_album" = 1;
layout = blog;
link = "http://imgur.com/a/p0vDZ";
nsfw = 0;
privacy = public;
score = 9546;
section = funny;
title = "I'll leave these here";
ups = 9651;
views = 0;
vote = "<null>";
}
*/

public class GalleryAlbum: GalleryItem, GalleryItemProtocol {
  let cover: String
  let coverWidth: Int
  let coverHeight: Int
  let privacy: String
  let layout: String
  var imagesCount: Int?
  var images: [AlbumImage] = []
  
  init(dictionary:Dictionary<String, AnyObject>) {
    cover = dictionary["cover"] as AnyObject! as String!
    coverWidth = dictionary["cover_width"] as AnyObject! as Int!
    coverHeight = dictionary["cover_height"] as AnyObject! as Int!
    privacy = dictionary["privacy"] as AnyObject! as String!
    layout = dictionary["layout"] as AnyObject! as String!
    imagesCount = dictionary["images_count"] as AnyObject? as? Int
    if let albumImages = (dictionary["images"] as AnyObject?) as? [Dictionary<String, AnyObject>] {
      for image in albumImages {
        self.images.append(AlbumImage(dictionary: image))
      }
    }
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
  }
  
  func squareThumbnailURIForSize(size: CGSize) -> String {
    if size.width <= 90 {
      return self.appendLetterToLink("s")
    } else if size.width <= 160 {
      return self.appendLetterToLink("b")
    } else {
      return self.link
    }
  }
  
  override func appendLetterToLink(letter:String) -> String {
    let coverLink = "http://i.imgur.com/\(self.cover).jpg"
    return coverLink.stringByReplacingOccurrencesOfString(".", withString: "\(letter).", options: NSStringCompareOptions.LiteralSearch, range: coverLink.rangeOfString(".", options: NSStringCompareOptions.BackwardsSearch))
  }
  
  func getAlbum(#onCompletion:DMAlbumBlock) {
    DataManager.sharedInstance.getAlbum(albumId: self.id, onCompletion: { (album) -> () in
      dispatch_async(dispatch_get_main_queue(), {
       onCompletion(album: album)
      })
    }) { (error, description) -> () in
      println(error)
      println(description)
    }
  }
}