//
//  ImageViewController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/19/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit
import SWNetworking

class ImageViewController: UIViewController, UIScrollViewDelegate {
  @IBOutlet weak var scrollview: UIScrollView!
  
  @IBOutlet weak var downvoteButton: UIButton!
  @IBOutlet weak var upvoteButton: UIButton!
  @IBOutlet weak var voteBar: UIView!
  
  var imageViews:[UIView] = []
  
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
    
    self.scrollview.canCancelContentTouches = true
    self.scrollview.delaysContentTouches = true
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.loadImage()
    self.view.bringSubviewToFront(self.voteBar)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    println()
    let currentPoint = self.scrollview.contentOffset.y+self.scrollview.contentInset.top
    let currentPercent = currentPoint/self.scrollview.contentSize.height
    
    for view in imageViews {
      if let textView = view as? UITextView {
        for constraint in textView.constraints() {
          if let constraint = constraint as? NSLayoutConstraint {
            if constraint.firstAttribute == .Height {
              constraint.constant = textView.getTextHeight(width: CGRectGetWidth(self.scrollview.frame))
            }
          }
        }
      }
    }
    
    self.setContentSizeOfScrollView()
    
    self.scrollview.setContentOffset(CGPoint(x: 0.0, y: currentPercent*self.scrollview.contentSize.height-self.scrollview.contentInset.top), animated: true)
  }
  
  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case UISwipeGestureRecognizerDirection.Right:
        galleryIndex--
        self.loadImage()
        self.scrollview.scrollRectToVisible(CGRectMake(0, 0, 10, 10), animated: false)
      case UISwipeGestureRecognizerDirection.Left:
        galleryIndex++
        self.loadImage()
        self.scrollview.scrollRectToVisible(CGRectMake(0, 0, 10, 10), animated: false)
      default:
        break
      }
    }
  }
  
  private func loadImage() {
    if DataManager.sharedInstance.galleryItems.count > galleryIndex && galleryIndex >= 0 {
      let item:GalleryItem = DataManager.sharedInstance.galleryItems[galleryIndex]
      
      // remove existing image views
      for imageView in imageViews {
        imageView.removeFromSuperview()
      }
      imageViews.removeAll(keepCapacity: false)
      
      self.title = item.title
      self.colorFromVote(item)
      
      // http://stackoverflow.com/questions/19896447/ios-7-navigation-bar-height
      /*UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
        self.navigationController!.navigationBar.bounds = CGRectMake(0, 0, self.navigationController!.navigationBar.frame.size.width, 100)
      }, completion: { (done) -> Void in
        
      })*/
      
      if let galleryImage = item as? GalleryImage {
        //let height:CGFloat = self.scrollview.frame.width/CGFloat(galleryImage.width)*CGFloat(galleryImage.height)
        
        //var imageView = UIImageView(frame: CGRectMake(0, 0, self.scrollview.frame.width, self.scrollview.frame.width/CGFloat(galleryImage.width)*CGFloat(galleryImage.height)))
        var imageView = UIImageView()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageViews.append(imageView)
        self.scrollview.addSubview(imageView)
        SWNetworking.sharedInstance.setImageView(imageView, withURL: galleryImage.link)
        
        addFirstItemConstraints(item: imageView, galleryImage: galleryImage)
        
        // description of image
        if let description = galleryImage.description {
          let textView = newTextView(content: description, lastItem: imageView)
          textView.setTranslatesAutoresizingMaskIntoConstraints(false)
          imageViews.append(textView)
          self.scrollview.addSubview(textView)
          
          addItemConstraints(item: textView, lastItem: imageView)
        }
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
            
            
            // description of image
            if let title = image.title {
              let textView = newTextView(content:title, originY:originY)
              imageViews.append(textView)
              self.scrollview.addSubview(textView)
              originY += CGRectGetHeight(textView.frame)
            }
            
            var imageView = UIImageView(frame: CGRectMake(0, originY, self.scrollview.frame.width, height))
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageViews.append(imageView)
            self.scrollview.addSubview(imageView)
            SWNetworking.sharedInstance.setImageView(imageView, withURL: image.link)
            // description of image
            if let description = image.description {
              let textView = newTextView(content:description, originY: CGRectGetMaxY(imageView.frame))
              imageViews.append(textView)
              self.scrollview.addSubview(textView)
              originY += CGRectGetHeight(textView.frame)
            }
            originY += CGRectGetHeight(imageView.frame)+5
          }
          self.setContentSizeOfScrollView()
        }
      }
    }
  }
  
  private func newTextView(#content:String, originY:CGFloat) -> UITextView {
    var textView = UITextView(frame: CGRectMake(0, originY, CGRectGetWidth(self.scrollview.frame), 100))
    textView.backgroundColor = UIColor.clearColor()
    textView.textColor = UIColorEXT.TextColor()
    textView.font = UIFont.systemFontOfSize(16)
    textView.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.RGBColor(red: 51, green: 102, blue: 187)]
    textView.selectable = true
    textView.editable = false
    textView.scrollEnabled = false
    textView.userInteractionEnabled = true
    textView.dataDetectorTypes = UIDataDetectorTypes.All
    textView.text = content
    textView.autoHeight()
    return textView
  }
  
  private func newTextView(#content:String, lastItem:UIView) -> UITextView {
    var textView = UITextView()
    textView.backgroundColor = UIColor.clearColor()
    textView.textColor = UIColorEXT.TextColor()
    textView.font = UIFont.systemFontOfSize(16)
    textView.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.RGBColor(red: 51, green: 102, blue: 187)]
    textView.selectable = true
    textView.editable = false
    textView.scrollEnabled = false
    textView.userInteractionEnabled = true
    textView.dataDetectorTypes = UIDataDetectorTypes.All
    textView.text = content
    return textView
  }
  
  private func addFirstItemConstraints(#item:UIView, galleryImage:GalleryImage) {
    let width = NSLayoutConstraint(item: item, attribute: .Width, relatedBy: .Equal, toItem: self.scrollview, attribute: .Width, multiplier: 1.0, constant: 0)
    let height = NSLayoutConstraint(item: item, attribute: .Height, relatedBy: .Equal, toItem: item, attribute: .Width, multiplier: CGFloat(galleryImage.height)/CGFloat(galleryImage.width), constant: 0)
    let top = NSLayoutConstraint(item: item, attribute: .Top, relatedBy: .Equal, toItem: self.scrollview, attribute: .Top, multiplier: 1.0, constant: 0)
    let leading = NSLayoutConstraint(item: item, attribute: .Leading, relatedBy: .Equal, toItem: self.scrollview, attribute: .Leading, multiplier: 1.0, constant: 0)
    self.scrollview.addConstraints([width, top, leading])
    item.addConstraint(height)
  }
  
  private func addItemConstraints(#item:UIImageView, lastItem:UIView, galleryImage:GalleryImage) {
    let width = NSLayoutConstraint(item: item, attribute: .Width, relatedBy: .Equal, toItem: self.scrollview, attribute: .Width, multiplier: 1.0, constant: 0)
    let height = NSLayoutConstraint(item: item, attribute: .Height, relatedBy: .Equal, toItem: item, attribute: .Width, multiplier: CGFloat(galleryImage.height)/CGFloat(galleryImage.width), constant: 0)
    let top = NSLayoutConstraint(item: item, attribute: .Top, relatedBy: .Equal, toItem: lastItem, attribute: .Bottom, multiplier: 1.0, constant: 0)
    let leading = NSLayoutConstraint(item: item, attribute: .Leading, relatedBy: .Equal, toItem: self.scrollview, attribute: .Leading, multiplier: 1.0, constant: 0)
    self.scrollview.addConstraints([width, top, leading])
    item.addConstraint(height)
  }
  
  private func addItemConstraints(#item:UITextView, lastItem:UIView) {
    let width = NSLayoutConstraint(item: item, attribute: .Width, relatedBy: .Equal, toItem: self.scrollview, attribute: .Width, multiplier: 1.0, constant: 0)
    let height = NSLayoutConstraint(item: item, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: item.getTextHeight(width: CGRectGetWidth(self.scrollview.frame)))
    let top = NSLayoutConstraint(item: item, attribute: .Top, relatedBy: .Equal, toItem: lastItem, attribute: .Bottom, multiplier: 1.0, constant: 0)
    let leading = NSLayoutConstraint(item: item, attribute: .Leading, relatedBy: .Equal, toItem: self.scrollview, attribute: .Leading, multiplier: 1.0, constant: 0)
    self.scrollview.addConstraints([width, top, leading])
    item.addConstraint(height)
  }
  
  private func colorFromVote(item:GalleryItem) {
    if let vote = item.vote {
      if vote == "up" {
        self.navigationController?.navigationBar.barTintColor = UIColorEXT.UpvoteColor()
        self.voteBar.backgroundColor = UIColorEXT.UpvoteColor()
      } else if vote == "down" {
        self.navigationController?.navigationBar.barTintColor = UIColorEXT.DownvoteColor()
        self.voteBar.backgroundColor = UIColorEXT.DownvoteColor()
      } else {
        self.navigationController?.navigationBar.barTintColor = UIColorEXT.FrameColor()
        self.voteBar.backgroundColor = UIColorEXT.FrameColor()
      }
    } else {
      self.navigationController?.navigationBar.barTintColor = UIColorEXT.FrameColor()
      self.voteBar.backgroundColor = UIColorEXT.FrameColor()
    }
  }
  
  private func setContentSizeOfScrollView() {
    let restoreHorizontal = self.scrollview.showsHorizontalScrollIndicator
    let restoreVertical = self.scrollview.showsVerticalScrollIndicator
    
    var contentRect = CGRectZero
    for view in self.scrollview.subviews {
      contentRect = CGRectUnion(contentRect, view.frame)
    }
    contentRect.size.height += self.voteBar.frame.size.height
    self.scrollview.contentSize = contentRect.size
    if contentRect.size.height > self.scrollview.frame.size.height {
      self.scrollview.scrollEnabled = true
    } else {
      self.scrollview.scrollEnabled = false
    }
    self.scrollview.showsHorizontalScrollIndicator = restoreHorizontal
    self.scrollview.showsVerticalScrollIndicator = restoreVertical
  }
  
  @IBAction func voteUp(sender: AnyObject) {
    DataManager.sharedInstance.galleryItems[self.galleryIndex].vote(.Up)
    DataManager.sharedInstance.galleryItems[self.galleryIndex].vote = GalleryItemVote.Up.rawValue
    self.colorFromVote(DataManager.sharedInstance.galleryItems[self.galleryIndex])
  }
  
  @IBAction func voteDown(sender: AnyObject) {
    DataManager.sharedInstance.galleryItems[self.galleryIndex].vote(.Down)
    DataManager.sharedInstance.galleryItems[self.galleryIndex].vote = GalleryItemVote.Down.rawValue
    self.colorFromVote(DataManager.sharedInstance.galleryItems[self.galleryIndex])
  }
}