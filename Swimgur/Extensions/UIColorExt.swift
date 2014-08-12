//
//  UIColorExt.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/5/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit

private extension UIColor {
  
  private class func RGBColor(#red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
  }
}

/*
// Colors
"Frame color" = #2B2B2B
"Background color" = #181817
"Upvote color" = #85BF25
"Point bar upvote color" = #38491B
"Downvote color" = #EE4444
"Point bar downvote color" = #572424
"Name color" = #4E76C9
"Text color" = #DDDDD1
*/

public class UIColorEXT {
  public class func FrameColor() -> UIColor {
    return UIColor.RGBColor(red: 43, green: 43, blue: 43)
  }
  
  public class func BackgroundColor() -> UIColor {
    return UIColor.RGBColor(red: 24, green: 24, blue: 23)
  }
  
  public class func UpvoteColor() -> UIColor {
    return UIColor.RGBColor(red: 133, green: 191, blue: 37)
  }
  
  public class func PointBarUpvoteColor() -> UIColor {
    return UIColor.RGBColor(red: 56, green: 73, blue: 27)
  }
  
  public class func DownvoteColor() -> UIColor {
    return UIColor.RGBColor(red: 238, green: 68, blue: 68)
  }
  
  public class func PointBarDownvoteColor() -> UIColor {
    return UIColor.RGBColor(red: 87, green: 36, blue: 36)
  }
  
  public class func NameColor() -> UIColor {
    return UIColor.RGBColor(red: 78, green: 118, blue: 201)
  }
  
  public class func TextColor() -> UIColor {
    return UIColor.RGBColor(red: 221, green: 221, blue: 209)
  }
}