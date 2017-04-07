//
//  OnOrOffTableViewCell.swift
//  Yelp
//
//  Created by Yan, Tristan on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class OnOrOffTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var OnOrOffLabel: UILabel!
    
    
    @IBOutlet weak var OnOrOffSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
