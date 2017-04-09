//
//  OnOrOffTableViewCell.swift
//  Yelp
//
//  Copyright © 2017 Yan, Tristan. All rights reserved.
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
