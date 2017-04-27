//
//  ProfileViewController.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/21/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class ProfileViewController: CommonViewController {
    var headerView: ProfileTableViewCell?

    var contentOriginY: CGFloat?
    
    var originHeaderHeight: CGFloat?
    
    var user: User?
    
    var initiateLoad = false
    
    var bannerImageView: UIImageView?
    
    var savedImage: UIImage?
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.y
        
        headerView = tweetsTableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as? ProfileTableViewCell
        bannerImageView = headerView?.bannerImageView
        user = User.sharedUserGroup.activeUser
        
        headerView?.setModel(model: user!)
        tweetsTableView.tableHeaderView = headerView
        
        originHeaderHeight = headerView?.bannerImageView.bounds.height


        TwitterClient.sharedInstance.fetchUserTimeline(
            (user?.id!)!,
            whenSucceeded: { (timelines) in
            self.tweets = timelines
            self.tweetsTableView.reloadData()
            self.initiateLoad = true
                self.savedImage = self.bannerImageView?.image
        }, whenFailed: nil)

        loadTweetClousure = getLoadTweetClousure()
        loadMoreTweetClousure = getLoadMoreTweetClousure()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if initiateLoad {
            let topOffset = -scrollView.contentInset.top
            if scrollView.contentOffset.y <  topOffset {
                print(topLayoutConstraint.constant)
                let originHeight = bannerImageView?.bounds.height
                let offToTop = scrollView.contentOffset.y - topOffset
                let scaleY = -offToTop / originHeight!

                let headerTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -scaleY, 0)
                let scaleTransform = CATransform3DScale(headerTransform, 1.0, 1.0 + scaleY, 0)
                bannerImageView?.layer.transform = scaleTransform
                bannerImageView?.bounds.origin.y = offToTop

                let context = CIContext()
                let filter = CIFilter(name: "CIGaussianBlur")
                let image = CIImage(image: (bannerImageView?.image)!)
                filter?.setValue(image, forKey: kCIInputImageKey)
                filter?.setValue(5, forKey: "inputRadius")
                if let output =  filter?.outputImage {
                    var rect = output.extent
                    rect.origin.x += (rect.size.width  - (bannerImageView?.image?.size.width)! ) / 2
                    rect.origin.y += (rect.size.height  - (bannerImageView?.image?.size.height)! ) / 2
                    rect.size = (bannerImageView?.image?.size)!
                    let cgimageresult = context.createCGImage(output, from: rect)
                    let result = UIImage(cgImage: cgimageresult!)
                    bannerImageView?.image = result
                }
            } else {
                bannerImageView?.image = savedImage
            }
        }
    }
    
    

    
    func getLoadTweetClousure() -> ((@escaping ([Tweet]) -> Void, ((String) -> Void)?) -> ())? {
        func loadTweetClousure(succeed: @escaping ([Tweet]) -> Void, failed: ((String) -> Void)?) {
            return TwitterClient.sharedInstance.fetchUserTimeline(user!.id!, whenSucceeded: succeed, whenFailed: failed)
        }
        return loadTweetClousure
    }
    
    func getLoadMoreTweetClousure() -> ((Int, @escaping ([Tweet]) -> Void, ((String) -> Void)?) -> ())? {
        func loadMoreTweetClousure(oldestId: Int, succeed: @escaping ([Tweet]) -> Void, failed: ((String) -> Void)?) {
            return TwitterClient.sharedInstance.fetchMoreUserTimeline(user!.id!, oldestId: oldestId, whenSucceeded: succeed, whenFailed: failed)
        }
        return loadMoreTweetClousure
    }
}



