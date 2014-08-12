//
//  GalleryCollectionViewCell.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/11/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
  var imageView: UIImageView = UIImageView(frame: CGRectMake(0.5, 0.5, 105, 105))
  var gallery: GalleryItem? {
    didSet {
      if let galleryImage = gallery as? GalleryImage {
        DataManager.sharedInstance.setImageView(self.imageView, withURL: galleryImage.squareThumbnailURIForSize(self.frame.size))
      } else if let galleryAlbum = gallery as? GalleryAlbum {
        DataManager.sharedInstance.setImageView(self.imageView, withURL: galleryAlbum.squareThumbnailURIForSize(self.frame.size))
      }
    }
  }
  
  override init() {
    super.init()
    self.addSubview(imageView)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(imageView)
  }
  
  required init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
  }
  
  internal func resetCell() {
    gallery = nil
    imageView.image = nil
  }
}