//
//  ReplyTweetViewController.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/15/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController {
    
    var tweet: Tweet?
    
    @IBOutlet weak var detailTweetTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTweetTableView.delegate = self
        detailTweetTableView.dataSource = self
        
        detailTweetTableView.rowHeight = UITableViewAutomaticDimension
        detailTweetTableView.estimatedRowHeight = 22
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension DetailTweetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tweet?.favoritesCount)! > 0 || (tweet?.retweetCount)! > 0 {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if (tweet?.isRetweeted)! {
                let cell = detailTweetTableView.dequeueReusableCell(withIdentifier: "DetailRetweetTableViewCell", for: indexPath) as? DetailRetweetTableViewCell
                cell?.setAssociate(tweet: tweet!)
                return cell!
            } else {
                let cell = detailTweetTableView.dequeueReusableCell(withIdentifier: "DetailTweetTableViewCell", for: indexPath) as? DetailTweetTableViewCell
                cell?.setAssociate(tweet: tweet!)
                return cell!
            }
        } else {
            if indexPath.row == 1 && ((tweet?.favoritesCount)! > 0 || (tweet?.retweetCount)! > 0) {
                let cell = detailTweetTableView.dequeueReusableCell(withIdentifier: "ShowRetweetAndFavoriteTableViewCell", for: indexPath) as? ShowRetweetAndFavoriteTableViewCell
                cell?.setAssociate(tweet: tweet!)
                return cell!
            } else {
                let cell = detailTweetTableView.dequeueReusableCell(withIdentifier: "ActionsTableViewCell", for: indexPath) as? ActionsTableViewCell
                
                cell?.setAssociate(tweet: tweet!)
                cell?.viewController = self
                cell?.detailTweetTableView = self.detailTweetTableView
                return cell!
            }
        }
    }
}
