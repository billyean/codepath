//
//  SingleLabelCell.swift
//  Yelp
//
//  Created by Yan, Tristan on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class SingleLabelCell: UITableViewCell {

    @IBOutlet weak var seeAllLabel: UILabel!
    
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
