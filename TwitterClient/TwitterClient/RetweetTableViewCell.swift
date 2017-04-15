//
//  TweetTableViewCell.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/14/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit
import AFNetworking

class RetweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetImage: UIImageView!
    
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var tweetAtTime: UILabel!
    
    @IBOutlet weak var tweetOwner: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var replyCountLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!

    @IBOutlet weak var retweetedByLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var viewController: TweetsViewController?
    
    var associatedTweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setAssociation(tweet: Tweet) {
        associatedTweet = tweet
        
        if let retweetedBy = tweet.retweetedBy {
            retweetedByLabel.text = "\(retweetedBy) Retweeted"
        }
        
        if tweet.retweetedAlready {
            retweetButton.imageView?.image = UIImage(named: "retweet-green")
        }

        if tweet.favoritedAlready {
            favoriteButton.imageView?.image = UIImage(named: "favorite-red")
        }
        
        tweetContent.text = tweet.tweetMessage
        tweetContent.sizeToFit()
        
        if let tweetImageURL = tweet.imageURL {
            tweetImage.setImageWith(tweetImageURL, placeholderImage: UIImage(named: "tweet"))
        }
        tweetAtTime.text = "@" + (tweet.screenName)! + "·" + tweet.timeToNow
        
        if let favoritesCount = tweet.favoritesCount {
            if favoritesCount > 0 {
                favoriteCountLabel.text = String(favoritesCount)
            } else {
                favoriteCountLabel.text = ""
            }
        }
        
        if let replyCount = tweet.replyCount {
            if replyCount > 0 {
                replyCountLabel.text = String(replyCount)
            } else {
                replyCountLabel.text = ""
            }
        }
        
        if let retweetCount = tweet.retweetCount {
            if retweetCount > 0 {
                retweetCountLabel.text = String(retweetCount)
            } else {
                retweetCountLabel.text = ""
            }
        }
        
        if let tweetName = tweet.name {
            tweetOwner.text = tweetName
        }
    }
    
    @IBAction func retweet(_ sender: Any) {
        let tweetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if (associatedTweet?.retweetedAlready)! {
            let unretweenButton = UIAlertAction(title: "Undo Retweet", style: .default, handler: { (action) -> Void in
                TwitterClient.sharedInstance.unretweet(tweetId: (self.associatedTweet?.tweetId!)!, whenSucceeded: nil, whenFailed: nil)
                self.associatedTweet?.retweetCount = (self.associatedTweet?.retweetCount)!! - 1
                let retweetCount = (self.associatedTweet?.retweetCount)!
                if retweetCount == 0 {
                    self.retweetCountLabel.text = ""
                } else {
                    self.retweetCountLabel.text = String(retweetCount)
                }
                self.retweetButton.imageView?.image = UIImage(named: "retweet")
                self.associatedTweet?.retweetedAlready = false
            })
            tweetController.addAction(unretweenButton)
        } else {
            let retweenButton = UIAlertAction(title: "Retweet", style: .default, handler: { (action) -> Void in
                TwitterClient.sharedInstance.retweet(tweetId: (self.associatedTweet?.tweetId!)!, whenSucceeded: nil, whenFailed: nil)
                self.associatedTweet?.retweetCount = (self.associatedTweet?.retweetCount)!! + 1
                self.retweetCountLabel.text = String((self.associatedTweet?.retweetCount)!)
                self.retweetButton.imageView?.image = UIImage(named: "retweet-green")
                self.associatedTweet?.retweetedAlready = true
            })
            tweetController.addAction(retweenButton)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            tweetController.dismiss(animated: true, completion: nil)
        })
        tweetController.addAction(cancelButton)
        viewController?.navigationController?.present(tweetController, animated: true, completion: nil)
    }
    
    @IBAction func favorite(_ sender: Any) {
    }
}
