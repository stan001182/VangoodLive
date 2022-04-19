//
//  ProfileLogOutViewController.swift
//  VangoodLive
//
//  Created by Class on 2022/3/30.
//

import UIKit
import FirebaseAuth

class ProfileLogInViewController: UIViewController {
    
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var seePassword: UIButton!
    var iconClick = true
    var isSelected:Bool = false
    var rememberAccount:String = ""
    var rememberPassword:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("我是登入頁面")
        account.text = ""
        password.text = ""
        loadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        guard Auth.auth().currentUser != nil else {
            return
        }
        //如果用push的話會有返回按鈕，而且點tabbar會再跳回登入頁面，所以用currentContext，present的方式。
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
        vc?.modalPresentationStyle = .currentContext
        self.present(vc!, animated: false, completion: nil)
    }
    
    @IBAction func didEndOnExitFirst(_ sender: UITextField) {
    }
    @IBAction func didEndOnExitSecond(_ sender: UITextField) {
    }
    
    @IBAction func registBtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegistViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func seePasswordBtn(_ sender: UIButton) {
        if(iconClick == true) {
            password.isSecureTextEntry = false
            seePassword.configuration?.background.image = UIImage(named: "eye")
        } else {
            password.isSecureTextEntry = true
            seePassword.configuration?.background.image = UIImage(named: "eyeblock")
        }
        iconClick = !iconClick
    }
    
    
    // MARK: - checkbox
    @IBAction func checkBox(_ sender: UIButton) {
        if isSelected == false{
            checkbox.setImage(UIImage(named: "Checkbox-fill"), for: .normal)
            isSelected = true
            print(isSelected)
            saveData()
        }else{
            checkbox.setImage(UIImage(named: "Checkbox"), for: .normal)
            isSelected = false
            print(isSelected)
            saveDataClear()
        }
    }
    
    func loadData() {
        let userDefaults = UserDefaults.standard
        
        if let account = userDefaults.string(forKey: "account") {
            self.account.text = account
        }
        
        if let password = userDefaults.string(forKey: "password") {
            self.password.text = password
        }
        
        if let isSelected = userDefaults.string(forKey: "isSelected") {
            print(isSelected)
            self.isSelected = Bool(isSelected)!
            
            if self.isSelected == true{
                checkbox.setImage(UIImage(named: "Checkbox-fill"), for: .normal)
            }else{
                checkbox.setImage(UIImage(named: "Checkbox"), for: .normal)
            }
        }
    }
    
    func saveData() {
        let userDefaults = UserDefaults.standard
        
        let account = account.text ?? ""
        let password = password.text ?? ""
        let isSelected = "true"
        
        userDefaults.set(account, forKey: "account")
        userDefaults.set(password, forKey: "password")
        userDefaults.set(isSelected, forKey: "isSelected")
        
    }
    
    func saveDataClear() {
        let userDefaults = UserDefaults.standard
        
        let account =  ""
        let password =  ""
        let isSelected = "false"
        
        userDefaults.set(account, forKey: "account")
        userDefaults.set(password, forKey: "password")
        userDefaults.set(isSelected, forKey: "isSelected")
    }
    
    
    @IBAction func signInBtn(_ sender: UIButton) {
        
        if account.text == "" || account.text?.trimmingCharacters(in: .whitespaces) == "" || password.text == "" || password.text?.trimmingCharacters(in: .whitespaces) == "" {
            alertview(title: "錯誤！帳號或密碼空白", message: "請輸入帳號密碼")
        }else if password.text!.count < 6 || password.text!.count > 12{
            
            alertview(title: "錯誤！密碼不在6-12碼內", message: "請重新輸入密碼")
        }else if account.text!.count < 4 || account.text!.count > 20{
            
            alertview(title: "錯誤！帳號不在4-20碼內", message: "請重新輸入帳號")
        }else {
            
            Auth.auth().signIn(withEmail: self.account.text!, password: self.password.text!) { (result, error) in
                
                if error == nil {
                    self.tabBarController!.selectedIndex = 0
                    
                }else{
                    self.alertview(title: "錯誤", message: "帳號或密碼錯誤,\(error!.localizedDescription)")
                }
            }
        }
        if isSelected == true{
            saveData()
        }else{
            saveDataClear()
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
