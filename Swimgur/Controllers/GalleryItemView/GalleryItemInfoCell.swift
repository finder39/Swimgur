//
//  GalleryItemInfoCell.swift
//  Swimgur
//
//  Created by Joseph Neuman on 12/7/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit
import SWNetworking

class GalleryItemInfoCell: UITableViewCell {
  @IBOutlet var commentsInfoLabel:UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  func setup() {
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    commentsInfoLabel.text = nil
  }
}