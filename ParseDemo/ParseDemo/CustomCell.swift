//
//  CustomCell.swift
//  ParseDemo
//
//  Created by Tummala, Balaji on 4/12/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var messageLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
