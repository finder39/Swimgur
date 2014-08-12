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
  //var imageView: UIImageView = UIImageView(frame: CGRectMake(0.5, 0.5, 105, 105))
  var imageView: UIImageView = UIImageView(frame: CGRectMake(0.0, 0.0, 106, 106))
  var gallery: GalleryItem? {
    didSet {
      if let galleryImage = gallery as? GalleryImage {
        DataManager.sharedInstance.setImageView(self.imageView, withURL: galleryImage.squareThumbnailURIForSize(self.frame.size))
      } else if let galleryAlbum = gallery as? GalleryAlbum {
        DataManager.sharedInstance.setImageView(self.imageView, withURL: galleryAlbum.squareThumbnailURIForSize(self.frame.size))
      }
      if let vote = gallery?.vote {
        if vote == "up" {
          self.layer.borderColor = UIColorEXT.UpvoteColor().CGColor
        } else if vote == "down" {
          self.layer.borderColor = UIColorEXT.DownvoteColor().CGColor
        }
      }
    }
  }
  
  override init() {
    super.init()
    self.setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  required init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
  }
  
  private func setup() {
    self.addSubview(imageView)
    self.layer.borderWidth = 1
  }
  
  internal func resetCell() {
    gallery = nil
    imageView.image = nil
    self.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1).CGColor
  }
}