//
//  GalleryCollectionViewCell.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/11/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SWNetworking

class GalleryCollectionViewCell: UICollectionViewCell {
  //var imageView: UIImageView = UIImageView(frame: CGRectMake(0.5, 0.5, 105, 105))
  var imageView: UIImageView = UIImageView(frame: CGRectMake(0.0, 0.0, 106, 106))
  
  //// Polygon Drawing
  var polygonPath:UIBezierPath = UIBezierPath()
  
  var gallery: GalleryItem? {
    didSet {
      if let galleryImage = gallery as? GalleryImage {
        SWNetworking.sharedInstance.setImageView(self.imageView, withURL: galleryImage.squareThumbnailURIForSize(self.frame.size))
      } else if let galleryAlbum = gallery as? GalleryAlbum {
        SWNetworking.sharedInstance.setImageView(self.imageView, withURL: galleryAlbum.squareThumbnailURIForSize(self.frame.size))
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
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func drawRect(rect: CGRect) {
    var leftRGBA = [CGFloat](count: 4, repeatedValue: 0.0)
    UIColorEXT.UpvoteColor().getRed(&leftRGBA[0], green: &leftRGBA[1], blue: &leftRGBA[2], alpha: &leftRGBA[3])
    var fillColor = UIColor(red: 133.0/255.0, green: 191/255.0, blue: 37/255.0, alpha: 1.0)
    fillColor = UIColor(red: leftRGBA[0], green: leftRGBA[1], blue: leftRGBA[2], alpha: leftRGBA[3])
    var strokeColor = UIColor(red: leftRGBA[0], green: leftRGBA[1], blue: leftRGBA[2], alpha: leftRGBA[3])
    
    polygonPath = UIBezierPath()
    polygonPath.moveToPoint(CGPointMake(106, 0))
    polygonPath.addLineToPoint(CGPointMake(106, 20))
    polygonPath.addLineToPoint(CGPointMake(86, 0))
    polygonPath.closePath()
    fillColor.setFill()
    polygonPath.fill()
    
    var shape = CAShapeLayer()
    shape.path = polygonPath.CGPath
    self.layer.addSublayer(shape)
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