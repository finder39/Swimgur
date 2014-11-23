//
//  ViewController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/4/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var buttonLogin: UIButton!
  let imgurLoginController = ImgurLoginController()
  let springAnimationController = SpringTransition()
  var hasAppeared = false
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if hasAppeared {
      self.buttonLogin.hidden = false
    } else {
      hasAppeared = true
      self.checkForExistingSession()
    }
  }
  
  func checkForExistingSession() {
    self.buttonLogin.hidden = true
    imgurLoginController.verifyStoredAccount { (success) -> () in
      if success {
        self.performSegueWithIdentifier(Constants.Segue.SegueWelcomeToMaster, sender:self)
      } else {
        self.buttonLogin.hidden = false
      }
    }
  }
  
  func authenticateAndGetAccount() {
    imgurLoginController.authorizeWithViewController(self) { (success) -> () in
      if success {
        self.performSegueWithIdentifier(Constants.Segue.SegueWelcomeToMaster, sender:self)
      } else {
        // TODO: Give error
      }
    }
  }
  
  @IBAction func login(sender: AnyObject) {
    self.authenticateAndGetAccount()
  }
  
  // MARK: UIViewControllerTransitioningDelegate
  
  func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
    return self.springAnimationController
  }
}

