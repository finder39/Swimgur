//
//  ImageViewController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/19/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
  @IBOutlet weak var scrollview: UIScrollView!
  var imageViews:[UIImageView] = []
  
  var galleryIndex: Int?/* {
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
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.loadImage()
  }
  
  private func loadImage() {
    if let galleryIndex = galleryIndex {
      if DataManager.sharedInstance.galleryItems.count > galleryIndex {
        let item:GalleryItem = DataManager.sharedInstance.galleryItems[galleryIndex]
        
        // remove existing image views
        for imageView in imageViews {
          imageView.removeFromSuperview()
        }
        imageViews.removeAll(keepCapacity: false)
        
        
        if let galleryImage = item as? GalleryImage {
          var imageView = UIImageView(frame: CGRectMake(0, 0, self.scrollview.frame.width, self.scrollview.frame.height))
          imageView.contentMode = UIViewContentMode.ScaleAspectFit
          imageViews.append(imageView)
          self.scrollview.addSubview(imageView)
          DataManager.sharedInstance.setImageView(imageView, withURL: galleryImage.link)
          self.setContentSizeOfScrollView()
        } else if let galleryAlbum = item as? GalleryAlbum {
          if galleryAlbum.images.count == 0 {
            galleryAlbum.getAlbum(onCompletion: { (album) -> () in
              DataManager.sharedInstance.galleryItems[galleryIndex] = album
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
  
  /*
  
  
  - (void)setContentSizeOfSevenFormView {
  BOOL restoreHorizontal = NO;
  BOOL restoreVertical = NO;
  
  if ([self respondsToSelector:@selector(setShowsHorizontalScrollIndicator:)] && [self respondsToSelector:@selector(setShowsVerticalScrollIndicator:)]) {
  if ([self showsHorizontalScrollIndicator]) {
  restoreHorizontal = YES;
  [self setShowsHorizontalScrollIndicator:NO];
  }
  if ([self showsVerticalScrollIndicator]) {
  restoreVertical = YES;
  [self setShowsVerticalScrollIndicator:NO];
  }
  }
  CGRect contentRect = CGRectZero;
  for (UIView *view in self.subviews) {
  if (![view isHidden])
  contentRect = CGRectUnion(contentRect, view.frame);
  }
  if (contentRect.size.height > self.frame.size.height)
  [self setScrollEnabled:TRUE];
  else
  [self setScrollEnabled:FALSE];
  if ([self respondsToSelector:@selector(setShowsHorizontalScrollIndicator:)] && [self respondsToSelector:@selector(setShowsVerticalScrollIndicator:)]) {
  if (restoreHorizontal)
  {
  [self setShowsHorizontalScrollIndicator:YES];
  }
  if (restoreVertical) {
  [self setShowsVerticalScrollIndicator:YES];
  }
  }
  contentRect.size.height += 8;
  if (contentRect.origin.y < 0) {
  contentRect.size.height += contentRect.origin.y;
  }
  self.contentSize = contentRect.size;
  [self setCanCancelContentTouches:YES];
  }
*/
}