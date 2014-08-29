//
//  GalleryItem.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/10/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

protocol GalleryItemProtocol {
  func squareThumbnailURIForSize(size:CGSize) -> String
}

public class GalleryItem {
  var id: String = ""
  var title: String = ""
  var description: String?
  var datetime: Int = 0
  var link: String = ""
  var accountURL: String?
  var accountID: Int?
  var ups: Int = 0
  var downs: Int = 0
  var score: Int = 0
  var isAlbum: Bool = false
  var views: Int = 0
  var favorite: Bool = false
  var vote: String?
  var nsfw: Bool?
  
  init() {
    
  }
  
  func appendLetterToLink(letter:String) -> String {
    return self.link.stringByReplacingOccurrencesOfString(".", withString: "\(letter).", options: NSStringCompareOptions.LiteralSearch, range: self.link.rangeOfString(".", options: NSStringCompareOptions.BackwardsSearch))
  }
  
  func vote(vote:GalleryItemVote) {
    DataManager.sharedInstance.voteOnGalleryItem(galleryItemId: self.id, vote: vote, onCompletion: nil)
  }
}