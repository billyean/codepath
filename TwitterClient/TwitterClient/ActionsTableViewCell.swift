//
//  ActionsTableViewCell.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/15/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class ActionsTableViewCell: UITableViewCell {
    
    var associatedTweet: Tweet?
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var detailTweetTableView: UITableView!

    var viewController: DetailTweetViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setAssociate(tweet: Tweet) {
        associatedTweet = tweet
        self.sizeToFit()
    }
    
    @IBAction func retweet(_ sender: Any) {
        let tweetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if (associatedTweet?.retweetedAlready)! {
            let unretweenButton = UIAlertAction(title: "Undo Retweet", style: .default, handler: { (action) -> Void in
                TwitterClient.sharedInstance.unretweet(tweetId: (self.associatedTweet?.tweetId!)!, whenSucceeded: nil, whenFailed: nil)
                self.associatedTweet?.retweetCount = (self.associatedTweet?.retweetCount)!! - 1

                self.retweetButton.imageView?.image = UIImage(named: "retweet")
                self.associatedTweet?.retweetedAlready = false
                self.detailTweetTableView.reloadData()
            })
            tweetController.addAction(unretweenButton)
        } else {
            let retweenButton = UIAlertAction(title: "Retweet", style: .default, handler: { (action) -> Void in
                TwitterClient.sharedInstance.retweet(tweetId: (self.associatedTweet?.tweetId!)!, whenSucceeded: nil, whenFailed: nil)
                self.associatedTweet?.retweetCount = (self.associatedTweet?.retweetCount)!! + 1
                self.retweetButton.imageView?.image = UIImage(named: "retweet-green")
                self.associatedTweet?.retweetedAlready = true
                self.detailTweetTableView.reloadData()
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
        if (associatedTweet?.favoritedAlready)! {
            TwitterClient.sharedInstance.unfavorite(tweetId: (self.associatedTweet?.tweetId!)!, whenSucceeded: nil, whenFailed: nil)
            self.associatedTweet?.favoritesCount = (self.associatedTweet?.favoritesCount)!! - 1
            
            UIView.animate(withDuration: 0.3, animations: {
                self.favoriteButton.alpha = 0.0
                self.favoriteButton.imageView?.startAnimating()
            }, completion: { (finished) in
                self.favoriteButton.imageView?.image = UIImage(named: "favorite")
                self.favoriteButton.alpha = 1.0
                self.favoriteButton.imageView?.stopAnimating()
            })
            
            self.associatedTweet?.favoritedAlready = false
            self.detailTweetTableView.reloadData()
        } else {
            TwitterClient.sharedInstance.favorite(tweetId: (self.associatedTweet?.tweetId!)!, whenSucceeded: nil, whenFailed: nil)
            self.associatedTweet?.favoritesCount = (self.associatedTweet?.favoritesCount)!! + 1
            
            UIView.animate(withDuration: 0.3, animations: {
                self.favoriteButton.alpha = 0.0
                self.favoriteButton.imageView?.startAnimating()
            }, completion: { (finished) in
                self.favoriteButton.imageView?.image = UIImage(named: "favorite-red")
                self.favoriteButton.alpha = 1.0
                self.favoriteButton.imageView?.stopAnimating()
            })
            
            self.associatedTweet?.favoritedAlready = true
            self.detailTweetTableView.reloadData()
        }
    }
}
