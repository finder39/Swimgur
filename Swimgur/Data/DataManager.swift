//
//  DataManager.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/4/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit
import SWNetworking

class DataManager: NSObject {
  
  var galleryItems:[GalleryItem] = []
  
  class var sharedInstance:DataManager {
    struct Static {
      static let instance = DataManager()
    }
    return Static.instance
  }
  
  override init() {
    super.init()
  }
}