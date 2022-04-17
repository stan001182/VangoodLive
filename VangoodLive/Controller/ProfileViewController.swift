//
//  ProfileViewController.swift
//  VangoodLive
//
//  Created by Class on 2022/4/2.
//

import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageUI


class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    @IBOutlet weak var headShot: UIImageView!
    @IBOutlet weak var nicknameLB: UILabel!
    @IBOutlet weak var accountLB: UILabel!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headShot.clipsToBounds = true
        headShot.layer.cornerRadius = headShot.frame.height/2
        //刪除cache強迫重新抓取圖片，避免因網址相同而取用尚未換大頭照的舊照
        SDWebImageManager.shared.imageCache.clear(with: .all) {
            print("deleted all")
        }
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        let user = Auth.auth().currentUser
        let reference = Storage.storage().reference().child("\(user!.uid).jpeg")
        let placeholdImage = UIImage(named: "\(user!.uid).jpeg")
        let email = user!.email
        let uid = user!.uid
        let displayName = user!.displayName
        let photoUrl = user!.photoURL
        
        headShot.sd_setImage(with: reference, placeholderImage: placeholdImage)
        nicknameLB.text = displayName
        accountLB.text = email
        
        print("使用者帳號:\(email!),Uid編號:\(uid),暱稱:\((displayName)!),相片URL:\((photoUrl)!)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func changeNameBtn(_ sender: UIButton) {
        let controller = UIAlertController(title: "更改暱稱？", message: "請輸入新的暱稱", preferredStyle: .alert)
        controller.addTextField { textField in
            textField.placeholder = "暱稱"
        }
        
        let okAction = UIAlertAction(title: "確定", style: .default) { [unowned controller] _ in
            guard Auth.auth().currentUser != nil else {
                return
            }
            let user = Auth.auth().currentUser
            guard controller.textFields?[0].text != "" else{
                self.alertview(title: "欄位空白", message: "請輸入您的暱稱！")
                return
            }
            let nickname = controller.textFields?[0].text
            self.nicknameLB.text = nickname
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = nickname
            changeRequest?.commitChanges { error in
                print("修改後暱稱：\((user?.displayName)!)")
            }
            self.alertview(title: "修改成功", message: "歡迎你！\(nickname ?? "")")
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func choosePicBtn(_ sender: UIButton) {
        let controller = UIAlertController(title: "更換您的頭像?", message: "請選擇拍照或從相簿選取", preferredStyle: .actionSheet)
        let names = ["拍照","從相簿選取"]
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
    
    @IBAction func logOutBtn(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                dismiss(animated: false, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
   private func uploadToFirbaseStorage(referance_root:StorageReference,data:Data,file_name:String){
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        self.view.endEditing(true)
    }
    
    func alertview(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        print("info:\(info)")
        
        let image = info[.originalImage] as! UIImage
        headShot.image = image
        picker.dismiss(animated: true) {
            self.alertview(title: "修改成功", message: "頭像已更新")
        }
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        let reference_root = Storage.storage().reference()
        let data:Data = (self.headShot.image?.jpegData(compressionQuality: 0.1))!
        self.uploadToFirbaseStorage(referance_root: reference_root, data: data, file_name: Auth.auth().currentUser!.uid + ".jpeg")
        SDWebImageManager.shared.imageCache.clear(with:.all){
            print("deleted all")
        }
        
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
                        picker.dismiss(animated: true) {
                            self.alertview(title: "修改成功", message: "頭像已更新")
                        }
                        
                        guard Auth.auth().currentUser != nil else {
                            return
                        }
                        let reference_root = Storage.storage().reference()
                        let data:Data = (self.headShot.image?.jpegData(compressionQuality: 0.5))!
                        self.uploadToFirbaseStorage(referance_root: reference_root, data: data, file_name: Auth.auth().currentUser!.uid + ".jpeg")
                        SDWebImageManager.shared.imageCache.clear(with:.all){
                            print("deleted all")
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
