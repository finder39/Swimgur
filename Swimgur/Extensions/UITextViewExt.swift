//
//  UITextViewExt.swift
//  Swimgur
//
//  Created by Joseph Neuman on 10/5/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

public extension UITextView {
  public func getTextHeight() -> CGFloat {
    let fixedWidth = self.frame.size.width
    let newSize = self.sizeThatFits(CGSizeMake(fixedWidth, CGFloat.max))
    return newSize.height
  }
  
  public func getTextHeight(width width:CGFloat) -> CGFloat {
    let newSize = self.sizeThatFits(CGSizeMake(width, CGFloat.max))
    return newSize.height
  }
  
  public func autoHeight() {
    let fixedWidth = self.frame.size.width
    let newSize = self.sizeThatFits(CGSizeMake(fixedWidth, CGFloat.max))
    var newFrame = self.frame
    newFrame.size = CGSizeMake(CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), newSize.height)
    self.frame = newFrame
  }
}