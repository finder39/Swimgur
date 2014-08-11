//
//  GalleryViewController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/10/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

/************************
// (320-(.5*6)-2)/3 = 105

.5 border - 105 image - .5 border  - 1 empty - .5 border - 105 image - .5 border - 1 empty - .5 border - 105 image - .5 border
************************/

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    DataManager.sharedInstance.getGalleryImagesWithSection(ImgurSection.Hot, sort: ImgurSort.Viral, window: ImgurWindow.Day, page: 1, showViral: true, onCompletion: { (array) -> () in
      
    }) { (error, desciption) -> () in
      
    }
  }
  
  // MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
    return 0
  }
  
  func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
    return nil
  }
  
  // MARK: UICollectionViewDelegate
}