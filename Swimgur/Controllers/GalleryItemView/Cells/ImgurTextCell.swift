//
//  ImgurTextCell.swift
//  Swimgur
//
//  Created by Joseph Neuman on 11/2/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

class ImgurTextCell: UITableViewCell {
  @IBOutlet var imgurText:UITextView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  func setup() {
    imgurText.textColor = UIColorEXT.TextColor()
    imgurText.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.RGBColor(red: 51, green: 102, blue: 187)]
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imgurText.text = nil
    
    // bug fix for text maintaining old links
    let newImgurTextView = UITextView()
    newImgurTextView.font = imgurText.font
    newImgurTextView.backgroundColor = imgurText.backgroundColor
    newImgurTextView.dataDetectorTypes = imgurText.dataDetectorTypes
    newImgurTextView.selectable = imgurText.selectable
    newImgurTextView.editable = imgurText.editable
    newImgurTextView.scrollEnabled = imgurText.scrollEnabled
    newImgurTextView.textColor = imgurText.textColor
    newImgurTextView.linkTextAttributes = imgurText.linkTextAttributes
    newImgurTextView.translatesAutoresizingMaskIntoConstraints = false
    
    imgurText.removeFromSuperview()
    self.addSubview(newImgurTextView)
    imgurText = newImgurTextView
    
    let top = NSLayoutConstraint(item: newImgurTextView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0)
    let bottom = NSLayoutConstraint(item: newImgurTextView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0)
    let leading = NSLayoutConstraint(item: newImgurTextView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0)
    let trailing = NSLayoutConstraint(item: newImgurTextView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0)
    self.addConstraints([top, bottom, leading, trailing])
  }
}