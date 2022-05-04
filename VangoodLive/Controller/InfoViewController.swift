//
//  InfoViewController.swift
//  
//
//  Created by Stan_Tseng on 2022/4/28.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class InfoViewController: UIViewController {
    
    @IBOutlet weak var hostPic: UIImageView!
    @IBOutlet weak var hostBackground: UIImageView!
    @IBOutlet weak var hostTitle: UIButton!
    @IBOutlet weak var hostName: UIButton!
    @IBOutlet weak var followPic: UIImageView!
    @IBOutlet weak var followBtn: UIButton!
    
    var streamerid : Int?
    var hostpic : UIImage?
    var hostbg : UIImage?
    var hostname : String?
    var hosttitle : String?
    var followOrNot = "true"
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostPic.image = hostpic
        hostBackground.image = hostbg
        hostTitle.setTitle(hosttitle, for: .normal)
        hostName.setTitle("大家好\u{1F600}\u{2665}\u{FE0F}!!我是\(hostname!)", for: .normal)
        hostName.titleLabel?.numberOfLines = 1
        // Do any additional setup after loading the view.
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        let userEmail = Auth.auth().currentUser?.email
        let docRef = db.collection(userEmail!).document(String(streamerid!))
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let messageObject = document.data(with: ServerTimestampBehavior.none)
                self.followBtn.setTitle((messageObject!["follow"]! as! String), for: .normal)
                print(messageObject!["follow"]!)
                self.followPic.isHidden = .init(messageObject!["isHidden"]! as! String)!
                print(messageObject!["isHidden"]!)
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        
        
        
    }
    
    @IBAction func followBtn(_ sender: UIButton) {
        
        guard Auth.auth().currentUser != nil else {
            alertview(title: "尚未登入", message: "請登入會員")
            return
        }
        let userEmail = Auth.auth().currentUser?.email
        
        if sender.titleLabel?.text == "Follow"{
            sender.setTitle("Unfollow", for: .normal)
            followPic.isHidden = false
            followOrNot = "false"
            
            db.collection(userEmail!).document(String(streamerid!)).setData([
                "follow": "Unfollow",
                "isHidden": followOrNot
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
        }else{
            sender.setTitle("Follow", for: .normal)
            followPic.isHidden = true
            followOrNot = "true"
            
            db.collection(userEmail!).document(String(streamerid!)).setData([
                "follow": "Follow",
                "isHidden": followOrNot
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
        }
    }
    
    
    @IBAction func downToDissmiss(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    func alertview(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
