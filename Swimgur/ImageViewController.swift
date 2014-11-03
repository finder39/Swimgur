//
//  ImageViewController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/19/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit
import SWNetworking

class ImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView!
  
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
  private var currentGalleryItem:GalleryItem? {
    if DataManager.sharedInstance.galleryItems.count > galleryIndex && galleryIndex >= 0 {
      return DataManager.sharedInstance.galleryItems[galleryIndex]
    } else {
      return nil
    }
  }
  
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
    self.tableView.addGestureRecognizer(swipeLeft)
    var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
    swipeRight.direction = UISwipeGestureRecognizerDirection.Right
    self.tableView.addGestureRecognizer(swipeRight)
    
    self.tableView.canCancelContentTouches = true
    self.tableView.delaysContentTouches = true
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.loadImage()
    self.view.bringSubviewToFront(self.voteBar)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let currentPoint = self.tableView.contentOffset.y+self.tableView.contentInset.top
    let currentPercent = currentPoint/self.tableView.contentSize.height
    
    for view in imageViews {
      if let textView = view as? UITextView {
        for constraint in textView.constraints() {
          if let constraint = constraint as? NSLayoutConstraint {
            if constraint.firstAttribute == .Height {
              constraint.constant = textView.getTextHeight(width: CGRectGetWidth(self.tableView.frame))
            }
          }
        }
      }
    }
    
    self.setContentSizeOfScrollView()
    
    self.tableView.setContentOffset(CGPoint(x: 0.0, y: currentPercent*self.tableView.contentSize.height-self.tableView.contentInset.top), animated: true)
  }
  
  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case UISwipeGestureRecognizerDirection.Right:
        galleryIndex--
        self.loadImage()
        self.tableView.scrollRectToVisible(CGRectMake(0, 0, 10, 10), animated: false)
      case UISwipeGestureRecognizerDirection.Left:
        galleryIndex++
        self.loadImage()
        self.tableView.scrollRectToVisible(CGRectMake(0, 0, 10, 10), animated: false)
      default:
        break
      }
    }
  }
  
  private func loadImage() {
    if let item = currentGalleryItem {
      self.title = item.title
      self.colorFromVote(item)
      
      // http://stackoverflow.com/questions/19896447/ios-7-navigation-bar-height
      /*UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
      self.navigationController!.navigationBar.bounds = CGRectMake(0, 0, self.navigationController!.navigationBar.frame.size.width, 100)
      }, completion: { (done) -> Void in
      
      })*/
      if let galleryImage = item as? GalleryImage {
        tableView.reloadData()
      } else if let galleryAlbum = item as? GalleryAlbum {
        if galleryAlbum.images.count == 0 {
          galleryAlbum.getAlbum(onCompletion: { (album) -> () in
            DataManager.sharedInstance.galleryItems[self.galleryIndex] = album
            self.loadImage()
          })
        } else {
          tableView.reloadData()
        }
      }
    }
    /*if DataManager.sharedInstance.galleryItems.count > galleryIndex && galleryIndex >= 0 {
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
        
        addFirstItemConstraints(item: imageView, image: galleryImage)
        
        // description of image
        if let description = galleryImage.description {
          let textView = newTextView(content: description)
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
          var theLastItem:UIView? = nil
          
          for image in galleryAlbum.images {
            
            
            // title of image
            if let title = image.title {
              let textView = newTextView(content: title)
              textView.setTranslatesAutoresizingMaskIntoConstraints(false)
              imageViews.append(textView)
              self.scrollview.addSubview(textView)
              
              if let theLastItem = theLastItem {
                addItemConstraints(item: textView, lastItem:theLastItem)
              } else {
                addFirstItemConstraints(item: textView)
              }
              theLastItem = textView
            }
            
            var imageView = UIImageView()
            imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageViews.append(imageView)
            self.scrollview.addSubview(imageView)
            SWNetworking.sharedInstance.setImageView(imageView, withURL: image.link)
            if let theLastItem = theLastItem {
              addItemConstraints(item: imageView, lastItem: theLastItem, image: image)
            } else {
              addFirstItemConstraints(item: imageView, image: image)
            }
            theLastItem = imageView
            // description of image
            if let description = image.description {
              let textView = newTextView(content: description)
              textView.setTranslatesAutoresizingMaskIntoConstraints(false)
              imageViews.append(textView)
              self.scrollview.addSubview(textView)
              
              addItemConstraints(item: textView, lastItem: theLastItem!)
              theLastItem = textView
            }
            //originY += CGRectGetHeight(imageView.frame)+5
          }
          self.setContentSizeOfScrollView()
        }
      }
    }*/
  }
  
  // MARK: UITableViewDelegate
  
  // MARK: UITableViewDataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let item = currentGalleryItem {
      return item.tableViewDataSourceArray.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let item = currentGalleryItem!
    
    if item.tableViewDataSourceArray[indexPath.row].type == .Image {
      var cell = tableView.dequeueReusableCellWithIdentifier("ImgurImageCellReuseIdentifier", forIndexPath: indexPath) as ImgurImageCell
      SWNetworking.sharedInstance.setImageView(cell.imgurImage, withURL: item.tableViewDataSourceArray[indexPath.row].text)
      return cell
    } else if item.tableViewDataSourceArray[indexPath.row].type == .Title || item.tableViewDataSourceArray[indexPath.row].type == .Description {
      var cell = tableView.dequeueReusableCellWithIdentifier("ImgurTextCellReuseIdentifier", forIndexPath: indexPath) as ImgurTextCell
      cell.imgurText.text = item.tableViewDataSourceArray[indexPath.row].text
      return cell
    } else {
      return UITableViewCell()
    }
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
    let restoreHorizontal = self.tableView.showsHorizontalScrollIndicator
    let restoreVertical = self.tableView.showsVerticalScrollIndicator
    
    var contentRect = CGRectZero
    for view in self.tableView.subviews {
      contentRect = CGRectUnion(contentRect, view.frame)
    }
    contentRect.size.height += self.voteBar.frame.size.height
    self.tableView.contentSize = contentRect.size
    if contentRect.size.height > self.tableView.frame.size.height {
      self.tableView.scrollEnabled = true
    } else {
      self.tableView.scrollEnabled = false
    }
    self.tableView.showsHorizontalScrollIndicator = restoreHorizontal
    self.tableView.showsVerticalScrollIndicator = restoreVertical
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