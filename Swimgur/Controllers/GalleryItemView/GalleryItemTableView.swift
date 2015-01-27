//
//  GalleryItemTableView.swift
//  Swimgur
//
//  Created by Joseph Neuman on 11/9/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit
import SWNetworking

private enum GalleryItemTableSection: Int {
  case Images = 0
  case GalleryItemInfo = 1
  case Comments = 2
}

class GalleryItemTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
  
  var galleryIndex:Int = -1 {
    didSet {
      if DataManager.sharedInstance.galleryItems.count > galleryIndex && galleryIndex >= 0 {
        self.loadImage()
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
  
  var textCell:ImgurTextCell!
  var commentCell:CommentCell!
  
  // lifecyle
  
  override init() {
    super.init()
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
    // hacky hack hack
    //self.registerClass(ImgurTextCell.self, forCellReuseIdentifier: "ImgurTextCellReuseIdentifier")
    //self.registerClass(CommentCell.self, forCellReuseIdentifier: "CommentCellReuseIdentifier")
    //self.registerClass(ImgurImageCell.self, forCellReuseIdentifier: "ImgurImageCellReuseIdentifier")
    self.registerNib(UINib(nibName: "ImgurImageCell", bundle: nil), forCellReuseIdentifier: Constants.ReuseIdentifier.ImgurImageCellReuseIdentifier)
    self.registerNib(UINib(nibName: "ImgurTextCell", bundle: nil), forCellReuseIdentifier: Constants.ReuseIdentifier.ImgurTextCellReuseIdentifier)
    self.registerNib(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: Constants.ReuseIdentifier.CommentCellReuseIdentifier)
    self.registerNib(UINib(nibName: "GalleryItemInfoCell", bundle: nil), forCellReuseIdentifier: Constants.ReuseIdentifier.GalleryItemInfoCellReuseIdentifier)
    
    textCell = self.dequeueReusableCellWithIdentifier(Constants.ReuseIdentifier.ImgurTextCellReuseIdentifier) as ImgurTextCell
    commentCell = self.dequeueReusableCellWithIdentifier(Constants.ReuseIdentifier.CommentCellReuseIdentifier) as CommentCell
    
    self.delegate = self
    self.dataSource = self
  }
  
  // galleryitem functions
  
  func loadImage() {
    let indexToLoad = galleryIndex
    dispatch_async(dispatch_get_main_queue()) {
      self.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
      if let item = self.currentGalleryItem {
        item.getComments({ (success) -> () in
          if indexToLoad == self.galleryIndex {
            dispatch_async(dispatch_get_main_queue()) {
              self.reloadData()
            }
          }
        })
        
        //self.title = item.title
        //self.colorFromVote(item)
        
        // http://stackoverflow.com/questions/19896447/ios-7-navigation-bar-height
        /*UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
        self.navigationController!.navigationBar.bounds = CGRectMake(0, 0, self.navigationController!.navigationBar.frame.size.width, 100)
        }, completion: { (done) -> Void in
        
        })*/
        if let galleryImage = item as? GalleryImage {
          if indexToLoad == self.galleryIndex {
            dispatch_async(dispatch_get_main_queue()) {
              self.reloadData()
            }
          }
        } else if let galleryAlbum = item as? GalleryAlbum {
          if galleryAlbum.images.count == 0 {
            galleryAlbum.getAlbum(onCompletion: { (album) -> () in
              DataManager.sharedInstance.galleryItems[self.galleryIndex] = album
              self.loadImage()
            })
          } else {
            if indexToLoad == self.galleryIndex {
              dispatch_async(dispatch_get_main_queue()) {
                self.reloadData()
              }
            }
          }
        }
      }
    }
  }
  
  // MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == GalleryItemTableSection.Images.rawValue {
      if let item = currentGalleryItem {
        if item.tableViewDataSourceArray[indexPath.row].type == .Image {
          if let image = item.tableViewDataSourceArray[indexPath.row].associatedGalleryImage {
            let height:CGFloat = tableView.frame.width/CGFloat(image.width)*CGFloat(image.height)
            return height
          } else if let image = item.tableViewDataSourceArray[indexPath.row].associatedAlbumImage {
            let height:CGFloat = tableView.frame.width/CGFloat(image.width)*CGFloat(image.height)
            return height
          }
        } else if item.tableViewDataSourceArray[indexPath.row].type == .Title || item.tableViewDataSourceArray[indexPath.row].type == .Description {
          textCell.imgurText.text = item.tableViewDataSourceArray[indexPath.row].text
          let size = textCell.imgurText.sizeThatFits(CGSizeMake(tableView.frame.size.width, CGFloat.max))
          return size.height
        }
      }
    } else if indexPath.section == GalleryItemTableSection.Comments.rawValue {
      if let item = currentGalleryItem {
        let comment = item.tableViewDataSourceCommentsArray[indexPath.row].associatedComment!
        commentCell.imgurText.text = comment.comment
        let size = commentCell.imgurText.sizeThatFits(CGSizeMake(tableView.frame.size.width, CGFloat.max))
        return size.height+24
      }
    }
    return 40
  }
  
  func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
    if indexPath.section == GalleryItemTableSection.Images.rawValue {
      
    } else if indexPath.section == GalleryItemTableSection.Comments.rawValue {
      let item = currentGalleryItem!
      let comment = item.tableViewDataSourceCommentsArray[indexPath.row].associatedComment!
      
      return comment.depth
    }
    return 0
  }
  
  // MARK: UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let item = currentGalleryItem {
      if section == GalleryItemTableSection.Images.rawValue {
        return item.tableViewDataSourceArray.count
      } else if section == GalleryItemTableSection.Comments.rawValue {
        return item.tableViewDataSourceCommentsArray.count
      } else if section == GalleryItemTableSection.GalleryItemInfo.rawValue {
        return 1
      }
    }
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == GalleryItemTableSection.Images.rawValue {
      let item = currentGalleryItem!
      
      if item.tableViewDataSourceArray[indexPath.row].type == .Image {
        var cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseIdentifier.ImgurImageCellReuseIdentifier, forIndexPath: indexPath) as ImgurImageCell
        SWNetworking.sharedInstance.setImageView(cell.imgurImage, withURL: item.tableViewDataSourceArray[indexPath.row].text)
        return cell
      } else if item.tableViewDataSourceArray[indexPath.row].type == .Title || item.tableViewDataSourceArray[indexPath.row].type == .Description {
        var cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseIdentifier.ImgurTextCellReuseIdentifier, forIndexPath: indexPath) as ImgurTextCell
        cell.imgurText.text = item.tableViewDataSourceArray[indexPath.row].text
        return cell
      }
    } else if indexPath.section == GalleryItemTableSection.Comments.rawValue {
      let item = currentGalleryItem!
      let comment = item.tableViewDataSourceCommentsArray[indexPath.row].associatedComment!
      
      var cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseIdentifier.CommentCellReuseIdentifier, forIndexPath: indexPath) as CommentCell
      cell.authorButton.setTitle(comment.author, forState: .Normal)
      let authorSize = cell.authorButton.sizeThatFits(CGSizeMake(CGFloat.max, cell.authorButton.frame.size.height))
      cell.authorWidth.constant = authorSize.width
      if let points = comment.points {
        cell.pointsLabel.text = "\(points) points"
      } else {
        cell.pointsLabel.text = "0 points"
      }
      let pointsSize = cell.pointsLabel.sizeThatFits(CGSizeMake(CGFloat.max, cell.pointsLabel.frame.size.height))
      cell.pointsWidth.constant = pointsSize.width
      cell.imgurText.text = comment.comment
      if comment.children.count > 0 {
        cell.expandButton.hidden = false
      }
      
      if comment.expanded {
        cell.expandButton.setTitle("Collapse", forState: .Normal)
      }
      
      cell.associatedComment = comment
      cell.associatedGalleryItem = item
      cell.parentTableView = tableView
      return cell
    } else if indexPath.section == GalleryItemTableSection.GalleryItemInfo.rawValue {
      let item = currentGalleryItem!
      
      var cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseIdentifier.GalleryItemInfoCellReuseIdentifier, forIndexPath: indexPath) as GalleryItemInfoCell
      
      if item.loadingComments == true {
        cell.commentsInfoLabel.text = "Loading comments..."
      } else {
        var levelZeroComments = 0
        for theComment in item.comments {
          if theComment.depth == 0 {
            levelZeroComments++
          }
        }
        cell.commentsInfoLabel.text = "\(levelZeroComments) comments by Popularity"
      }
      
      return cell
    }
    return UITableViewCell()
  }
}