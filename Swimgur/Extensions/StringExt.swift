//
//  StringExt.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/7/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation

public extension String {
  func URLEncodingString() -> String {
    var result:String = CFBridgingRetain(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, self as NSString as CFStringRef, nil, "!*'();:@&=+$,/?%#[]", CFStringBuiltInEncodings.UTF8.toRaw())) as String
    return result
  }
  
  func URLDecodedString() -> String {
    var result:String = CFBridgingRetain(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (self as NSString) as CFStringRef, nil, CFStringBuiltInEncodings.UTF8.toRaw())) as String
    return result
  }
}