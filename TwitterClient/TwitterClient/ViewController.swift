//
//  ViewController.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/11/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TwitterClient.sharedInstance.login(username: "", withPassword: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

