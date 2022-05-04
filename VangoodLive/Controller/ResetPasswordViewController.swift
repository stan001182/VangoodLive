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
        
        animationView = AnimateViewModel().makeAnimationView(initName: "mail", speed: 2)
        view.addSubview(animationView!)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "titlebarBack")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backBtn))
    }
    @objc func backBtn(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didEndOnExit(_ sender: UITextField) {
    }
    
    @IBAction func resetBtn(_ sender: UIButton) {
       
        AnimateViewModel().playAnimation(animationView: animationView!)
        
        if self.account.text == "" {
            alertview(title: NSLocalizedString("title11", comment: ""), message: NSLocalizedString("message11", comment: ""))
            AnimateViewModel().stopAnimation(animationView: animationView!)
        }else{
            Auth.auth().sendPasswordReset(withEmail: self.account.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = NSLocalizedString("title12", comment: "")
                    message = ("\(NSLocalizedString("title12", comment: ""))\(error!.localizedDescription)")
                    AnimateViewModel().stopAnimation(animationView: self.animationView!)
                    self.account.text = ""
                } else {
                    title = NSLocalizedString("title13", comment: "")
                    message = NSLocalizedString("message13", comment: "")
                    AnimateViewModel().stopAnimation(animationView: self.animationView!)
                    self.account.text = ""
                }
                self.alertview(title: title, message: message)
            })
        }
    }
    
    func alertview(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("okay", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,with: event)
        self.view.endEditing(true)
    }
    
}
