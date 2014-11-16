//
//  InfiniteScrollView.swift
//  Swimgur
//
//  Created by Joseph Neuman on 11/15/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

class InfiniteScrollView: UIScrollView {
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let pageWidth = self.frame.size.width
    var fractionalPage = self.contentOffset.x / pageWidth
    let page = lround(Double(fractionalPage))
    if 1 != page {
      if 1 < page {
        self.contentOffset = CGPointMake(self.contentOffset.x-(subviews.first! as UIView).frame.size.width, self.contentOffset.y)
        for view in subviews {
          if let view = view as? UIView {
            view.frame.origin.x = view.frame.origin.x - view.frame.size.width
          }
        }
      } else {
        self.contentOffset = CGPointMake(self.contentOffset.x+(subviews.first! as UIView).frame.size.width, self.contentOffset.y)
        for view in subviews {
          if let view = view as? UIView {
            view.frame.origin.x = view.frame.origin.x + view.frame.size.width
          }
        }
      }
      //previousPage = page
    }
    
    /*let currentOffset = self.contentOffset
    let contentWidth = self.contentSize.width
    let centerOffsetX = (contentWidth-self.bounds.size.width) / 2.0
    let distanceFromCenter = fabs(currentOffset.x - centerOffsetX)
    
    if distanceFromCenter > contentWidth/4.0 {
      self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y)
      
      for view in subviews {
        
      }
    }*/
  }
}