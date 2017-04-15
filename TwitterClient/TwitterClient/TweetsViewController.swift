//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/13/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tweets: [Tweet]?
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        
        TwitterClient.sharedInstance.fetchTimeline(whenSucceeded: {tweets in
            self.tweets = tweets
            self.tweetTableView.reloadData()
        }, whenFailed: nil)
        // Do any additional setup after loading the view.
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
}
