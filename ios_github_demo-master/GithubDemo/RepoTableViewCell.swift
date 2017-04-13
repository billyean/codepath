//
//  RepoTableViewCell.swift
//  GithubDemo
//
//  Created by biswa on 4/5/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var starLabel: UILabel!
    
    
    @IBOutlet weak var forkLabel: UILabel!
    
    
    @IBOutlet weak var authorLabel: UILabel!
    
    
    @IBOutlet weak var authorImage: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
