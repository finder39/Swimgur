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

class GalleryItem {
  var id: String = ""
  var title: String = ""
  var description: String?
  var datetime: Int = 0
  var link: String = ""
  
  init() {
    
  }
  
  func appendLetterToLink(letter:String) -> String {
    return self.link.stringByReplacingOccurrencesOfString(".", withString: "\(letter).", options: NSStringCompareOptions.LiteralSearch, range: self.link.rangeOfString(".", options: NSStringCompareOptions.BackwardsSearch))
  }
}