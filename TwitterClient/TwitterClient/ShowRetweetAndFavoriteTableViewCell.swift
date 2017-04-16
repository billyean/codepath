//
//  ShowRetweetAndFavoriteTableViewCell.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/15/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class ShowRetweetAndFavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var retweetedCountLabel: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAssociate(tweet: Tweet) {
        retweetedCountLabel.text = String(tweet.retweetCount ?? 0)
        favoriteCountLabel.text = String(tweet.favoritesCount ?? 0)
        self.sizeToFit()
    }

}
