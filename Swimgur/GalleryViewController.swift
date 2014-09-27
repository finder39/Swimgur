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
let SegueToImage = "SegueToImage"

/************************
// (320-(.5*6)-2)/3 = 105

.5 border - 105 image - .5 border  - 1 empty - .5 border - 105 image - .5 border - 1 empty - .5 border - 105 image - .5 border
************************/

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UploadPhotoDelegate {
  @IBOutlet weak var collectionGallery: UICollectionView!
  
  var imagePicker:UIImagePickerController = UIImagePickerController()
  
  var hasAppeared = false
  
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
  
  // MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return DataManager.sharedInstance.galleryItems.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    var cell = collectionView.dequeueReusableCellWithReuseIdentifier(GalleryCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as GalleryCollectionViewCell
    cell.resetCell()
    let galleryItem = DataManager.sharedInstance.galleryItems[indexPath.row]
    cell.gallery = galleryItem
    return cell
  }
  
  func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
    self.performSegueWithIdentifier(SegueToImage, sender: indexPath)
    
  }
  
  // MARK: UICollectionViewDelegateFlowLayout
  
  func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
    return CGSizeMake(106.0, 106.0)
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
    
    DataManager.sharedInstance.uploadPhotoDelegate = self
    DataManager.sharedInstance.uploadImage(ImageUpload(imageB64: imageB64)) { (success) -> () in
      
    }
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: { () -> Void in
      
    })
  }
  
  // MARK: UploadPhotoDelegate
  
  func updateProgress(progress: Double) {
    println("Progress: \(progress)")
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