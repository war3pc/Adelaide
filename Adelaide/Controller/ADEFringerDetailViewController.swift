//
//  ADEFringerDetailViewController.swift
//  Adelaide
//
//  Created by Charles on 2020/11/13.
//

import UIKit

class ADEFringerDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var venueLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var dislikeBtn: UIButton!
    
    @IBOutlet weak var placeSwitch: UISwitch!
    public weak var delegate: ADEFringerDetailDelegate?
    
    var finger: ADEFringer!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setFinger(finger)
        placeSwitch.isOn = UserDefaults.standard.bool(forKey: "Replace")

    }
    
    @IBAction func replaceChange(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "Replace")
        UserDefaults.standard.synchronize()
    }
    
}

extension ADEFringerDetailViewController {
    fileprivate func setFinger(_ finger: ADEFringer) {
        let url = URL(string: "http://www.partiklezoo.com/fringer/images/\(finger.image)")!
        imgView.kf.setImage(with: url)
        nameLabel.text = finger.name
        artistLabel.text = finger.artist
        venueLabel.text = finger.venue
        descLabel.text = finger.desc
        likeBtn.setTitle("like(\(finger.likes))", for: .normal)
        dislikeBtn.setTitle("dislike(\(finger.dislikes))", for: .normal)
    }
    
    @IBAction func clickLike() {
        self.delegate?.clickLike(fingerId: finger.id, complection: { (like, dislike) in
            self.likeBtn.setTitle("like(\(like))", for: .normal)
            self.dislikeBtn.setTitle("dislike(\(dislike))", for: .normal)
            self.finger.dislikes = dislike
            self.finger.likes = like
        })

    }
    
    @IBAction func clickDislike() {
        self.delegate?.clickDislike(fingerId: finger.id, complection: { (like, dislike) in
            self.likeBtn.setTitle("like(\(like))", for: .normal)
            self.dislikeBtn.setTitle("dislike(\(dislike))", for: .normal)
            self.finger.dislikes = dislike
            self.finger.likes = like
        })

    }
}

extension ADEFringerDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < view.frame.size.width {
            var p = scrollView.contentOffset
            p.x = 0
            scrollView.contentOffset = p
        }
    }
}
