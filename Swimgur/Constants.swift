//
//  Constants.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/5/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
  let ImgurControllerConfigClientID = "541fb8cc243d820"
  let ImgurControllerConfigSecret = "57f58dd18f68946a6310e17d9cc3093740338676"
  
  func encodeImageToBase64String(image:UIImage) -> String {
    return UIImagePNGRepresentation(image).base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
  }
  
  func decodeBase64ToImage(strEncodeData:String) -> UIImage {
    let data = NSData(base64EncodedString: strEncodeData, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
    return UIImage(data: data!)!
  }
}