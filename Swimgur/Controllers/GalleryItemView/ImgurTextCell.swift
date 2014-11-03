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
  }
}