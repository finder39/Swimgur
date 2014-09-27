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
  public var image: String
  public var album: String?
  public var type: ImageUploadType?
  public var name: String?
  public var title: String?
  public var description: String?
  
  public init(imageB64:String) {
    image = imageB64
    type = .Base64
  }
  
  public func asDictionary() -> Dictionary<String, String> {
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