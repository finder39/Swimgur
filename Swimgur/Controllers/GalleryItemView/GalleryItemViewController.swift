//
//  GalleryItemViewController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/19/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit
import SWNetworking

private enum Direction {
  case Previous
  case Next
}

class GalleryItemViewController: UIViewController, UIScrollViewDelegate {
  @IBOutlet weak var tableView: GalleryItemTableView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var downvoteButton: UIButton!
  @IBOutlet weak var upvoteButton: UIButton!
  @IBOutlet weak var voteBar: UIView!
  
  var table1:GalleryItemTableView!
  var table2:GalleryItemTableView!
  var table3:GalleryItemTableView!
  
  var textCell:ImgurTextCell!
  var commentCell:CommentCell!
  
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
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // hacky hack hack
    textCell = tableView.dequeueReusableCellWithIdentifier("ImgurTextCellReuseIdentifier") as ImgurTextCell
    commentCell = tableView.dequeueReusableCellWithIdentifier("CommentCellReuseIdentifier") as CommentCell
    
    /*var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
    swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
    self.tableView.addGestureRecognizer(swipeLeft)
    var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
    swipeRight.direction = UISwipeGestureRecognizerDirection.Right
    self.tableView.addGestureRecognizer(swipeRight)*/
    
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
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.loadImage()
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
  
  private func moveTablesBasedOnPageChange(direction:Direction) {
    // sorts tables in order by frame
    let tableArray:[GalleryItemTableView] = [table1, table2, table3].sorted({ (first:GalleryItemTableView, second:GalleryItemTableView) -> Bool in
      return CGRectGetMinX(first.frame) < CGRectGetMinX(second.frame)
    })
    
    if direction == .Previous {
      // move last item to being in front of the first
      tableArray.last!.galleryIndex = tableArray.first!.galleryIndex - 1
      tableArray.last!.frame.origin.x = tableArray.first!.frame.origin.x - tableArray.first!.frame.size.width
    } else if direction == .Next {
      // move front item to being in back of the last
      tableArray.first!.galleryIndex = tableArray.last!.galleryIndex + 1
      tableArray.first!.frame.origin.x = tableArray.last!.frame.origin.x + tableArray.last!.frame.size.width
      
      // center items
      /*for theTable in tableArray {
        theTable.frame.origin.x = theTable.frame.origin.x - theTable.frame.size.width
      }*/
    }
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
  
  // MARK: UIScrollViewDelegate
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let pageWidth = scrollView.frame.size.width
    var fractionalPage = scrollView.contentOffset.x / pageWidth
    let page = lround(Double(fractionalPage))
    if 1 != page {
      if 1 > page {
        moveTablesBasedOnPageChange(.Previous)
      } else {
        moveTablesBasedOnPageChange(.Next)
      }
      //previousPage = page
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