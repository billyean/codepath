//
//  MultipleSelectionTableViewCell.swift
//  Yelp
//
//  Created by Yan, Tristan on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class MultipleSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var checkedImage: UIImageView!
    
    @IBOutlet weak var rectView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rectView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
