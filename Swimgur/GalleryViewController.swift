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
  var infiniteScrollingView:UIView!
  
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
    self.navigationController?.navigationBar.barTintColor = UIColorEXT.FrameColor() // reset from ImageViewController
    if !hasAppeared {
      hasAppeared = true
      SWNetworking.sharedInstance.getGalleryImagesWithSection(ImgurSection.Hot, sort: ImgurSort.Viral, window: ImgurWindow.Day, page: 0, showViral: true, onCompletion: { (newGalleryItems) -> () in
        println("Refreshing collectionGallery")
        DataManager.sharedInstance.galleryItems += newGalleryItems as [GalleryItem]
        self.collectionGallery.reloadData()
        }) { (error, description) -> () in
          
      }
    }
  }
  
  /*func loadMore() {
    let fetchPage = Int(ceil(Double(self.datasource.count)/30))+1
    Post.fetch(self.filter, page:fetchPage, completion: {(posts: [Post]!, error: Fetcher.ResponseError!, local: Bool) in
      if let realDatasource = posts {
        var tempDatasource:NSMutableArray = NSMutableArray(array: self.datasource, copyItems: false)
        let postsNotFromNewPageCount = ((fetchPage-1)*30)
        if (tempDatasource.count - postsNotFromNewPageCount > 0) {
          tempDatasource.removeObjectsInRange(NSMakeRange(postsNotFromNewPageCount, tempDatasource.count-postsNotFromNewPageCount))
        }
        tempDatasource.addObjectsFromArray(realDatasource)
        self.datasource = tempDatasource
        if (self.datasource.count % 30 == 0) {
          self.loadMoreEnabled = true
        } else {
          self.loadMoreEnabled = false
        }
      }
      if (!local) {
        self.refreshing = false
        self.tableView.tableFooterView = nil
      }
    })
  }*/
  
  func loadMore() {
    SWNetworking.sharedInstance.getGalleryImagesWithSectionNextPage(ImgurSection.Hot, sort: ImgurSort.Viral, window: ImgurWindow.Day, showViral: true, onCompletion: { (newGalleryItems) -> () in
      println("Refreshing collectionGallery")
      DataManager.sharedInstance.galleryItems += newGalleryItems as [GalleryItem]
      self.collectionGallery.reloadData()
      }) { (error, description) -> () in
        
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
      cell.resetCell()
      let galleryItem = DataManager.sharedInstance.galleryItems[indexPath.row]
      cell.gallery = galleryItem
      
      if (indexPath.row == DataManager.sharedInstance.galleryItems.count-12) {
        //self.collectionGallery.tableFooterView = self.infiniteScrollingView
        loadMore()
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
      return CGSizeMake(106.0, 106.0)
    } else {
      return CGSizeMake(self.view.frame.size.width, 40.0)
    }
  }
  
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