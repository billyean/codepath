//
//  ViewController.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/11/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let alertView = UIAlertController(title: "Error",
                                          message: "Authentication Error, please try again." as String, preferredStyle:.alert)
    
    @IBAction func login(_ sender: Any) {
        TwitterClient.sharedInstance.login(whenSucceeded: {() in
            self.performSegue(withIdentifier: "showTweets", sender: self)
        }, whenFailed: {(error) in
            let okAction = UIAlertAction(title: error, style: .default, handler: nil)
            self.alertView.addAction(okAction)
            self.present(self.alertView, animated: true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if TwitterClient.sharedInstance.currentUser != nil {
            self.performSegue(withIdentifier: "showTweets", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

