//
//  ReplyTweetViewController.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/15/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class ReplyTweetViewController: NewTweetViewController {

//    @IBOutlet weak var userImageView: UIImageView!
//    
//    @IBOutlet weak var textView: UITextView!
//    
//    @IBOutlet weak var tweetButton: UIButton!
//    
//    @IBOutlet weak var borderView: UIView!
//    
//    @IBOutlet weak var charCountLabel: UILabel!
    
    @IBOutlet weak var replyToLabel: UILabel!
    
    var tweet: Tweet?

    var toWho: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        placeHolderText = "Tweet your reply"
        
        toWho = "@" + (tweet?.screenName)!
        
        if (tweet?.isRetweeted)! {
            toWho = toWho! + "and @" + (tweet?.retweetedByScreenName)!
        }
        
        replyToLabel.text = "Replying to \(toWho!)"
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func replyToTweet(_ sender: Any) {
        let replyMessage = toWho! + " " + textView.text
        if textView.text.characters.count > 0 {
            TwitterClient.sharedInstance.replyTweet(message: replyMessage, toTweetId: (tweet?.tweetId)!, whenSucceeded: nil, whenFailed: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
