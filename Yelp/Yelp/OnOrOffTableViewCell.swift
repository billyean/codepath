//
//  OnOrOffTableViewCell.swift
//  Yelp
//
//  Created by Yan, Tristan on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import TTSwitch

class OnOrOffTableViewCell: UITableViewCell {
    
    @IBOutlet weak var OnOrOffLabel: UILabel!

    @IBOutlet weak var rectView: UIView!
    
    @IBOutlet weak var OnOrOffSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rectView.layer.borderColor = UIColor.lightGray.cgColor
        //        let leadingOrigin = OnOrOffLabel.frame.origin
        //        let leadingSize = OnOrOffLabel.frame.size
        //        let tailingOriginal = rectView.frame.origin
        //        let tailingSize = rectView.frame.size
        //
        //        let width: Double = 50
        //        let height: Double = 24
        //        let tailingSpace: Double = 6
        //
        //        let x = Double(tailingOriginal.x) + Double(tailingSize.width) - width - tailingSpace
        //        let y = Double(leadingOrigin.y) + Double(leadingSize.height / 2) - height / 2
        //
        //        OnOrOffSwitch = TTSwitch(frame: CGRect(x: x, y: y, width: width, height: height))
        //        OnOrOffSwitch.thumbImage = UIImage(named: "Yelp")
        //        OnOrOffSwitch.onString = "ON"
        //        OnOrOffSwitch.offString = "OFF"
        //        rectView.addSubview(OnOrOffSwitch)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
