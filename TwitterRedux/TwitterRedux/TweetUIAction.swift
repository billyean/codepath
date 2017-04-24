//
//  TweetUIAction.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/21/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class TweetUIAction: NSObject {
    var tweet: Tweet
    
    var viewController: UIViewController
    
    init(withTweet: Tweet, onViewController targetViewController: UIViewController) {
        tweet = withTweet
        viewController = targetViewController
    }
    
    func favorite(_ favoriteCountLabel: UILabel, withImage favoriteButton: UIButton, _ favoritedIconName: String = "favorite-red", _ unfavoritedIconName: String = "favorite") {

            if tweet.favoritedAlready {
                TwitterClient.sharedInstance.favorite(tweetId: (self.tweet.tweetId!), whenSucceeded: nil, whenFailed: nil)
                self.tweet.favoritesCount = (self.tweet.favoritesCount)! - 1
                let favoritesCount = (self.tweet.favoritesCount)!
                if favoritesCount == 0 {
                    favoriteCountLabel.text = ""
                } else {
                    favoriteCountLabel.text = String(favoritesCount)
                }
                
                UIView.animate(withDuration: 0.3, animations: {
                    favoriteButton.alpha = 0.0
                    favoriteButton.imageView?.startAnimating()
                }, completion: { (finished) in
                    favoriteButton.imageView?.image = UIImage(named: unfavoritedIconName)
                    favoriteButton.alpha = 1.0
                    favoriteButton.imageView?.stopAnimating()
                })
                
                self.tweet.favoritedAlready = false
            } else {
                TwitterClient.sharedInstance.favorite(tweetId: (self.tweet.tweetId!), whenSucceeded: nil, whenFailed: nil)
                self.tweet.favoritesCount = (self.tweet.favoritesCount)! + 1
                let favoritesCount = (self.tweet.favoritesCount)!
                favoriteCountLabel.text = String(favoritesCount)
                
                UIView.animate(withDuration: 0.3, animations: {
                    favoriteButton.alpha = 0.0
                    favoriteButton.imageView?.startAnimating()
                }, completion: { (finished) in
                    favoriteButton.imageView?.image = UIImage(named: favoritedIconName)
                    favoriteButton.alpha = 1.0
                    favoriteButton.imageView?.stopAnimating()
                })
                
                self.tweet.favoritedAlready = true
            }
    }
    
    func retweet(_ retweetCountLabel: UILabel, withImage retweetButton: UIButton, _ retweetedIconName: String = "retweet-green", _ unretweetedIconName: String = "retweet") {

            let tweetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            if tweet.retweetedAlready {
                let unretweenButton = UIAlertAction(title: "Undo Retweet", style: .default, handler: { (action) -> Void in
                    TwitterClient.sharedInstance.unretweet(tweetId: (self.tweet.tweetId!), whenSucceeded: nil, whenFailed: nil)
                    self.tweet.retweetCount = (self.tweet.retweetCount)! - 1
                    let retweetCount = (self.tweet.retweetCount)!
                    if retweetCount == 0 {
                        retweetCountLabel.text = ""
                    } else {
                        retweetCountLabel.text = String(retweetCount)
                    }
                    retweetButton.imageView?.image = UIImage(named: "retweet")
                    self.tweet.retweetedAlready = false
                })
                tweetController.addAction(unretweenButton)
            } else {
                let retweenAction = UIAlertAction(title: "Retweet", style: .default, handler: { (action) -> Void in
                    TwitterClient.sharedInstance.retweet(tweetId: (self.tweet.tweetId!), whenSucceeded: nil, whenFailed: nil)
                    self.tweet.retweetCount = (self.tweet.retweetCount)! + 1
                    retweetCountLabel.text = String((self.tweet.retweetCount)!)
                    retweetButton.imageView?.image = UIImage(named: "retweet-green")
                    self.tweet.retweetedAlready = true
                })
                tweetController.addAction(retweenAction)
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                tweetController.dismiss(animated: true, completion: nil)
            })
            tweetController.addAction(cancelButton)
            viewController.present(tweetController, animated: true, completion: nil)
    }
}
