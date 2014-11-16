//
//  GalleryItemViewController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/19/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit
import SWNetworking

class GalleryItemViewController: UIViewController, InfiniteScrollViewDelegate {
  @IBOutlet weak var tableView: GalleryItemTableView!
  @IBOutlet weak var scrollView: InfiniteScrollView!
  
  @IBOutlet weak var downvoteButton: UIButton!
  @IBOutlet weak var upvoteButton: UIButton!
  @IBOutlet weak var voteBar: UIView!
  
  var table1:GalleryItemTableView!
  var table2:GalleryItemTableView!
  var table3:GalleryItemTableView!
  
  var textCell:ImgurTextCell!
  var commentCell:CommentCell!
  
  var galleryIndex: Int = 0 {
    didSet {
      // have to check if nil because when moving from gallery collection the galleryIndex is set in the
      // prepareForSegue function and that happens before the view is loaded, causing voteBar to be nil
      // and to crash while setting color in colorFromVote
      if voteBar != nil {
        self.setupViewBasedOnGalleryItem()
      }
    }
  }
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
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // hacky hack hack
    textCell = tableView.dequeueReusableCellWithIdentifier("ImgurTextCellReuseIdentifier") as ImgurTextCell
    commentCell = tableView.dequeueReusableCellWithIdentifier("CommentCellReuseIdentifier") as CommentCell
    
    // setup new table views for scrolling
    table1 = createTableViewWithPageOffset(0)
    table2 = createTableViewWithPageOffset(1)
    table3 = createTableViewWithPageOffset(2)
    
    self.scrollView.addSubview(table1)
    self.scrollView.addSubview(table2)
    self.scrollView.addSubview(table3)
    
    // remove tableview
    self.tableView.removeFromSuperview()
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*3.0, self.view.frame.size.height)
    //self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, self.scrollView.contentOffset.y)
    self.scrollView.setContentOffset(CGPointMake(self.view.frame.size.width, self.scrollView.contentOffset.y), animated: false)
    
    self.scrollView.infiniteScrollViewDelegate = self
    self.loadImage()
    
    // setup initial title since doing so in the galleryIndex didSet won't work on selected gallery item for gallery collection view
    self.setupViewBasedOnGalleryItem()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.view.bringSubviewToFront(self.voteBar)
  }
  
  // MARK: Helpers
  
  func createTableViewWithPageOffset(pageOffset:Int) -> GalleryItemTableView {
    let offset = self.view.frame.size.width * CGFloat(pageOffset)
    var newTableView = GalleryItemTableView(frame: CGRectMake(self.view.frame.origin.x+offset, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height))
    newTableView.contentInset.top = self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
    newTableView.contentInset.bottom = self.voteBar.frame.size.height
    newTableView.scrollIndicatorInsets.bottom = self.voteBar.frame.size.height
    newTableView.canCancelContentTouches = true
    newTableView.delaysContentTouches = true
    newTableView.contentInset.bottom = self.voteBar.frame.size.height
    newTableView.scrollIndicatorInsets.bottom = self.voteBar.frame.size.height
    newTableView.separatorStyle = .None
    
    newTableView.backgroundColor = UIColorEXT.BackgroundColor()
    return newTableView
  }
  
  private func loadImage() {
    table1.galleryIndex = galleryIndex-1
    table2.galleryIndex = galleryIndex
    table3.galleryIndex = galleryIndex+1
    /*if let item = currentGalleryItem {
      item.getComments({ (success) -> () in
        self.tableView.reloadData()
      })
      
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
    }*/
  }
  
  func setupViewBasedOnGalleryItem() {
    if let item = currentGalleryItem {
      self.title = item.title
      self.colorFromVote(item)
      
      // http://stackoverflow.com/questions/19896447/ios-7-navigation-bar-height
      /*UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
      self.navigationController!.navigationBar.bounds = CGRectMake(0, 0, self.navigationController!.navigationBar.frame.size.width, 100)
      }, completion: { (done) -> Void in
      
      })*/
    }
  }
  
  // MARK: InfiniteScrollViewDelegate
  
  func movedView(movedView: UIView, direction: InfiniteScrollViewMoveDirection, nextToView: UIView) {
    if let movedView = movedView as? GalleryItemTableView {
      if let nextToView = nextToView as? GalleryItemTableView {
        if direction == .ToBeginning {
          movedView.galleryIndex = nextToView.galleryIndex - 1
        } else if direction == .ToEnd {
          movedView.galleryIndex = nextToView.galleryIndex + 1
        }
      }
    }
  }
  
  func newCenterView(centerView: UIView) {
    if let centerView = centerView as? GalleryItemTableView {
      self.galleryIndex = centerView.galleryIndex
    }
  }
  
  // MARK: voting
  
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