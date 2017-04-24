//
//  CommonViewController.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/23/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {
    let loginFaileAlertController = UIAlertController(title: "Error",
                                      message: "Authentication Error, please try again." as String, preferredStyle:.alert)

    @IBOutlet weak var tweetsTableView: UITableView!
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var signBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var newTweetBarButtonItem: UIBarButtonItem!
    
    var isMoreDataLoading = false
    
    var loadingMoreView: InfiniteScrollActivityView?
    
    var loadTweetClousure: ((@escaping ([Tweet]) -> Void, ((String) -> Void)?) -> ())?
    
    var loadMoreTweetClousure: ((Int, @escaping ([Tweet]) -> Void, ((String) -> Void)?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (User.sharedUserGroup.activeUser?.isLogined())! {
            signBarButtonItem.title = "Sign Out"
            signBarButtonItem.isEnabled = true
        } else {
            signBarButtonItem.title = "Sign In"
            newTweetBarButtonItem.isEnabled = false
        }
        
        view.layoutIfNeeded()
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        
        navigationItem.title = User.sharedUserGroup.activeUser?.name
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 120
        
        // Initiate InfiniteScrollActivityView
        let frame = CGRect(x: 0, y: tweetsTableView.contentSize.height, width: tweetsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tweetsTableView.addSubview(loadingMoreView!)
        
        var insets = tweetsTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tweetsTableView.contentInset = insets
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMoreData() {
        if tweets == nil || tweets?.count == 0 {
            loadTweetClousure?({ (newTweets) in
                self.tweets? = newTweets
                self.isMoreDataLoading = false
                self.loadingMoreView!.stopAnimating()
                self.tweetsTableView.reloadData()
            }, nil)
        } else {
            if let oldestId = tweets?.max(by: {$0.id! < $1.id!})?.id {
                loadMoreTweetClousure?(oldestId, { (newTweets) in
                    self.tweets?.append(contentsOf: newTweets)
                    self.isMoreDataLoading = false
                    self.loadingMoreView!.stopAnimating()
                    self.tweetsTableView.reloadData()
                }, nil)
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
    
    
    @IBAction func sign(_ sender: Any) {
        if signBarButtonItem.title == "Sign Out" {
            User.sharedUserGroup.activeUser?.deauthorize()
            signBarButtonItem.title = "Sign In"
            newTweetBarButtonItem.isEnabled = false
        } else {
            TwitterClient.sharedInstance.login(whenSucceeded: { user in
                User.sharedUserGroup.activateUser(user: user)
            }, whenFailed: { error in
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.loginFaileAlertController.addAction(okAction)
                self.present(self.loginFaileAlertController, animated: true, completion: nil)
            })
            signBarButtonItem.title = "Sign Out"
            newTweetBarButtonItem.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replyToTweet" {
            if let target = segue.destination as? ReplyToTweetViewController {
                target.tweet = sender as? Tweet
            }
        }
    }

}

extension CommonViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return (tweets?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = (tweets?[indexPath.row])!
        
        switch (tweet.isRetweeted, tweet.extended) {
        case (false, false):
            let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as? TweetTableViewCell
            cell?.setModel(model: tweet, onViewController: self)
            return cell!
        case (false, true):
            let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "TweetWithExtendedTableViewCell", for: indexPath) as? TweetWithExtendedTableViewCell
            cell?.setModel(model: tweet, onViewController: self)
            return cell!
        case (true, false):
            let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "RetweetTableViewCell", for: indexPath) as? RetweetTableViewCell
            cell?.setModel(model: tweet, onViewController: self)
            return cell!
        default:
            let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "RetweetWithExtendedTableViewCell", for: indexPath) as? RetweetWithExtendedTableViewCell
            cell?.setModel(model: tweet, onViewController: self)
            return cell!
        }
    }
}

extension CommonViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tweetsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetsTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tweetsTableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tweetsTableView.contentSize.height, width: tweetsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                
                // Code to load more results
                loadMoreData()
            }
        }
    }
}
