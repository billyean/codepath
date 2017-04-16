//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/13/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var tweets: [Tweet]?
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    var isMoreDataLoading = false
    
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tweetTableView.insertSubview(refreshControl, at: 0)
        
        let frame = CGRect(x: 0, y: tweetTableView.contentSize.height, width: tweetTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tweetTableView.addSubview(loadingMoreView!)
        
        var insets = tweetTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tweetTableView.contentInset = insets
        
        TwitterClient.sharedInstance.fetchTimeline(whenSucceeded: {tweets in
            self.tweets = tweets
            self.tweetTableView.reloadData()
        }, whenFailed: nil)
        // Do any additional setup after loading the view.
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.fetchTimeline(whenSucceeded: {tweets in
            self.tweets = tweets
            self.tweetTableView.reloadData()
            refreshControl.endRefreshing()
        }, whenFailed: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = tweets?[indexPath.row]
        if (tweet?.isRetweeted)! {
            let cell = tweetTableView.dequeueReusableCell(withIdentifier: "RetweetTableViewCell", for: indexPath) as? RetweetTableViewCell
            cell?.viewController = self
            cell?.setAssociation(tweet: tweet!)
            return cell!
        } else {
            let cell = tweetTableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as? TweetTableViewCell
            cell?.setAssociation(tweet: tweet!)
            cell?.viewController = self
            return cell!
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tweetTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tweetTableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tweetTableView.contentSize.height, width: tweetTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()		
            }
        }
    }
    
    func loadMoreData() {
        if tweets == nil || tweets?.count == 0 {
            TwitterClient.sharedInstance.fetchTimeline(whenSucceeded: { (newTweets) in
                self.tweets? = newTweets
                self.isMoreDataLoading = false
                self.loadingMoreView!.stopAnimating()
                self.tweetTableView.reloadData()
            }, whenFailed: nil)
        } else {
            if let oldestId = tweets?.last?.tweetId {
                TwitterClient.sharedInstance.fetchMoreTimeline(oldestId: oldestId, whenSucceeded: { (newTweets) in
                    self.tweets?.append(contentsOf: newTweets)
                    self.isMoreDataLoading = false
                    self.loadingMoreView!.stopAnimating()
                    self.tweetTableView.reloadData()
                }, whenFailed: nil)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func signOut(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let cell = sender as? UITableViewCell
            let indexPath = tweetTableView.indexPath(for: cell!)
            let target = segue.destination as? DetailTweetViewController
            if let tweet = tweets?[(indexPath?.row)!] {
                target?.tweet = tweet
            }
        } else if segue.identifier == "replyTweet" {
            let cell = sender as? UITableViewCell
            let indexPath = tweetTableView.indexPath(for: cell!)
            let target = segue.destination as? ReplyTweetViewController
            if let tweet = tweets?[(indexPath?.row)!] {
                target?.tweet = tweet
            }
        }
    }
}
