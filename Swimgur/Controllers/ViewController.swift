//
//  ViewController.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/4/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let imgurLoginController = ImgurLoginController()
                            
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
    self.authenticateAndGetAccount()
  }
  
  func authenticateAndGetAccount() {
    imgurLoginController.authorizeWithViewController(self) { (success) -> () in
      if success {
        // TODO: Move on
      } else {
        // TODO: Give error
      }
    }
  }
}

