//
//  ViewController.swift
//  ParseDemo
//
//  Created by Tummala, Balaji on 4/12/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    
    let alertController = UIAlertController(title: "Succcess", message: "You have logined", preferredStyle: .alert)
    
    @IBAction func Login(_ sender: Any) {
        let username = emailLabel.text
        let password = passwordLabel.text
        
        PFUser.logInWithUsername(inBackground: username!, password: password!, block: {(user, error) in
            if  user != nil {
                print("Succeeded Login")
                self.performSegue(withIdentifier: "showChatRoom", sender: self)
            }
        })
    }
    
    @IBAction func SignUp(_ sender: Any) {
        let user = PFUser()
        user.username = emailLabel.text
        user.password = passwordLabel.text
        
        user.signUpInBackground(block: {(succeeded, error) in
            if succeeded {
                print("Succeeded Singup")
            } else {
                print("Error")
            }
        })
    }
    
    @IBOutlet weak var passwordLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

