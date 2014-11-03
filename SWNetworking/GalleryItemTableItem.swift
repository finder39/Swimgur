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
  
  public init(type:GalleryItemTableItemType, text:String) {
    self.type = type
    self.text = text
  }
}