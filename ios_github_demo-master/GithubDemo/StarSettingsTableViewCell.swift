//
//  StarSettingsTableViewCell.swift
//  GithubDemo
//
//  Created by biswa on 4/5/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class StarSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var minStarSlider: UISlider!
    @IBOutlet weak var minStarLabel: UILabel!
    
    var currentValue: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sliderchanged(_ sender: Any) {
        let currentVal: Int = Int(minStarSlider.value * 1000)
        minStarLabel.text = String.init(format: "%.0f", currentVal)
        currentValue = currentVal
    }
}
