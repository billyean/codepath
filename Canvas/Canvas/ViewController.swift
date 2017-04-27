//
//  ViewController.swift
//  Canvas
//
//  Created by Yan, Tristan on 4/19/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    var originalPoint: CGPoint!
    
    var expectedHeight: CGFloat!
    
    @IBOutlet weak var downImage: UIImageView!
    
//    var savedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expectedHeight = downImage.frame.origin.y + (downImage.image?.size.height)! + 10
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func onTrayPanGesture(_ sender: UIPanGestureRecognizer) {
//        let point = sender.location(in: view)
//        
//        switch sender.state {
//        case .began:
//            originalPoint = trayView.center
//        case .changed:
//            let translation = sender.translation(in: view)
//            trayView.center = CGPoint(x: originalPoint.x, y: originalPoint.y + translation.y)
//        case .ended:
//            let velocity = sender.velocity(in: view)
//            
//            if velocity.y < 0 {
//               trayView.center = originalPoint
//            } else {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.trayView.frame.origin.y = self.view.frame.size.height - self.expectedHeight
//                })
//                
//            }
//            
//        default:
//            break
//        }
//    }

    @IBAction func dragIcon(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: view)
        
        switch sender.state {
        case .began:
//            savedImageView = sender.view as! UIImageView
            break
        case .changed:
            break
        case .ended:
            let point = sender.location(in: view)
            let savedImageView = sender.view as! UIImageView
            if point.y < trayView.frame.origin.y - savedImageView.frame.size.height / 2 {
                let movedImageView = UIImageView(image: savedImageView.image)
                movedImageView.frame.origin.x = point.x - savedImageView.frame.size.width / 2
                movedImageView.frame.origin.y = point.y - savedImageView.frame.size.height / 2
                movedImageView.isUserInteractionEnabled = true
//                let gesture = UIPanGestureRecognizer(target: self, action: #selector(makeBigger(_:)))
                let pinGesture = UIPinchGestureRecognizer(target: self, action: #selector(transform(_:)))
                
//                imageView.addGestureRecognizer(gesture)
                movedImageView.addGestureRecognizer(pinGesture)
                view.addSubview(movedImageView)
            }
//            let velocity = sender.velocity(in: view)
//            
//            if velocity.y < 0 {
//                trayView.center = originalPoint
//            } else {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.trayView.frame.origin.y = self.view.frame.size.height - self.expectedHeight
//                })
//                
//            }
            
        default:
            break
        }
        
    }
    
    func makeBigger(_ sender: UIPanGestureRecognizer) {
        print("make Bigger")
        switch sender.state {
        case .began:
            break
        case .changed:
            break
        case .ended:
            let imageView = sender.view as! UIImageView
            imageView.frame.origin.x -= 5
            imageView.frame.origin.y -= 5
            imageView.frame.size.width += 10
            imageView.frame.size.height += 10
        default:
            break
        }
    }

    func transform(_ sender: UIPanGestureRecognizer) {
        print("make transform")
        switch sender.state {
        case .began:
            break
        case .changed:
            break
        case .ended:
            let imageView = sender.view as! UIImageView
            imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        default:
            break
        }
    }

}

