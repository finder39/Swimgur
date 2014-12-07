//
//  ImgurImageCell.swift
//  Swimgur
//
//  Created by Joseph Neuman on 11/2/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit
import SWNetworking

class ImgurImageCell: UITableViewCell {
  @IBOutlet var imgurImage:UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  func setup() {
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    SWNetworking.sharedInstance.cancelImageviewLoad(imageView)
    imgurImage.image = nil
  }
}