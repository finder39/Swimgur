//
//  GalleryViewController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/10/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

let GalleryCollectionViewCellReuseIdentifier = "GalleryCollectionViewCellReuseIdentifier"

/************************
// (320-(.5*6)-2)/3 = 105

.5 border - 105 image - .5 border  - 1 empty - .5 border - 105 image - .5 border - 1 empty - .5 border - 105 image - .5 border
************************/

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  @IBOutlet weak var collectionGallery: UICollectionView!
  
  var galleryItems:[GalleryItem] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.collectionGallery.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCellReuseIdentifier)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    DataManager.sharedInstance.getGalleryImagesWithSection(ImgurSection.Hot, sort: ImgurSort.Viral, window: ImgurWindow.Day, page: 1, showViral: true, onCompletion: { (newGalleryItems) -> () in
      println("Refreshing collectionGallery")
      self.galleryItems += newGalleryItems as [GalleryItem]
      self.collectionGallery.reloadData()
    }) { (error, desciption) -> () in
      
    }
  }
  
  // MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
    return self.galleryItems.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
    return 1
  }
  
  
  
  func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
    var cell = collectionView.dequeueReusableCellWithReuseIdentifier(GalleryCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as GalleryCollectionViewCell
    cell.resetCell()
    let galleryItem = self.galleryItems[indexPath.row]
    cell.gallery = galleryItem
    return cell
  }
  
  // MARK: UICollectionViewDelegateFlowLayout
  
  func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
    return CGSizeMake(106.0, 106.0)
  }
  
  // MARK: UICollectionViewDelegate
}