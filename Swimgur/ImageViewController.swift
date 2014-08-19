//
//  ImageViewController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/19/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
  @IBOutlet weak var scrollview: UIScrollView!
  var imageViews:[UIImageView] = []
  
  var galleryIndex: Int = 0/* {
    didSet {
      if let galleryIndex = galleryIndex {
        if DataManager.sharedInstance.galleryItems.count > galleryIndex {
          let item:GalleryItem = DataManager.sharedInstance.galleryItems[galleryIndex]
          if let galleryImage = item as? GalleryImage {
            DataManager.sharedInstance.setImageView(self.imageView, withURL: galleryImage.squareThumbnailURIForSize(imageView.frame.size))
          } else if let galleryAlbum = item as? GalleryAlbum {
            DataManager.sharedInstance.setImageView(self.imageView, withURL: galleryAlbum.squareThumbnailURIForSize(imageView.frame.size))
          }
        }
      }
    }
  }*/
  
  override init() {
    super.init()
  }
  
  required init(coder: NSCoder) {
    //fatalError("NSCoding not supported")
    super.init(coder: coder)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
    swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
    self.scrollview.addGestureRecognizer(swipeLeft)
    var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
    swipeRight.direction = UISwipeGestureRecognizerDirection.Right
    self.scrollview.addGestureRecognizer(swipeRight)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.loadImage()
  }
  
  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case UISwipeGestureRecognizerDirection.Right:
        galleryIndex--
        self.loadImage()
      case UISwipeGestureRecognizerDirection.Left:
        galleryIndex++
        self.loadImage()
      default:
        break
      }
    }
  }
  
  private func loadImage() {
    if DataManager.sharedInstance.galleryItems.count > galleryIndex && galleryIndex >= 0 {
      self.scrollview.scrollRectToVisible(CGRectMake(0, 0, 10, 10), animated: false)
      
      let item:GalleryItem = DataManager.sharedInstance.galleryItems[galleryIndex]
      
      // remove existing image views
      for imageView in imageViews {
        imageView.removeFromSuperview()
      }
      imageViews.removeAll(keepCapacity: false)
      
      
      if let galleryImage = item as? GalleryImage {
        let height:CGFloat = self.scrollview.frame.width/CGFloat(galleryImage.width)*CGFloat(galleryImage.height)
        var imageView = UIImageView(frame: CGRectMake(0, 0, self.scrollview.frame.width, height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageViews.append(imageView)
        self.scrollview.addSubview(imageView)
        DataManager.sharedInstance.setImageView(imageView, withURL: galleryImage.link)
        self.setContentSizeOfScrollView()
      } else if let galleryAlbum = item as? GalleryAlbum {
        if galleryAlbum.images.count == 0 {
          galleryAlbum.getAlbum(onCompletion: { (album) -> () in
            DataManager.sharedInstance.galleryItems[self.galleryIndex] = album
            self.loadImage()
          })
        } else {
          var originY:CGFloat = 0
          for image in galleryAlbum.images {
            let height:CGFloat = self.scrollview.frame.width/CGFloat(image.width)*CGFloat(image.height)
            var imageView = UIImageView(frame: CGRectMake(0, originY, self.scrollview.frame.width, height))
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageViews.append(imageView)
            self.scrollview.addSubview(imageView)
            DataManager.sharedInstance.setImageView(imageView, withURL: image.link)
            originY += imageView.frame.height+2
          }
          self.setContentSizeOfScrollView()
        }
      }
    }
  }
  
  private func setContentSizeOfScrollView() {
    let restoreHorizontal = self.scrollview.showsHorizontalScrollIndicator
    let restoreVertical = self.scrollview.showsVerticalScrollIndicator
    
    var contentRect = CGRectZero
    for view in self.scrollview.subviews {
      contentRect = CGRectUnion(contentRect, view.frame)
    }
    self.scrollview.contentSize = contentRect.size
    if contentRect.size.height > self.scrollview.frame.size.height {
      self.scrollview.scrollEnabled = true
    } else {
      self.scrollview.scrollEnabled = false
    }
    self.scrollview.showsHorizontalScrollIndicator = restoreHorizontal
    self.scrollview.showsVerticalScrollIndicator = restoreVertical
  }
}