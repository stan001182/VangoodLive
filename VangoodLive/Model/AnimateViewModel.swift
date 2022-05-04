//
//  GiftViewController.swift
//  VangoodLive
//
//  Created by Stan_Tseng on 2022/4/26.
//

import UIKit
import Lottie

class AnimateViewModel: UIViewController {
    
    var animationView : AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func makeAnimationView(initName:String,speed:CGFloat) -> AnimationView{
        animationView = .init(name: initName)
        animationView?.frame = view.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.animationSpeed = speed
        animationView?.isHidden = true
        return animationView!
    }

    func playAnimation(animationView:AnimationView){
        animationView.isHidden = false
        animationView.play()
    }
    
    func stopAnimation(animationView:AnimationView){
        animationView.stop()
        animationView.isHidden = true
    }
}
