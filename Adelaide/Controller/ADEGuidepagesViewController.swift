//
//  GuidepagesViewController.swift
//  Adelaide
//
//  Created by Charles on 2020/11/12.
//

import UIKit

class ADEGuidepagesViewController: UIViewController,UIScrollViewDelegate {
    
    var pageControl:UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initSubviews()
        
    }
    
    func initSubviews() {
        let button:UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: (SCREENWIDTH-185)/2, y: SCREENHEIGHT-120, width: 185, height: 50)
        button .setTitle("Enter", for: .normal)
        button .setTitleColor(UIColor.white, for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button .addTarget(self, action:#selector(go(buttonGo:)), for: .touchUpInside)
        view.addSubview(button)
        

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //计算当前在第几页
//        pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x/SCREENWIDTH)
    }
    
    @objc func go(buttonGo:UIButton){
        self.performSegue(withIdentifier: "showTabbar", sender: buttonGo)
        
    }

}
