//
//  NewTweetViewController.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/14/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit
import AFNetworking

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var tweetButton: UIButton!
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var charCountLabel: UILabel!
    
    var placeHolderText = "What's happening?"
    
    var tweetsViewController: TweetsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let user = TwitterClient.sharedInstance.currentUser {
            userImageView.setImageWith(user.profileURL!)
        }
        textView.delegate = self
        
        borderView.layer.borderColor = UIColor.black.cgColor
        textView.text = placeHolderText
        textView.textColor = UIColor.lightGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            tweetButton.isEnabled = true
            let red = CGFloat(0.0)
            let green = CGFloat(172.0 / 255)
            let blue = CGFloat(237.0 / 255)
            let alpha = CGFloat(1.0)
            tweetButton.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            tweetButton.tintColor = UIColor.white
            charCountLabel.textColor = UIColor.gray
            
            let leftChars = 140 - textView.text.characters.count
            charCountLabel.text = String(leftChars)
            
            if leftChars < 0 {
                charCountLabel.textColor = UIColor.red
                tweetButton.isEnabled = false
                tweetButton.backgroundColor = UIColor.white
                tweetButton.tintColor = UIColor.gray
            }
        } else {
            tweetButton.isEnabled = false
            tweetButton.backgroundColor = UIColor.white
            tweetButton.tintColor = UIColor.gray
            charCountLabel.text = ""
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new vieirst w controller.
    }
    */

    @IBAction func cancelTweet(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func createNewTweet(_ sender: Any) {
        if let tweetMessage = textView.text {
            if tweetMessage.characters.count > 0 {
                
                TwitterClient.sharedInstance.createNewTweet(message: tweetMessage, whenSucceeded: {(tweet) in
                    self.tweetsViewController?.tweets?.insert(tweet, at: 0)
                    self.tweetsViewController?.tweetTableView.reloadData()
                }, whenFailed: nil)
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
