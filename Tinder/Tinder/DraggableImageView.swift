//
//  DraggableImageView.swift
//  Tinder
//
//  Created by Yan, Tristan on 4/26/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class DraggableImageView: UIView {
    var originCenterPoint: CGPoint?
    
    @IBOutlet var contentView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var ryanImageView: UIImageView!
    
    @IBAction func dragIt(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self.superview)
        let translation = sender.translation(in: self.superview)
        
        switch sender.state {
        case .began:
            originCenterPoint = self.center
            
        case .changed:
                UIView.animate(withDuration: 1, animations: {
                    self.center.x = point.x
                    self.transform = CGAffineTransform(rotationAngle: translation.x / (45  * CGFloat.pi))
                })
        case .ended:
            if translation.x > 120 {
                UIView.animate(withDuration: 1, delay: 5, options: [], animations: {
                    self.center.x = (self.originCenterPoint?.x)! + ((self.superview?.frame.width)! * 2)
                }, completion: { finished in
                    self.center = self.originCenterPoint!
                    self.transform = CGAffineTransform(rotationAngle: 0)
                })
            } else if translation.x < -120 {
                UIView.animate(withDuration: 1, delay: 5, options: [], animations: {
                    self.center.x = (self.originCenterPoint?.x)! - ((self.superview?.frame.width)! * 2)
                }, completion: { finished in
                    self.center = self.originCenterPoint!
                    self.transform = CGAffineTransform(rotationAngle: 0)
                })
            } else {
                UIView.animate(withDuration: 1, animations: {
                    self.center = self.originCenterPoint!
                    self.transform = CGAffineTransform(rotationAngle: 0)
                })
            }
        default:
            break
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        let nib = UINib(nibName: "DraggableImageView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
    }
    
    var image: UIImage? {
        set {
            ryanImageView.image = newValue
        }
        get {
            return ryanImageView.image
        }
    }
    

}

