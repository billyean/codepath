//
//  ProfileViewController.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/21/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class ProfileViewController: CommonViewController {
    var headerView: ProfileTableViewCell?

    var contentOriginY: CGFloat?
    
    var originHeaderHeight: CGFloat?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.y
        let headerView = tweetsTableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as? ProfileTableViewCell
        headerView?.setModel(model: User.sharedUserGroup.activeUser!)
        tweetsTableView.tableHeaderView = headerView
        originHeaderHeight = headerView?.bounds.height

        TwitterClient.sharedInstance.fetchUserTimeline(
            whenSucceeded: { (timelines) in
            self.tweets = timelines
            self.tweetsTableView.reloadData()
        }, whenFailed: nil)
        loadTweetClousure = TwitterClient.sharedInstance.fetchUserTimeline
        loadMoreTweetClousure = TwitterClient.sharedInstance.fetchMoreUserTimeline
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//    func switchTo() {
//        let userId = User.sharedUserGroup.activeUser?.id
//        TwitterClient.sharedInstance.fetchUserTimeline(whenSucceeded: { (timelines) in
//            self.tweets = timelines
//            self.tweetsTableView.reloadData()
//        }, whenFailed: nil)
//    }
}



