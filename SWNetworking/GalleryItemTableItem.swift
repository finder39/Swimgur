//
//  GalleryItemTableItem.swift
//  Swimgur
//
//  Created by Joseph Neuman on 11/2/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

public enum GalleryItemTableItemType {
  case Image
  case Title
  case Description
  case Comment
}

public class GalleryItemTableItem {
  public var type:GalleryItemTableItemType!
  public var text:String
  public weak var associatedGalleryImage:GalleryImage?
  public weak var associatedAlbumImage:AlbumImage?
  public weak var associatedComment:Comment?
  
  public init(type:GalleryItemTableItemType, text:String, image:GalleryImage) {
    self.type = type
    self.text = text
    self.associatedGalleryImage = image
  }
  
  public init(type:GalleryItemTableItemType, text:String, image:AlbumImage) {
    self.type = type
    self.text = text
    self.associatedAlbumImage = image
  }
  
  public init(comment:Comment) {
    self.type = .Comment
    if let commentText = comment.comment {
      self.text = commentText
    } else {
      self.text = ""
    }
    self.associatedComment = comment
  }
}