//
//  YelpUISwitch.swift
//  Yelp
//
//  Created by Haibo Yan on 4/7/17.
//  Copyright © 2017 Haibo Yan. All rights reserved.
//

import UIKit

class YelpUISwitch: UISwitch {
    let thumbImage = UIImage(named: "Yelp")
    
    var offLabel = UILabel()
    
    var onLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        offLabel.text = "OFF"
        offLabel.textAlignment = .right
        offLabel.bounds = frame
        onLabel.text = "ON"
        onLabel.textAlignment = .left
        onLabel.backgroundColor = UIColor(red: 135, green: 206, blue: 250, alpha: 1.0)
        offLabel.bounds = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        if isOn {
            offLabel.draw(rect)
        } else {
            onLabel.draw(rect)
        }
    }

}
