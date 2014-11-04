//
//  CommentCell.swift
//  Swimgur
//
//  Created by Joseph Neuman on 11/2/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

class CommentCell: UITableViewCell {
  @IBOutlet var authorButton:UIButton!
  @IBOutlet var pointsLabel:UILabel!
  @IBOutlet var imgurText:UITextView!
  @IBOutlet var expandButton:UIButton!
  
  @IBOutlet var authorWidth:NSLayoutConstraint!
  @IBOutlet var pointsWidth:NSLayoutConstraint!
  @IBOutlet var expandWidth:NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
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
  }
}