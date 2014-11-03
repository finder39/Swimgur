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
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  override init() {
    super.init()
  }
}