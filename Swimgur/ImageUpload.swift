//
//  ImageUpload.swift
//  Swimgur
//
//  Created by Joseph Neuman on 9/20/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

public enum ImageUploadType:String {
  case File = "file"
  case Base64 = "base64"
  case URL = "URL"
}

public class ImageUpload {
  var image: String
  var album: String?
  var type: ImageUploadType?
  var name: String?
  var title: String?
  var description: String?
  
  init(imageB64:String) {
    image = imageB64
    type = .Base64
  }
  
  func asDictionary() -> Dictionary<String, String> {
    var dictionary:Dictionary<String, String> = Dictionary()
    dictionary["image"] = image
    dictionary["album"] = album
    dictionary["type"] = type?.toRaw()
    dictionary["name"] = name
    dictionary["title"] = title
    dictionary["description"] = description
    return dictionary
  }
}