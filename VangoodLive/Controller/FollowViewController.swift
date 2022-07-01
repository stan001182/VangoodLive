//
//  FollowViewController.swift
//  VangoodLive
//
//  Created by Stan_Tseng on 2022/5/6.
//

import UIKit

class FollowViewController: UIViewController {

    var hostpicArray = [String]()
    var hostbgArray = [String]()
    var hostname = [String]()
    var hosttitle = [String]()
    var nickname = NSLocalizedString("visitor", comment: "")
    var streamerid = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(hostname[0])
        print(hosttitle[0])
        print(nickname)
        print(streamerid[0])
    }
    
   
    
}

extension FollowViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hostpicArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowCollectionViewCell", for: indexPath) as! FollowCollectionViewCell
        let queue = DispatchQueue.global()
        queue.async {
            let url = URL(string: self.hostpicArray[indexPath.row])
            let urlFail = URL(string: "https://raw.githubusercontent.com/stan001182/mac.pic/pic/images/paopao%403x.png")
            let data = try? Data(contentsOf: url!)
            let dataFail = try? Data(contentsOf: urlFail!)
            let img = UIImage(data: ((data ?? dataFail)!))
            DispatchQueue.main.async {
                cell.hostPic.image = img
            }
        }
        cell.hostPic.image = UIImage(named: "paopao")
        
        return cell
    }
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "LiveRoomViewController") as? LiveRoomViewController{
            controller.modalPresentationStyle = .fullScreen
            
//            controller.hostpic = UIImage(named: "paopao")
            controller.hostname = self.hostname[indexPath.row]
            controller.hosttitle = self.hosttitle[indexPath.row]
            controller.streamerid = self.streamerid[indexPath.row]
            print(self.hostname[indexPath.row])
            print(self.hosttitle[indexPath.row])
            print(self.streamerid[indexPath.row])
            
            let queue = DispatchQueue.global()
            queue.async {
                let url = URL(string: self.hostpicArray[indexPath.row])
                let url2 = URL(string: self.hostbgArray[indexPath.row])
                let urlFail = URL(string: "https://raw.githubusercontent.com/stan001182/mac.pic/pic/images/paopao%403x.png")
                let data = try? Data(contentsOf: url!)
                let data2 = try? Data(contentsOf: url2!)
                let dataFail = try? Data(contentsOf: urlFail!)
                let img = UIImage(data: ((data ?? dataFail)!))
                let img2 = UIImage(data: ((data2 ?? dataFail)!))
                DispatchQueue.main.async {
                    controller.hostpic = img
                    print("trtrtrtrtrtrtrtrtrtrt")
                    controller.hostbg = img2
                }
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
                    present(controller, animated: true, completion: nil)
                }
//            present(controller, animated: true, completion: nil)
        }
        
    }


}
