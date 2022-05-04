//
//  GiftViewController.swift
//  VangoodLive
//
//  Created by Stan_Tseng on 2022/4/29.
//

import UIKit
import Lottie
import FirebaseAuth

class GiftViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var animationView: AnimationView?
    var fullScreenSize :CGSize!
    var giftItem = ["car","rocket-diamond","heart-fly","rocket","sakura","medal","wreath"]
    var giftpay =  ["30鑽石","99鑽石","199鑽石","399鑽石","999鑽石","1999鑽石","2999鑽石"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        giftView.layer.cornerRadius = 30
        giftView.clipsToBounds = true
        
        fullScreenSize = UIScreen.main.bounds.size
        collectionView.backgroundColor = .init(named: "BackgroundColor")
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        layout.minimumLineSpacing = 18
        layout.itemSize = CGSize(
            width: CGFloat(fullScreenSize.width)/3 - 27.0,
            height: CGFloat(fullScreenSize.width)/3)
    }
    
    @IBAction func downToDismiss(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giftItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCollectionViewCell", for: indexPath) as! GiftCollectionViewCell
        
        cell.giftPic.image = UIImage(named: giftItem[indexPath.row])
        cell.giftPay.text = giftpay[indexPath.row]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard Auth.auth().currentUser != nil else {
            alertview(title: "尚未登入", message: "請登入會員")
            return
        }
        
        let alertController = UIAlertController(title: "送禮給主播", message: "是否消費\(giftpay[indexPath.row])？", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("okay", comment: ""), style: .default) { [self] UIAlertAction in
            giftView.isHidden = true
            animationView = AnimateViewModel().makeAnimationView(initName: giftItem[indexPath.row], speed: 1)
            view.addSubview(animationView!)
            AnimateViewModel().playAnimation(animationView: animationView!)
            DispatchQueue.main.asyncAfter(deadline: .now()+4) {
                AnimateViewModel().stopAnimation(animationView: self.animationView!)
                self.dismiss(animated: true)
            }
        }
        let alertAction2 = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        alertController.addAction(alertAction2)
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    func alertview(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
}

