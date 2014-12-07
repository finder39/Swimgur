//
//  Constants.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/5/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

let Constants = ConstantsPrivate()

class ConstantsPrivate {
  class var sharedInstance:ConstantsPrivate {
    struct Static {
      static let instance = ConstantsPrivate()
    }
    return Static.instance
  }
  
  // MARK: App ID
  
  let ImgurControllerConfigClientID = "541fb8cc243d820"
  let ImgurControllerConfigSecret = "57f58dd18f68946a6310e17d9cc3093740338676"
  
  // MARK: Reuse Identifiers
  
  let ReuseIdentifier = ReuseIdentifierPrivate()
  
  class ReuseIdentifierPrivate {
    let GalleryCollectionViewCellReuseIdentifier = "GalleryCollectionViewCellReuseIdentifier"
    let GalleryCollectionViewLoadMoreCellReuseIdentifier = "GalleryCollectionViewLoadMoreCellReuseIdentifier"
    let ImgurTextCellReuseIdentifier = "ImgurTextCellReuseIdentifier"
    let CommentCellReuseIdentifier = "CommentCellReuseIdentifier"
    let ImgurImageCellReuseIdentifier = "ImgurImageCellReuseIdentifier"
    let GalleryItemInfoCellReuseIdentifier = "GalleryItemInfoCellReuseIdentifier"
  }
  
  // MARK: Segues
  
  let Segue = SeguePrivate()
  
  class SeguePrivate {
    let SegueWelcomeToMaster = "SegueWelcomeToMaster"
    let SegueGalleryToGalleryItem = "SegueGalleryToGalleryItem"
  }
  
  // MARK: Functions
  
  func encodeImageToBase64String(image:UIImage) -> String {
    return UIImagePNGRepresentation(image).base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
  }
  
  func decodeBase64ToImage(strEncodeData:String) -> UIImage {
    let data = NSData(base64EncodedString: strEncodeData, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
    return UIImage(data: data!)!
  }
}

// MARK: println addons

func dprintln<T>(object: T, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__) {
  println("<\(file.lastPathComponent):(\(line))> \(object)")
}

func dfprintln<T>(object: T, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__) {
  println("<\(file.lastPathComponent):\(function):(\(line))> \(object)")
}