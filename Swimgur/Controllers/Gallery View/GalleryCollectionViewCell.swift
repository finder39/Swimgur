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
  var imageView: UIImageView = UIImageView()
  //@IBOutlet var imageView: UIImageView!
  
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
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    //setup() //  doesn't work because imageView is created in setup
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
    imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.addSubview(imageView)
    let trailing = NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -0.5)
    let bottom = NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -0.5)
    let top = NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.5)
    let leading = NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.5)
    self.addConstraints([trailing, bottom, top, leading])
    self.layer.borderWidth = 1
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    gallery = nil
    imageView.image = nil
    SWNetworking.sharedInstance.cancelImageviewLoad(imageView)
    self.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1).CGColor
  }
}