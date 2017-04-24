//
//  TimelineViewController.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/23/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class TimelinesViewController: CommonViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.fetchTimeline(whenSucceeded: { (timelines) in
            self.tweets = timelines
            self.tweetsTableView.reloadData()
        }, whenFailed: nil)
        loadTweetClousure = TwitterClient.sharedInstance.fetchTimeline
        loadMoreTweetClousure = TwitterClient.sharedInstance.fetchMoreTimeline
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
