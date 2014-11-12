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
    self.registerNib(UINib(nibName: "ImgurImageCell", bundle: nil), forCellReuseIdentifier: "ImgurImageCellReuseIdentifier")
    self.registerNib(UINib(nibName: "ImgurTextCell", bundle: nil), forCellReuseIdentifier: "ImgurTextCellReuseIdentifier")
    self.registerNib(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCellReuseIdentifier")
    
    textCell = self.dequeueReusableCellWithIdentifier("ImgurTextCellReuseIdentifier") as ImgurTextCell
    commentCell = self.dequeueReusableCellWithIdentifier("CommentCellReuseIdentifier") as CommentCell
    
    self.delegate = self
    self.dataSource = self
  }
  
  // galleryitem functions
  
  func loadImage() {
    if let item = currentGalleryItem {
      item.getComments({ (success) -> () in
        self.reloadData()
      })
      
      //self.title = item.title
      //self.colorFromVote(item)
      
      // http://stackoverflow.com/questions/19896447/ios-7-navigation-bar-height
      /*UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
      self.navigationController!.navigationBar.bounds = CGRectMake(0, 0, self.navigationController!.navigationBar.frame.size.width, 100)
      }, completion: { (done) -> Void in
      
      })*/
      if let galleryImage = item as? GalleryImage {
        self.reloadData()
      } else if let galleryAlbum = item as? GalleryAlbum {
        if galleryAlbum.images.count == 0 {
          galleryAlbum.getAlbum(onCompletion: { (album) -> () in
            DataManager.sharedInstance.galleryItems[self.galleryIndex] = album
            self.loadImage()
          })
        } else {
          self.reloadData()
        }
      }
    }
  }
  
  // MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 0 {
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
    } else if indexPath.section == 1 {
      if let item = currentGalleryItem {
        let comment = item.tableViewDataSourceCommentsArray[indexPath.row].associatedComment!
        commentCell.imgurText.text = comment.comment
        let size = commentCell.imgurText.sizeThatFits(CGSizeMake(tableView.frame.size.width, CGFloat.max))
        return size.height+24
      }
    }
    return 60
  }
  
  func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
    if indexPath.section == 0 {
      
    } else if indexPath.section == 1 {
      let item = currentGalleryItem!
      let comment = item.tableViewDataSourceCommentsArray[indexPath.row].associatedComment!
      
      return comment.depth
    }
    return 0
  }
  
  // MARK: UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let item = currentGalleryItem {
      if section == 0 {
        return item.tableViewDataSourceArray.count
      } else if section == 1 {
        return item.tableViewDataSourceCommentsArray.count
      }
    }
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let item = currentGalleryItem!
      
      if item.tableViewDataSourceArray[indexPath.row].type == .Image {
        var cell = tableView.dequeueReusableCellWithIdentifier("ImgurImageCellReuseIdentifier", forIndexPath: indexPath) as ImgurImageCell
        SWNetworking.sharedInstance.setImageView(cell.imgurImage, withURL: item.tableViewDataSourceArray[indexPath.row].text)
        return cell
      } else if item.tableViewDataSourceArray[indexPath.row].type == .Title || item.tableViewDataSourceArray[indexPath.row].type == .Description {
        var cell = tableView.dequeueReusableCellWithIdentifier("ImgurTextCellReuseIdentifier", forIndexPath: indexPath) as ImgurTextCell
        cell.imgurText.text = item.tableViewDataSourceArray[indexPath.row].text
        return cell
      }
    } else if indexPath.section == 1 {
      let item = currentGalleryItem!
      let comment = item.tableViewDataSourceCommentsArray[indexPath.row].associatedComment!
      
      var cell = tableView.dequeueReusableCellWithIdentifier("CommentCellReuseIdentifier", forIndexPath: indexPath) as CommentCell
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
    }
    return UITableViewCell()
  }
}