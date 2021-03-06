//
//  HomeViewController.swift
//  VangoodLive
//
//  Created by Class on 2022/4/9.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageUI
import Lottie

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIWindowSceneDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var headShot: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var topViewHight: NSLayoutConstraint!
    
    var fullScreenSize :CGSize!
    var myLive:[Live] = []
    var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //設定collection view
        fullScreenSize = UIScreen.main.bounds.size
        print(fullScreenSize.width)
        collectionView.backgroundColor = .init(named: "BackgroundColor")
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 18, bottom: 0, right: 18);
        layout.minimumLineSpacing = 18
        layout.itemSize = CGSize(
            width: CGFloat(fullScreenSize.width)/2 - 27.0,
            height: CGFloat(fullScreenSize.width)/2 - 27.0)
        
        
        //設定lottie animate
        animationView = AnimateViewModel().makeAnimationView(initName: "player2", speed: 2)
        view.addSubview(animationView!)
       
        //解析取得json資料
        guard let live:[Live] = stream_list.parseJson(stream_list.liveJson) else {
            print("parse fail")
            return
        }
        myLive = live
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("home viewWillAppear")
        
        //當沒有會員時將顯示會員資料的view高度設為0
        topViewHight.constant = Auth.auth().currentUser == nil ? 0 : 40
        
        //判斷是否有會員，有的話才去firebase取得會員資料
        guard Auth.auth().currentUser != nil else {
            headShot.image = UIImage(named: "picPersonal")
            nickname.text = NSLocalizedString("visitor", comment: "")
            return
        }
        let user = Auth.auth().currentUser
        let reference = Storage.storage().reference().child("\(user!.uid).jpeg")
        let placeholdImage = UIImage(named: "\(user!.uid).jpeg")
        let displayName = user!.displayName
        headShot.sd_setImage(with: reference, placeholderImage: placeholdImage)
        nickname.text = displayName
    }
    
    @IBAction func sceneModeBtn(_ sender: UIButton) {
        darkOrLight()
        if sender.titleLabel?.text == "Dark Mode"{
            sender.setTitle("Light Mode", for: .normal)
            sender.backgroundColor = .white
        }else{
            sender.setTitle("Dark Mode", for: .normal)
            sender.backgroundColor = .black
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myLive.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let live = myLive[indexPath.row]
        let queue = DispatchQueue.global()
        queue.async {
            let url = URL(string: live.head_photo)
            let urlFail = URL(string: "https://raw.githubusercontent.com/stan001182/mac.pic/pic/images/paopao%403x.png")
            let data = try? Data(contentsOf: url!)
            let dataFail = try? Data(contentsOf: urlFail!)
            let img = UIImage(data: ((data ?? dataFail)!))
            DispatchQueue.main.async {
                cell.head_photo.image = img
            }
        }
        cell.head_photo.image = UIImage(named: "paopao")
        cell.online_num.text = String(live.online_num)
        cell.tags.text = ("#\(live.tags)")
        cell.nickname.text = live.nickname
        cell.stream_title.text = live.stream_title
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        AnimateViewModel().playAnimation(animationView: animationView!)
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "LiveRoomViewController") as? LiveRoomViewController{
            controller.modalPresentationStyle = .fullScreen
            
            let live = myLive[indexPath.row]
            let queue = DispatchQueue.global()
            queue.async {
                let url = URL(string: live.head_photo)
                let url2 = URL(string: live.background_image)
                let urlFail = URL(string: "https://raw.githubusercontent.com/stan001182/mac.pic/pic/images/paopao%403x.png")
                let data = try? Data(contentsOf: url!)
                let data2 = try? Data(contentsOf: url2!)
                let dataFail = try? Data(contentsOf: urlFail!)
                let img = UIImage(data: ((data ?? dataFail)!))
                let img2 = UIImage(data: ((data2 ?? dataFail)!))
                DispatchQueue.main.async {
                    controller.hostpic = img
                    controller.hostbg = img2
                }
                controller.hostname = live.nickname
                controller.hosttitle = live.stream_title
                controller.streamerid = live.streamer_id
                controller.hostpicURL = live.head_photo
                controller.hostbgURL = live.background_image
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
            AnimateViewModel().stopAnimation(animationView: animationView!)
                present(controller, animated: true, completion: nil)
            }
            
        }
        
    }
    
    func darkOrLight() {
        let keyWindow = self.view.window!.windowScene?.keyWindow
        let llll = UIButton()
        if keyWindow?.overrideUserInterfaceStyle == .light{
        keyWindow?.overrideUserInterfaceStyle = .dark
        }else{
            keyWindow?.overrideUserInterfaceStyle = .light
        }
    }
}
