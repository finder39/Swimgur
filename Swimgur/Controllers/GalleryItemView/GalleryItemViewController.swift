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
  @IBOutlet weak var scrollView: InfiniteScrollView!
  
  @IBOutlet weak var downvoteButton: UIButton!
  @IBOutlet weak var upvoteButton: UIButton!
  @IBOutlet weak var voteBar: UIView!
  
  var table1:GalleryItemTableView?
  var table2:GalleryItemTableView?
  var table3:GalleryItemTableView?
  
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
    
    // setup new table views for scrolling
    self.setupInfiniteScrollViewBasedOnNumberOfGalleryItems(DataManager.sharedInstance.galleryItems.count)
    
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
  
  func setupInfiniteScrollViewBasedOnNumberOfGalleryItems(count:Int) {
    if count >= 3 {
      table1 = createTableViewWithPageOffset(0)
      table2 = createTableViewWithPageOffset(1)
      table3 = createTableViewWithPageOffset(2)
      
      self.scrollView.addSubview(table1!)
      self.scrollView.addSubview(table2!)
      self.scrollView.addSubview(table3!)
      
      self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*3.0, self.view.frame.size.height)
      self.scrollView.setContentOffset(CGPointMake(self.view.frame.size.width, self.scrollView.contentOffset.y), animated: false)
    } else if count == 2 {
      table2 = createTableViewWithPageOffset(0)
      table3 = createTableViewWithPageOffset(1)
      
      self.scrollView.addSubview(table2!)
      self.scrollView.addSubview(table3!)
      
      self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*2.0, self.view.frame.size.height)
      self.scrollView.setContentOffset(CGPointMake(self.view.frame.size.width, self.scrollView.contentOffset.y), animated: false)
    } else if count == 1 {
      table2 = createTableViewWithPageOffset(0)
      
      self.scrollView.addSubview(table2!)
      
      self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*1.0, self.view.frame.size.height)
      self.scrollView.setContentOffset(CGPointMake(0, self.scrollView.contentOffset.y), animated: false)
    }
    
    // move infinite scrollview to appropriate place if initial gallery index is first or last item instead of center item
    if count > 1 {
      if galleryIndex == 0 {
        self.scrollView.setContentOffset(CGPointMake(0, self.scrollView.contentOffset.y), animated: false)
      } else if DataManager.sharedInstance.galleryItems.count >= 3 && DataManager.sharedInstance.galleryItems.count-1 == galleryIndex {
        self.scrollView.setContentOffset(CGPointMake(self.view.frame.size.width*2.0, self.scrollView.contentOffset.y), animated: false)
      }
    }
  }
  
  func createTableViewWithPageOffset(pageOffset:Int) -> GalleryItemTableView {
    let offset = self.view.frame.size.width * CGFloat(pageOffset)
    let newTableView = GalleryItemTableView(frame: CGRectMake(self.view.frame.origin.x+offset, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height))
    // TODO: status bar height will become 40 px and non-transparent during calls/navigation/hotspot. Need to detect/account and adjust for this.
    newTableView.contentInset.top = self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
    newTableView.contentInset.bottom = self.voteBar.frame.size.height
    newTableView.scrollIndicatorInsets.bottom = self.voteBar.frame.size.height
    newTableView.canCancelContentTouches = true
    newTableView.delaysContentTouches = true
    newTableView.contentInset.bottom = self.voteBar.frame.size.height
    // TODO: Need to make an NSAutoLayotConstraint for height to heigth of scrollview to account for calls/navigation/hotspott status bar changes (and rotation)
    newTableView.scrollIndicatorInsets.bottom = self.voteBar.frame.size.height
    newTableView.separatorStyle = .None
    
    newTableView.backgroundColor = UIColorEXT.BackgroundColor()
    return newTableView
  }
  
  private func loadImage() {
    var pageOffset = 0
    if DataManager.sharedInstance.galleryItems.count == 1  {
      pageOffset = 0
    } else if DataManager.sharedInstance.galleryItems.count-1 == galleryIndex {
      pageOffset = -1
    } else if DataManager.sharedInstance.galleryItems.count >= 3 && galleryIndex == 0 {
      pageOffset = 1
    }
    table1?.galleryIndex = galleryIndex-1+pageOffset
    table2?.galleryIndex = galleryIndex+pageOffset
    table3?.galleryIndex = galleryIndex+1+pageOffset
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
  
  func currentPageIsSecondToFirstPage() -> Bool {
    return (self.galleryIndex == 1 || self.galleryIndex == 0)
  }
  
  func currentPageIsSecondToLastPage() -> Bool {
    return (self.galleryIndex == DataManager.sharedInstance.galleryItems.count-2 || self.galleryIndex == DataManager.sharedInstance.galleryItems.count-1)
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