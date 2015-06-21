//
//  CommentCell.swift
//  Swimgur
//
//  Created by Joseph Neuman on 11/2/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit
import SWNetworking

class CommentCell: UITableViewCell {
  @IBOutlet var authorButton:UIButton!
  @IBOutlet var pointsLabel:UILabel!
  @IBOutlet var imgurText:UITextView!
  @IBOutlet var expandButton:UIButton!
  
  @IBOutlet var authorWidth:NSLayoutConstraint!
  @IBOutlet var pointsWidth:NSLayoutConstraint!
  @IBOutlet var expandWidth:NSLayoutConstraint!
  
  @IBOutlet var authorLeadingConstraint:NSLayoutConstraint!
  @IBOutlet var commentLeadingConstraint:NSLayoutConstraint!
  
  weak var associatedGalleryItem:GalleryItem?
  weak var associatedComment:Comment?
  weak var parentTableView:UITableView?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
    self.indentationWidth = 15
  }
  
  func setup() {
    authorButton.setTitleColor(UIColor.RGBColor(red: 51, green: 102, blue: 187), forState: .Normal)
    imgurText.textColor = UIColorEXT.TextColor()
    pointsLabel.textColor = UIColorEXT.TextColor()
    imgurText.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.RGBColor(red: 51, green: 102, blue: 187)]
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    authorButton.setTitle(nil, forState: .Normal)
    pointsLabel.text = nil
    imgurText.text = nil
    expandButton.hidden = true
    associatedComment = nil
    associatedGalleryItem = nil
    parentTableView = nil
    expandButton.setTitle("Expand", forState: .Normal)
    
    // bug fix for text maintaining old links
    var newImgurTextView = UITextView()
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
    
    let top = NSLayoutConstraint(item: newImgurTextView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 24)
    let bottom = NSLayoutConstraint(item: newImgurTextView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0)
    commentLeadingConstraint = NSLayoutConstraint(item: newImgurTextView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 4)
    let trailing = NSLayoutConstraint(item: newImgurTextView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 4)
    self.addConstraints([top, bottom, commentLeadingConstraint, trailing])
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let indentPoints:CGFloat = CGFloat(self.indentationLevel) * self.indentationWidth
    
    authorLeadingConstraint.constant = 8 + indentPoints
    commentLeadingConstraint.constant = 4 + indentPoints
  }

  // MARK: Actions

  @IBAction func expand() {
    if expandButton.titleForState(.Normal) == "Expand" {
      associatedComment?.expanded = true
      expandButton.setTitle("Collapse", forState: .Normal)
    } else {
      associatedComment?.expanded = false
      expandButton.setTitle("Expand", forState: .Normal)
    }
    associatedGalleryItem?.updateTableViewDataSourceCommentsArray()
    parentTableView?.reloadData()
  }
}