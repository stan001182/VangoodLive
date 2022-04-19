//
//  ProfileViewController.swift
//  VangoodLive
//
//  Created by Stan on 2022/3/29.
//

import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import Lottie


class RegistViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    @IBOutlet weak var headShot: UIImageView!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var seePassword: UIButton!
    
    var iconClick = true
    var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        password.placeholder = "請輸入6-12位字母或數字"
        headShot.clipsToBounds = true
        headShot.layer.cornerRadius = headShot.frame.height/2
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    
    @IBAction func didEndOnExitFirst(_ sender: Any) {
    }
    @IBAction func didEndOnExitSecond(_ sender: UITextField) {
    }
    @IBAction func didEndOnExitThird(_ sender: Any) {
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
    
    @IBAction func registBtn(_ sender: Any) {
        
        
        animationView?.isHidden = false
        animationView!.play()
        
        if account.text == "" || password.text == "" {
            
            alertview(title: "錯誤！帳號或密碼空白", message: "請輸入帳號密碼")
            self.animationView!.stop()
            self.animationView?.isHidden = true
        }else if password.text!.count < 6 || password.text!.count > 12{
            
            alertview(title: "錯誤！密碼不在6-12碼內", message: "請重新輸入密碼")
            self.animationView!.stop()
            self.animationView?.isHidden = true
            
        }else if account.text!.count < 4 || account.text!.count > 20{
            
            alertview(title: "錯誤！帳號不在4-20碼內", message: "請重新輸入帳號")
            self.animationView!.stop()
            self.animationView?.isHidden = true
        }else {
            Auth.auth().createUser(withEmail: account.text!, password: password.text!) { (result, error) in
                
                if (result?.user) != nil {
                    
                    self.animationView!.stop()
                    self.animationView?.isHidden = true
                    
                    let reference_root = Storage.storage().reference()
                    
                    let data:Data = (self.headShot.image?.jpegData(compressionQuality: 0.1))!
                    self.uploadToFirbaseStorage(referance_root: reference_root, data: data, file_name: Auth.auth().currentUser!.uid + ".jpeg")
                    
                    let user = Auth.auth().currentUser
                    let reference = Storage.storage().reference().child("\(user!.uid).jpeg")
                    let photoUrl = "\(reference)"
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.nickname.text
                    changeRequest?.photoURL = URL(string: photoUrl);            changeRequest?.commitChanges { error in
                        // ...
                        
                        print("暱稱：\((user?.displayName)!),相片URL:\((user?.photoURL)!),Email:\((user?.email)!)")
                    }
                    
                    print("註冊成功")
                    print((result?.user.email)!,(result?.user.uid)!)
                    
                    let alertController = UIAlertController(title: "歡迎！！", message: "註冊成功", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "確定", style: .cancel) { UIAlertAction in
                        
                        self.dismiss(animated: false)
                        print("該換頁囉")
                        self.navigationController?.popViewController(animated: false)
                        print("該換頁囉")
                        
                    }
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    self.animationView!.stop()
                    self.animationView?.isHidden = true
                    let alertController = UIAlertController(title: "錯誤", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func choosePicBtn(_ sender: UIButton) {
        let controller = UIAlertController(title: "更換您的頭像?", message: "請選擇拍照或從相簿選取", preferredStyle: .actionSheet)
        let names = ["拍照", "從相簿選取"]
        for _name in names {
            let action = UIAlertAction(title: _name, style: .default) { action in
                switch _name {
                case "拍照":
                    guard UIImagePickerController.isSourceTypeAvailable(.camera)
                    else
                    {
                        print("無法使用相機")
                        return
                    }
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                case "從相簿選取":
                    var configuration = PHPickerConfiguration(photoLibrary: .shared())
                    configuration.filter = PHPickerFilter.images
                    configuration.preferredAssetRepresentationMode = .current
                    configuration.selection = .ordered
                    let picker = PHPickerViewController(configuration: configuration)
                    picker.delegate = self
                    self.present(picker, animated: true, completion: nil)
                default:
                    print("錯誤")
                }
            }
            controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func uploadToFirbaseStorage(referance_root:StorageReference,data:Data,file_name:String){
        let reference_i_save:StorageReference = referance_root.child(file_name)
        reference_i_save.putData(data,metadata: nil){
            (info,error)
            in
            if let err = error{
                print("上傳失敗")
                print(err)
            }else{
                print("上傳成功")
            }
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        print("info:\(info)")
        
        let image = info[.originalImage] as! UIImage
        headShot.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
    {
        print("挑選到的照片：\(results)")
        
        if let itemProvider = results.first?.itemProvider
        {
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier)
            {
                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) {
                    data, error
                    in
                    guard let photoData = data
                    else
                    {
                        return
                    }
                    DispatchQueue.main.async {
                        self.headShot.image = UIImage(data: photoData)
                        picker.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func alertview(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround(){
        let tapGesture = UITapGestureRecognizer(target: self,action: #selector(self.hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - keyboard監聽
extension RegistViewController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -(keyboardHeight)/3
        } else {
            view.frame.origin.y = -view.frame.height / 3
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}
