//
//  OnOrOffTableViewCell.swift
//  Yelp
//
//  Copyright © 2017 Haibo Yan. All rights reserved.
//

import UIKit
import TTSwitch

protocol SwitchBetweenOnAndOffDelegate: class {
    func onSwitch(cell: OnOrOffTableViewCell, changedValue value: Bool?)
}

class OnOrOffTableViewCell: UITableViewCell {
    weak var delegate: SwitchBetweenOnAndOffDelegate?
    
    @IBOutlet weak var OnOrOffLabel: UILabel!

    @IBOutlet weak var rectView: UIView!
    
    @IBOutlet weak var OnOrOffSwitch: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rectView.layer.borderColor = UIColor.lightGray.cgColor
        OnOrOffSwitch.isSelected = false
        OnOrOffSwitch.setImage(UIImage(named: "on"), for: .selected)
        OnOrOffSwitch.setImage(UIImage(named: "off"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func touchDown(_ sender: Any) {
        if OnOrOffSwitch.isSelected {
            OnOrOffSwitch.isSelected = false
        } else {
            OnOrOffSwitch.isSelected = true
        }

        delegate?.onSwitch(cell: self, changedValue: OnOrOffSwitch.isSelected)
    }

}
