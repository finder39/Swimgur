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
  public var id: String = ""
  public var title: String = ""
  public var description: String?
  public var datetime: Int = 0
  public var link: String = ""
  public var accountURL: String?
  public var accountID: Int?
  public var ups: Int = 0
  public var downs: Int = 0
  public var score: Int = 0
  public var isAlbum: Bool = false
  public var views: Int = 0
  public var favorite: Bool = false
  public var vote: String?
  public var nsfw: Bool?
  
  init() {
    
  }
  
  public func appendLetterToLink(letter:String) -> String {
    return self.link.stringByReplacingOccurrencesOfString(".", withString: "\(letter).", options: NSStringCompareOptions.LiteralSearch, range: self.link.rangeOfString(".", options: NSStringCompareOptions.BackwardsSearch))
  }
  
  public func vote(vote:GalleryItemVote) {
    //DataManager.sharedInstance.voteOnGalleryItem(galleryItemId: self.id, vote: vote, onCompletion: nil) // TODO: 
  }
}