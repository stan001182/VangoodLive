//
//  CollectionViewController.swift
//  VangoodLive
//
//  Created by Stan on 2022/3/28.
//

import UIKit
import Lottie

class HomeCollectionViewController: UICollectionViewController {

    var myLive:[Live] = []
    var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView = .init(name: "player2")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.animationSpeed = 2
        view.addSubview(animationView!)
        animationView?.isHidden = true
        
        guard let live:[Live] = stream_list.parseJson(stream_list.liveJson) else {
            print("parse fail")
            return
        }
        myLive = live
        print(live)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return myLive.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let live = myLive[indexPath.row]
        cell.head_photo.image = UIImage(named: "paopao")
        cell.online_num.text = String(live.online_num)
        cell.tags.text = ("#\(live.tags)")
        cell.nickname.text = live.nickname
        cell.stream_title.text = live.stream_title
        
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
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        animationView?.isHidden = false
        animationView!.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
            animationView?.isHidden = true
            animationView!.stop()
            if let controller = storyboard?.instantiateViewController(withIdentifier: "LiveRoomViewController") as? LiveRoomViewController{
                controller.modalPresentationStyle = .fullScreen
                present(controller, animated: true, completion: nil)
        }
        
        }
        
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
