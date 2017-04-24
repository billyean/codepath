//
//  TweetTableViewCell.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/22/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetImage: UIImageView!
    
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var tweetAtTime: UILabel!
    
    @IBOutlet weak var tweetOwner: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var replyCountLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!
    
    var tweetAction: TweetUIAction!
    
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tweetImage.isUserInteractionEnabled = true
        tweetImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if tweet.screenName != User.sharedUserGroup.activeUser?.screenName {
            viewController?.performSegue(withIdentifier: "showUserProfile", sender: tweet.screenName)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setModel(model: Tweet, onViewController controller: UIViewController) {
        tweet = model
        tweetAction = TweetUIAction(withTweet: tweet, onViewController: controller)
        viewController = controller
        
        
        if tweet.retweetedAlready {
            retweetButton.imageView?.image = UIImage(named: "retweet-green")
        }
        
        if tweet.favoritedAlready {
            favoriteButton.imageView?.image = UIImage(named: "favorite-red")
        }
        
        tweetContent.text = tweet.tweetMessage
        
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
        tweetAction.retweet(retweetCountLabel, withImage: retweetButton)
    }
    
    @IBAction func favorite(_ sender: Any) {
        tweetAction.favorite(favoriteCountLabel, withImage: favoriteButton)
    }
    
    @IBAction func replyTo(_ sender: Any) {
        viewController?.performSegue(withIdentifier: "replyToTweet", sender: tweet)
    }
    
    
    
}
