//
//  InfiniteScrollView.swift
//  Swimgur
//
//  Created by Joseph Neuman on 11/15/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

enum InfiniteScrollViewMoveDirection {
  case ToBeginning
  case ToEnd
}

protocol InfiniteScrollViewDelegate {
  func movedView(movedView:UIView, direction:InfiniteScrollViewMoveDirection, nextToView:UIView)
  func newCenterView(centerView:UIView)
}

class InfiniteScrollView: UIScrollView {
  var infiniteScrollViewDelegate:InfiniteScrollViewDelegate?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let pageWidth = self.frame.size.width
    var fractionalPage = self.contentOffset.x / pageWidth
    let page = lround(Double(fractionalPage))
    if 1 != page {
      let subviewsSorted:[UIView] = (self.subviews as [UIView]).sorted({ (first, second) -> Bool in
        return CGRectGetMinX(first.frame) < CGRectGetMinX(second.frame)
      })
      
      if 1 < page {
        self.contentOffset = CGPointMake(self.contentOffset.x-(subviews.first! as UIView).frame.size.width, self.contentOffset.y)
        for view in subviews {
          if let view = view as? UIView {
            view.frame.origin.x = view.frame.origin.x - view.frame.size.width
          }
        }
        // move front item to being in back of the last
        //tableArray.first!.galleryIndex = tableArray.last!.galleryIndex + 1
        if let infiniteScrollViewDelegate = infiniteScrollViewDelegate {
          infiniteScrollViewDelegate.movedView(subviewsSorted.first!, direction: .ToEnd, nextToView: subviewsSorted.last!)
          infiniteScrollViewDelegate.newCenterView(subviewsSorted.last!)
        }
        subviewsSorted.first!.frame.origin.x = subviewsSorted.last!.frame.origin.x + subviewsSorted.last!.frame.size.width
      } else {
        self.contentOffset = CGPointMake(self.contentOffset.x+(subviews.first! as UIView).frame.size.width, self.contentOffset.y)
        for view in subviews {
          if let view = view as? UIView {
            view.frame.origin.x = view.frame.origin.x + view.frame.size.width
          }
        }
        // move last item to being in front of the first
        //tableArray.last!.galleryIndex = tableArray.first!.galleryIndex - 1
        if let infiniteScrollViewDelegate = infiniteScrollViewDelegate {
          infiniteScrollViewDelegate.movedView(subviewsSorted.last!, direction: .ToBeginning, nextToView: subviewsSorted.first!)
          infiniteScrollViewDelegate.newCenterView(subviewsSorted.first!)
        }
        subviewsSorted.last!.frame.origin.x = subviewsSorted.first!.frame.origin.x - subviewsSorted.first!.frame.size.width
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