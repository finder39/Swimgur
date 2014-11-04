//
//  GalleryItem.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/10/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

protocol GalleryItemProtocol {
  func squareThumbnailURIForSize(size:CGSize) -> String
  
  func setupTableViewDataSourceArray()
}

public class GalleryItem {
  public var id: String = ""
  public var title: String = ""
  public var description: String?
  public var datetime: Int = 0
  public var link: String = ""
  public var accountURL: String?
  public var accountID: Int?
  public var ups: Int = 0
  public var downs: Int = 0
  public var score: Int = 0
  public var isAlbum: Bool = false
  public var views: Int = 0
  public var favorite: Bool = false
  public var vote: String?
  public var nsfw: Bool?
  
  public var comments: [Comment] = []
  
  // used to prevent loading twice
  private var loadingComments = false
  
  // array to use in tableview datasource
  public var tableViewDataSourceArray:[GalleryItemTableItem] = []
  public var tableViewDataSourceCommentsArray:[GalleryItemTableItem] = []
  
  init() {
    
  }
  
  public func appendLetterToLink(letter:String) -> String {
    return self.link.stringByReplacingOccurrencesOfString(".", withString: "\(letter).", options: NSStringCompareOptions.LiteralSearch, range: self.link.rangeOfString(".", options: NSStringCompareOptions.BackwardsSearch))
  }
  
  public func vote(vote:GalleryItemVote) {
    SWNetworking.sharedInstance.voteOnGalleryItem(galleryItemId: self.id, vote: vote, onCompletion: nil)
  }
  
  public func getComments(onCompletion:SWBoolBlock) {
    if !loadingComments {
      loadingComments = true
      SWNetworking.sharedInstance.getComments(galleryItemId: self.id, onCompletion: { (comments) -> () in
        self.loadingComments = false
        self.comments = comments
        self.setupTableViewDataSourceCommentsArray()
        onCompletion(success: true)
      }, onError: { (error, description) -> () in
        self.loadingComments = false
        onCompletion(success: false)
      })
    }
  }
  
  // MARK: Comment array management
  
  public func updateTableViewDataSourceCommentsArray() {
    self.setupTableViewDataSourceCommentsArray()
  }
  
  internal func setupTableViewDataSourceCommentsArray() {
    tableViewDataSourceCommentsArray.removeAll(keepCapacity: false)
    if comments.count > 0 {
      for comment in comments {
        subCommentRecursiveAddTest(comment)
      }
    }
  }
  
  internal func subCommentRecursiveAddTest(comment:Comment) {
    tableViewDataSourceCommentsArray.append(GalleryItemTableItem(comment: comment))
    if comment.expanded {
      for child in comment.children {
        subCommentRecursiveAddTest(child)
      }
    }
  }
}