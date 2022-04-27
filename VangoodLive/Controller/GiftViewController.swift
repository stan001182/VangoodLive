//
//  GiftViewController.swift
//  VangoodLive
//
//  Created by Stan_Tseng on 2022/4/26.
//

import UIKit
import Lottie

class GiftViewController: UIViewController {

    var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func giftAnimate(view:AnimationView,initName:String){
        animationView = .init(name: initName)
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.animationSpeed = 2
        view.addSubview(animationView!)
        animationView?.isHidden = true
    }

}
