//
//  SearchViewController.swift
//  VangoodLive
//
//  Created by Stan on 2022/3/30.
//

import UIKit
import Lottie

class SearchViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fullScreenSize :CGSize!
    var animationView: AnimationView?
    
    var myLive:[Live] = []
    var filterMyLive:[Live] = []
    
    var myLiveAll:[Live] = []
    var filterMyLiveAll:[Live] = []
    
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullScreenSize = UIScreen.main.bounds.size
        collectionView.backgroundColor = .init(named: "BackgroundColor")
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18);
        layout.minimumLineSpacing = 18
        layout.itemSize = CGSize(
            width: CGFloat(fullScreenSize.width)/2 - 27.0,
            height: CGFloat(fullScreenSize.width)/2 - 27.0)
        layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 40)
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind:
                                    UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "Header")
        
        animationView = .init(name: "player2")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.animationSpeed = 2
        view.addSubview(animationView!)
        animationView?.isHidden = true
        
        searchBar.delegate = self
        let btn = searchBar.value(forKey: "cancelButton") as! UIButton
        btn.tintColor = .orange
        btn.setTitle("取消", for: .normal)
        
        guard let live:[Live] = lightyear_list.parseJson(lightyear_list.liveJson) else {
            print("parse fail")
            return
        }
        myLive = live
        
        guard let liveAll:[Live] = stream_list.parseJson(stream_list.liveJson) else {
            print("parse fail")
            return
        }
        myLiveAll = liveAll
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searching {
            if section == 0{
                return filterMyLiveAll.count
            }else{
                return myLive.count
            }
        }else {
            if section == 0{
                return 0
            }else{
                return myLive.count
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        if searching {
            if indexPath.section == 0{
                let filterLive = filterMyLiveAll[indexPath.row]
                let queue = DispatchQueue.global()
                queue.async {
                    let url = URL(string: filterLive.head_photo)
                    let urlFail = URL(string: "https://raw.githubusercontent.com/stan001182/mac.pic/pic/images/paopao%403x.png")
                    let data = try? Data(contentsOf: url!)
                    let dataFail = try? Data(contentsOf: urlFail!)
                    let img = UIImage(data: (data ?? dataFail)!)
                    DispatchQueue.main.async {
                        cell.head_photo.image = img
                    }
                }
                
                cell.head_photo.image = UIImage(systemName: "paopao")
                cell.online_num.text = String(filterLive.online_num)
                cell.tags.text = ("#\(filterLive.tags)")
                cell.nickname.text = filterLive.nickname
                cell.stream_title.text = filterLive.stream_title
            }else{
                
                let live = myLive[indexPath.row]
                let queue = DispatchQueue.global()
                queue.async {
                    let url = URL(string: live.head_photo)
                    let urlFail = URL(string: "https://raw.githubusercontent.com/stan001182/mac.pic/pic/images/paopao%403x.png")
                    let data = try? Data(contentsOf: url!)
                    let dataFail = try? Data(contentsOf: urlFail!)
                    let img = UIImage(data: (data ?? dataFail)!)
                    DispatchQueue.main.async {
                        cell.head_photo.image = img
                    }
                }
                
                cell.head_photo.image = UIImage(named: "paopao")
                cell.online_num.text = String(live.online_num)
                cell.tags.text = ("#\(live.tags)")
                cell.nickname.text = live.nickname
                cell.stream_title.text = live.stream_title
                
            }
        }else {
            if indexPath.section == 0{
                //沒搜尋時不用有東西
            }else{
                let live = myLive[indexPath.row]
                let queue = DispatchQueue.global()
                queue.async {
                    let url = URL(string: live.head_photo)
                    let urlFail = URL(string: "https://raw.githubusercontent.com/stan001182/mac.pic/pic/images/paopao%403x.png")
                    let data = try? Data(contentsOf: url!)
                    let dataFail = try? Data(contentsOf: urlFail!)
                    let img = UIImage(data: (data ?? dataFail)!)
                    DispatchQueue.main.async {
                        cell.head_photo.image = img
                    }
                }
                
                cell.head_photo.image = UIImage(named: "paopao")
                cell.online_num.text = String(live.online_num)
                cell.tags.text = ("#\(live.tags)")
                cell.nickname.text = live.nickname
                cell.stream_title.text = live.stream_title
            }
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at IndexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "CollectionReusableViewForHeader", for: IndexPath) as! CollectionReusableViewForHeader
        
        if searching {
            collectionView.frame.origin.y = 96
            if IndexPath.section == 0{
                headerView.frame.size.height = 30
                headerView.header.text = "搜尋結果"
            }else{
                headerView.frame.size.height = 30
                headerView.header.text = "熱門直播"
            }
        }else{
            collectionView.frame.origin.y = 56
            if IndexPath.section == 0{
                headerView.frame.size.height = 0
                headerView.header.text = ""
            }else{
                headerView.frame.size.height = 30
                headerView.header.text = "熱門直播"
            }
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,with: event)
        self.view.endEditing(true)
    }
}


// MARK: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterMyLiveAll = myLiveAll.filter {  $0.nickname.lowercased().contains(searchText.lowercased()) || $0.tags.lowercased().contains(searchText.lowercased()) || $0.stream_title.lowercased().contains(searchText.lowercased()) || String($0.online_num).lowercased().contains(searchText.lowercased())}
        searching = true
        if searchText.isEmpty {
            searching = false
        }
        self.collectionView?.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searching = false
        self.collectionView?.reloadData()
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
