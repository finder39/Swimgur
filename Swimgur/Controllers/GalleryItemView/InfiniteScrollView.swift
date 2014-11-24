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
  
  // used to determine if is first or last page in infitite scroll
  func currentPageIsSecondToFirstPage() -> Bool
  func currentPageIsSecondToLastPage() -> Bool
}

class InfiniteScrollView: UIScrollView {
  var infiniteScrollViewDelegate:InfiniteScrollViewDelegate!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let pageWidth = self.frame.size.width
    var fractionalPage = self.contentOffset.x / pageWidth
    let page = lround(Double(fractionalPage))
    
    // 1 is center page as there are only 3 item
    // page will not be 1 once it has beens scrolled 50% of a page left or right
    if 1 != page {
      let subviewsSorted:[UIView] = (self.subviews as [UIView]).sorted({ (first, second) -> Bool in
        return CGRectGetMinX(first.frame) < CGRectGetMinX(second.frame)
      })
      
      if page > 1 && !infiniteScrollViewDelegate.currentPageIsSecondToLastPage() {
        self.contentOffset = CGPointMake(self.contentOffset.x-(subviews.first! as UIView).frame.size.width, self.contentOffset.y)
        for view in subviews {
          // move each view left the width of a page
          if let view = view as? UIView {
            view.frame.origin.x = view.frame.origin.x - pageWidth
          }
        }
        // move front item to being in back of the last
        infiniteScrollViewDelegate.movedView(subviewsSorted.first!, direction: .ToEnd, nextToView: subviewsSorted.last!)
        infiniteScrollViewDelegate.newCenterView(subviewsSorted.last!)
          
        subviewsSorted.first!.frame.origin.x = subviewsSorted.last!.frame.origin.x + subviewsSorted.last!.frame.size.width
      } else if page < 1 && !infiniteScrollViewDelegate.currentPageIsSecondToFirstPage() {
        self.contentOffset = CGPointMake(self.contentOffset.x+(subviews.first! as UIView).frame.size.width, self.contentOffset.y)
        // move each view right the width of a page
        for view in subviews {
          if let view = view as? UIView {
            view.frame.origin.x = view.frame.origin.x + pageWidth
          }
        }
        // move last item to being in front of the first
        infiniteScrollViewDelegate.movedView(subviewsSorted.last!, direction: .ToBeginning, nextToView: subviewsSorted.first!)
        infiniteScrollViewDelegate.newCenterView(subviewsSorted.first!)
        
        subviewsSorted.last!.frame.origin.x = subviewsSorted.first!.frame.origin.x - subviewsSorted.first!.frame.size.width
      }
    }
  }
}