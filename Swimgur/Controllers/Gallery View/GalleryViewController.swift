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

/************************
// (320-(.5*6)-2)/3 = 105

.5 border - 105 image - .5 border  - 1 empty - .5 border - 105 image - .5 border - 1 empty - .5 border - 105 image - .5 border
************************/

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBOutlet var collectionGallery: UICollectionView!
  @IBOutlet var sortView: UIView!
  @IBOutlet var sortSegment: UISegmentedControl!
  
  var refreshControl:UIRefreshControl = UIRefreshControl()
  
  var imagePicker:UIImagePickerController = UIImagePickerController()
  
  var hasAppeared = false
  var loadingMore = false
  var cellSize:CGFloat = 0
  
  var sortType: ImgurSort = .Viral
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.collectionGallery.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: Constants.ReuseIdentifier.GalleryCollectionViewCellReuseIdentifier)
    
    cellSize = collectionCellSizeFinder(deviceWidth: min(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height), max: 135)
    
    refreshControl.addTarget(self, action: Selector("loadFirstPage"), forControlEvents: .ValueChanged)
    collectionGallery.addSubview(refreshControl)
    
    collectionGallery.contentInset.top = self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height + CGRectGetHeight(sortView.frame)
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
      loadFirstPage()
    }
  }
  
  func loadFirstPage() {
    loadingMore = true
    // clear old data
    DataManager.sharedInstance.galleryItems.removeAll(keepCapacity: false)
    self.collectionGallery.reloadData()
    dispatch_async(dispatch_get_main_queue()) {
      self.collectionGallery.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
    }
    // load new data
    SWNetworking.sharedInstance.getGalleryImagesWithSection(ImgurSection.Hot, sort: self.sortType, window: ImgurWindow.Day, page: 0, showViral: true, onCompletion: { (newGalleryItems) -> () in
      println("Refreshing collectionGallery")
      DataManager.sharedInstance.galleryItems
        = newGalleryItems
      self.collectionGallery.reloadData()
      self.loadingMore = false
      self.refreshControl.endRefreshing()
    }) { (error, description) -> () in
      self.loadingMore = false
      self.refreshControl.endRefreshing()
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
      var cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.ReuseIdentifier.GalleryCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as GalleryCollectionViewCell
      let galleryItem = DataManager.sharedInstance.galleryItems[indexPath.row]
      cell.gallery = galleryItem
      
      if (indexPath.row == DataManager.sharedInstance.galleryItems.count-12) {
        loadMore()
        self.loadingMore = true
      }
      
      return cell
    } else {
      var cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.ReuseIdentifier.GalleryCollectionViewLoadMoreCellReuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
      return cell
    }
  }
  
  func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
    if indexPath.section == 0 {
      self.performSegueWithIdentifier(Constants.Segue.SegueGalleryToGalleryItem, sender: indexPath)
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
    (segue.destinationViewController as GalleryItemViewController).galleryIndex = row
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
    let imageB64 = Constants.encodeImageToBase64String(image)
    
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
  
  @IBAction func sortTypeChanged(sender: UISegmentedControl) {
    var newSortType: ImgurSort!
    if sender.selectedSegmentIndex == 0 {
      newSortType = .Time
    } else if sender.selectedSegmentIndex == 1 {
      newSortType = .Viral
    }
    
    if self.sortType != newSortType {
      self.sortType = newSortType
      self.loadFirstPage()
    }
  }
}