//
//  ProfileTableViewCell.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/21/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var birthdayLabel: UILabel!
    
    @IBOutlet weak var tweetNumberLabel: UILabel!
    
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    @IBOutlet weak var followersNumberLabel: UILabel!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    var user: User?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(model: User) {
        user = model

        profileImageView.setImageWith((user?.profileImageURL)!)
        nameLabel.text = user?.name
        screenNameLabel.text = "@\((user?.screenName)!)"
        descriptionLabel.text = user?.profileDescription
        addressLabel.text = user?.address
        
        if let tweetsCount = user?.tweetsCount {
            tweetNumberLabel.text = String(describing: tweetsCount)
        }
        
        if let followingCount = user?.followingCount {
            followingNumberLabel.text = String(describing: followingCount)
        }
        
        if let followersCount = user?.followersCount {
            followersNumberLabel.text = String(describing: followersCount)
        }

        if let bannerImageURL = user?.bannerImageURL {
            bannerImageView.setImageWith(bannerImageURL)
        }
    }
}
