//
//  ImgurLoginController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/5/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit

// Type of authentication
public enum ImgurLoginAuthType {
  case ImgurLoginAuthTypeToken
  case ImgurLoginAuthTypePin
  case ImgurLoginAuthTypeCode
}

class ImgurLoginController {
  
  var authorizationClosure:DMBlockBool?
  
  func authorizeWithViewController(viewController:UIViewController, completionBlock:DMBlockBool) {
    authorizationClosure = completionBlock
  }
}