//
//  GalleryViewController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/10/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit
import SWNetworking

let GalleryCollectionViewCellReuseIdentifier = "GalleryCollectionViewCellReuseIdentifier"
let GalleryCollectionViewLoadMoreCellReuseIdentifier = "GalleryCollectionViewLoadMoreCellReuseIdentifier"
let SegueToImage = "SegueToImage"

/************************
// (320-(.5*6)-2)/3 = 105

.5 border - 105 image - .5 border  - 1 empty - .5 border - 105 image - .5 border - 1 empty - .5 border - 105 image - .5 border
************************/

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBOutlet weak var collectionGallery: UICollectionView!
  
  var imagePicker:UIImagePickerController = UIImagePickerController()
  
  var hasAppeared = false
  var loadingMore = false
  var cellSize:CGFloat = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.collectionGallery.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCellReuseIdentifier)
    
    cellSize = collectionCellSizeFinder(deviceWidth: min(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height), max: 135)
  }
  
  func collectionCellSizeFinder(deviceWidth size:CGFloat, max:CGFloat) -> CGFloat {
    var count = 0
    var current = max
    var cellSize:CGFloat = 0
    while cellSize == 0 {
      count = 1
      var tempSize = size
      while tempSize > current {
        tempSize--
        tempSize -= current
        count++
      }
      if tempSize == current {
        cellSize = current
      }
      current--
    }
    return cellSize
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.navigationBar.barTintColor = UIColorEXT.FrameColor() // reset from ImageViewController
    if !hasAppeared {
      hasAppeared = true
      loadingMore = true
      SWNetworking.sharedInstance.getGalleryImagesWithSection(ImgurSection.Hot, sort: ImgurSort.Viral, window: ImgurWindow.Day, page: 0, showViral: true, onCompletion: { (newGalleryItems) -> () in
        println("Refreshing collectionGallery")
        DataManager.sharedInstance.galleryItems += newGalleryItems
        self.collectionGallery.reloadData()
        self.loadingMore = false
      }) { (error, description) -> () in
        self.loadingMore = false
      }
    }
  }
  
  func loadMore() {
    if !loadingMore {
      SWNetworking.sharedInstance.getGalleryImagesWithSectionNextPage(ImgurSection.Hot, sort: ImgurSort.Viral, window: ImgurWindow.Day, showViral: true, onCompletion: { (newGalleryItems) -> () in
        println("Loading more collectionGallery")
        DataManager.sharedInstance.galleryItems += newGalleryItems
        self.collectionGallery.reloadData()
        self.loadingMore = false
      }) { (error, description) -> () in
        self.loadingMore = false
      }
    }
  }

  // MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 0 {
      return DataManager.sharedInstance.galleryItems.count
    } else {
      return 1
    }
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    if indexPath.section == 0 {
      var cell = collectionView.dequeueReusableCellWithReuseIdentifier(GalleryCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as GalleryCollectionViewCell
      //cell.resetCell()
      let galleryItem = DataManager.sharedInstance.galleryItems[indexPath.row]
      cell.gallery = galleryItem
      
      if (indexPath.row == DataManager.sharedInstance.galleryItems.count-12) {
        loadMore()
        self.loadingMore = true
      }
      
      return cell
    } else {
      var cell = collectionView.dequeueReusableCellWithReuseIdentifier(GalleryCollectionViewLoadMoreCellReuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
      return cell
    }
  }
  
  func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
    if indexPath.section == 0 {
      self.performSegueWithIdentifier(SegueToImage, sender: indexPath)
    } else {
      
    }
  }
  
  // MARK: UICollectionViewDelegateFlowLayout
  
  func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
    if indexPath.section == 0 {
      return CGSizeMake(cellSize, cellSize)
    } else {
      return CGSizeMake(self.view.frame.size.width, 40.0)
    }
  }
  
  /*func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }*/
  
  // MARK: UICollectionViewDelegate
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    let row = (sender as NSIndexPath).row
    (segue.destinationViewController as ImageViewController).galleryIndex = row
  }
  
  // MARK: UIImagePickerControllerDelegate
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    picker.dismissViewControllerAnimated(true, completion: { () -> Void in
      
    })
    
    // Access the original image from the info dictionary
    let image = info["UIImagePickerControllerOriginalImage"] as UIImage
    
    // Capture the file name of the image
    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    let documentsDirectory = paths[0] as String
    var error:NSError?
    let dirContents = NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentsDirectory, error: &error)
    if let dirContents = dirContents {
      let fileName = "photo_\(dirContents.count).png"
      let imagePath = documentsDirectory.stringByAppendingString(fileName)
    }
    
    // Setup for upload
    let imageB64 = Constants().encodeImageToBase64String(image)
    
    SWNetworking.sharedInstance.uploadImage(ImageUpload(imageB64: imageB64)) { (success) -> () in
      
    }
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: { () -> Void in
      
    })
  }
  
  // MARK: Actions
  @IBAction func uploadNewImage(sender: AnyObject) {
    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    imagePicker.allowsEditing = false
    imagePicker.delegate = self
    self.presentViewController(imagePicker, animated: true) { () -> Void in
      
    }
  }
}