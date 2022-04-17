//
//  ResetPasswordViewController.swift
//  VangoodLive
//
//  Created by Class on 2022/4/2.
//

import UIKit
import FirebaseAuth
import Lottie

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var account: UITextField!
    
    var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView = .init(name: "mail")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.animationSpeed = 2
        view.addSubview(animationView!)
        animationView?.isHidden = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "titlebarBack")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backBtn))
    }
    @objc func backBtn(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didEndOnExit(_ sender: UITextField) {
    }
    
    @IBAction func resetBtn(_ sender: UIButton) {
        
        animationView?.isHidden = false
        animationView!.play()
        
        if self.account.text == "" {
            alertview(title: "錯誤！", message: "請輸入帳號信箱.")
            self.animationView!.stop()
            self.animationView?.isHidden = true
        }else{
            Auth.auth().sendPasswordReset(withEmail: self.account.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "錯誤!"
                    message = ("無此會員或信箱格式錯誤，請重新輸入。\(error!.localizedDescription)")
                    self.animationView!.stop()
                    self.animationView?.isHidden = true
                    self.account.text = ""
                } else {
                    title = "成功!"
                    message = "密碼重設驗證信已發送."
                    self.animationView!.stop()
                    self.animationView?.isHidden = true
                    self.account.text = ""
                }
                self.alertview(title: title, message: message)
            })
        }
    }
    
    func alertview(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,with: event)
        self.view.endEditing(true)
    }
    
}
