//
//  TabBarViewController.swift
//  VangoodLive
//
//  Created by Class on 2022/3/30.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var img1 : UIImageView!
    var img2 : UIImageView!
    var img3 : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imgView = self.tabBar.subviews[0]
        self.img1 = imgView.subviews.first as? UIImageView
        self.img1.contentMode = .center
        imgView = self.tabBar.subviews[1]
        self.img2 = imgView.subviews.first as? UIImageView
        self.img2.contentMode = .center
        imgView = self.tabBar.subviews[2]
        self.img3 = imgView.subviews.first as? UIImageView
        self.img3.contentMode = .center
        self.delegate = self
        
        self.img1.clipsToBounds = true
        self.img2.clipsToBounds = true
        self.img3.clipsToBounds = true
        
        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0{
            self.img1.transform = CGAffineTransform(rotationAngle: 360).scaledBy(x: 4, y: 4).translatedBy(x: -10, y: 0)
            self.img1.backgroundColor = .init(named: "TabBarAnimateColor")
            self.img1.layer.cornerRadius = 13.5
            
            UIView.animate(withDuration: 0.5) {
                self.img1.transform = .identity
                self.img1.backgroundColor = .clear
                self.img1.layer.cornerRadius = 0
            }
        }
        if item.tag == 1{
            self.img2.transform = CGAffineTransform(rotationAngle: 360).scaledBy(x: 4, y: 4).translatedBy(x: -10, y: 0)
            self.img2.backgroundColor = .init(named: "TabBarAnimateColor")
            self.img2.layer.cornerRadius = 13.5
            
            UIView.animate(withDuration: 0.5) {
                self.img2.transform = .identity
                self.img2.backgroundColor = .clear
                self.img2.layer.cornerRadius = 0
            }
        }
        if item.tag == 2{
            self.img3.transform = CGAffineTransform(rotationAngle: 360).scaledBy(x: 4, y: 4).translatedBy(x: -10, y: 0)
            self.img3.backgroundColor = .init(named: "TabBarAnimateColor")
            self.img3.layer.cornerRadius = 13.5
            
            UIView.animate(withDuration: 0.5) {
                self.img3.transform = .identity
                self.img3.backgroundColor = .clear
                self.img3.layer.cornerRadius = 0
            }
        }
    }
}
