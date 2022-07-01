//
//  ViewController.swift
//  VangoodLive
//
//  Created by Stan on 2022/3/28.
//

import UIKit
import AVFoundation
import Lottie
import FirebaseAuth
//import YouTubeiOSPlayerHelper
import FirebaseFirestore

class LiveRoomViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var moveView: UIView!
    @IBOutlet weak var realCount: UILabel!
    @IBOutlet weak var hostPic: UIImageView!
    @IBOutlet weak var hostName: UILabel!
    @IBOutlet weak var hostTitle: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var followPic: UIImageView!
    
    @IBOutlet weak var changeHight: NSLayoutConstraint!
    
    
    var player : AVPlayer?
    var animationView: AnimationView?
    var user : User?
    var nickname = NSLocalizedString("visitor", comment: "")
    var hostpic : UIImage?
    var hostname : String?
    var hosttitle : String?
    var hostbg : UIImage?
    var streamerid : Int?
    var hostpicURL : String?
    var hostbgURL : String?
    var webSocketTask:URLSessionWebSocketTask?
    var receiveResult = [String]()
    let db = Firestore.firestore()
    
    var timer : Timer?
    
    var videoResult :[videoInfo]?
    var channelInfo :channelInfo?
    var videoID = ["gFfcEN_7kQ","vN-VsPKHW1k","Vx1zPxKTmTw","eexmdt3Q8yk","yD0RC6l7UMk"]
//    lazy var videoPlayerView = YTPlayerView()
    
    
    private lazy var layer : AVPlayerLayer? = {
        //        let remoteURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "hime3", ofType: "mp4")!
        //        )
        
        let remoteURL = Bundle.main.url(forResource: "hime3", withExtension: "mp4")
        self.player = AVPlayer(url: remoteURL!)
        player?.audiovisualBackgroundPlaybackPolicy = .continuesIfPossible
        let layer = AVPlayerLayer(player: self.player)
        layer.frame = self.view.layer.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return layer
    }()
    
    private let runLabel : UILabel = {
        let Label = UILabel()
        Label.frame = CGRect(x: 414, y: 150, width: 414, height: 40)
        Label.text = "我是公告"
        Label.textColor = .white
        Label.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.7)
        Label.clipsToBounds = true
        Label.layer.cornerRadius = 20
        Label.numberOfLines = 1
        Label.adjustsFontSizeToFitWidth = true
        return Label
    }()
    
    private let runLabel2 : UILabel = {
        let Label = UILabel()
        Label.frame = CGRect(x: 414, y: 200, width: 207, height: 40)
        Label.text = "我是公告"
        Label.textColor = .white
        Label.backgroundColor = .systemOrange
        Label.clipsToBounds = true
        Label.layer.cornerRadius = 20
        Label.numberOfLines = 1
        Label.adjustsFontSizeToFitWidth = true
        Label.textAlignment = .center
        return Label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchChanelInfo()
//        fetchPlayListInfo()
        
        self.view.addSubview(runLabel)
        self.view.addSubview(runLabel2)
        
        
        
        //        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runAction), userInfo: nil, repeats: true)
        
        
        //youtube串流
        //        let parameter = ["playsinline" : "1", "modestbranding" : "0"]
        //        videoPlayerView.delegate = self
        //        videoPlayerView.frame = self.view.bounds
        ////        videoPlayerView.frame.size.height = self.view.frame.self.height/2
        //        videoPlayerView.isUserInteractionEnabled = false
        //        self.view.addSubview(videoPlayerView)
        //        self.view.sendSubviewToBack(videoPlayerView)
        //        videoPlayerView.load(withVideoId: videoID.randomElement()!, playerVars: parameter)
        //        videoPlayerView.playVideo()
        
        
        messageTF.delegate = self
        tableView.allowsSelection = false
        alertView.isHidden = true
        messageTF.textColor = .white
        realCount.layer.cornerRadius = 10
        hostPic.image = hostpic
        hostPic.layer.cornerRadius = 23
        hostName.text = hostname
        hostTitle.text = hosttitle
        infoView.layer.cornerRadius = 20
        
        
        
        // 設定 Cell 的高度能自我調整
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        // 將tableview倒置
        tableView.transform = CGAffineTransform(rotationAngle: .pi)
        
        
        //將player壓到下層
        let playerView = UIView()
        playerView.layer.addSublayer(layer!)
        self.view.addSubview(playerView)
        self.view.sendSubviewToBack(playerView)
        
        guard Auth.auth().currentUser != nil else {
            webSocketConnect()
            receive()
            return
        }
        user = Auth.auth().currentUser
        nickname = user!.displayName!
        webSocketConnect()
        receive()
        
        let userEmail = Auth.auth().currentUser?.email
        let docRef = db.collection(userEmail!).document(String(streamerid!))
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let messageObject = document.data(with: ServerTimestampBehavior.none)
                self.followPic.isHidden = .init(messageObject!["isHidden"]! as! String)!
                print(messageObject!["isHidden"]!)
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    //    @objc func runAction(){
    //        if runLabel.frame.maxX > 0{
    //        runLabel.frame.origin.x -= 5
    //        }else{
    //            runLabel.frame.origin.x = 414
    //        }
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObserver()
        gradientLayer()
        
        player?.play()
        print("開始播放")
        player?.actionAtItemEnd = .none
        //加入觀察器當播放完畢再重新播放一次
        NotificationCenter.default.addObserver(self,selector: #selector(playerItemDidReachEnd(notification:)),name: .AVPlayerItemDidPlayToEndTime,object:player?.currentItem)
        
        
        guard Auth.auth().currentUser != nil else {
            nickname = NSLocalizedString("visitor", comment: "")
            return
        }
        user = Auth.auth().currentUser
        nickname = user?.displayName ?? ""
        
        
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            print("重新播放")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layer!.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        webSocketDisConnect()
        //移除player和avplayerlayer避免記憶體持續增加
        if self.player != nil{
            self.player!.pause()
            self.player = nil
            print("影片停止播放")
        }
        if self.layer != nil{
            layer?.removeFromSuperlayer()
            layer = nil
        }
        //移除player監聽器
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @IBAction func rightForHide(_ sender: UISwipeGestureRecognizer) {
        moveView.isHidden = true
    }
    
    @IBAction func leftForShow(_ sender: UISwipeGestureRecognizer) {
        moveView.isHidden = false
    }
    
    @IBAction func didEndOnExit(_ sender: UITextField) {
    }
    
    @IBAction func share(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        vc.hostPic = hostpic
        vc.hostName = hostname
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func tapToInfo(_ sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        vc.runDelegate = self
        vc.hostpic = hostpic
        vc.hostbg = hostbg
        vc.hostname = hostname
        vc.hosttitle = hosttitle
        vc.streamerid = streamerid
        vc.hostpicURL = hostpicURL
        vc.hostbgURL = hostbgURL
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    @IBAction func giftItemBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GiftViewController") as! GiftViewController
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    @IBAction func exitBtn(_ sender: UIButton) {
        alertView.isHidden = false
    }
    
    @IBAction func leaveBtn(_ sender: UIButton) {
        alertView.isHidden = true
        animationView = AnimateViewModel().makeAnimationView(initName: "brokenheart", speed: 2)
        view.addSubview(animationView!)
        AnimateViewModel().playAnimation(animationView: animationView!)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
            AnimateViewModel().stopAnimation(animationView: animationView!)
            animationView?.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func stayBtn(_ sender: UIButton) {
        alertView.isHidden = true
        animationView = AnimateViewModel().makeAnimationView(initName: "brokenheart", speed: 2)
        view.addSubview(animationView!)
        AnimateViewModel().playAnimationReverse(animationView: animationView!)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
            AnimateViewModel().stopAnimation(animationView: animationView!)
            animationView?.removeFromSuperview()
        }
    }
    
    
    @IBAction func sendMessageBtn(_ sender: UIButton) {
        guard messageTF.text != "" else {
            self.view.endEditing(true)
            alertview(title: NSLocalizedString("title", comment: ""), message: NSLocalizedString("message", comment: ""))
            return
        }
        
        //        guard messageTF.text!.count <= 200 else {
        //            self.view.endEditing(true)
        //            alertview(title: "字數太多", message: "請勿洗版")
        //            return
        //        }
        
        //        let punctuation = " ~!#$%^&*()_-+=?<>.—，。/\\|《》？;:：'‘；“,"
        //            for i in punctuation {
        //                    if self.messageTF.text?.contains(i) == true {
        //                        return
        //                    }
        //                }
        sendMessage()
        messageTF.text = ""
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiveResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        gradientLayer()
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.contentView.transform = CGAffineTransform(rotationAngle: .pi)
        let index = receiveResult.count - 1 - indexPath.row
        let resultArray = receiveResult[index]
        cell.messageTV.text = resultArray
        
        return cell
    }
    
    //滑動時也要繪製圖層，不然會破圖
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        gradientLayer()
    }
    
    func gradientLayer(){
        //加入對話框漸層遮罩
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.tableView.bounds
        gradientLayer.frame.size.height = self.tableView.bounds.height
        gradientLayer.colors = [UIColor.clear.withAlphaComponent(1.0).cgColor,UIColor.clear.withAlphaComponent(0.0).cgColor]
        gradientLayer.locations = [0.7, 1.0]
        tableView.layer.mask = gradientLayer
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,with: event)
        self.view.endEditing(true)
    }
    
    
}

// MARK: - keyboard監聽
extension LiveRoomViewController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            //判斷鍵盤高度是否大於changeHight的constrain
            if keyboardHeight > changeHight.constant+35 {
                print("移動前\(changeHight.constant)")
                changeHight.constant += (keyboardHeight-35)
                print("移動後\(changeHight.constant)")
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        changeHight.constant = 0
        print("返回0")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func alertview(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK: WebSocket
extension LiveRoomViewController: URLSessionWebSocketDelegate {
    
    private func webSocketConnect(){
        //nickname是中文的話不符合url協議，需要先編碼，否則會連不到伺服器
        let url1 = "wss://client-dev.lottcube.asia/ws/chat/chat:app_test?nickname=\(nickname)"
        let url2 = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print("轉碼後2：\(url2!)")
        
        guard let url = URL(string: "\(url2!)") else {
            print("Error: can not create URL")
            return
        }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        let request = URLRequest(url: url)
        webSocketTask = urlSession.webSocketTask(with: request)
        webSocketTask!.resume()
        print("開始連線")
    }
    
    private func sendMessage(){
        
        let message = URLSessionWebSocketTask.Message.string("{\"action\": \"N\",\"content\": \"\(messageTF.text!)\"}")
        webSocketTask?.send(message) { error in
            print(message)
            if let error = error {
                print(error)
            }
        }
    }
    
    private func sendMessage(sendmessage:String){
        let message = URLSessionWebSocketTask.Message.string("{\"action\": \"N\",\"content\": \"\(sendmessage)\"}")
        webSocketTask?.send(message) { error in
            print(message)
            if let error = error {
                print(error)
            }
        }
    }
    
    private func receive() {
        
        webSocketTask?.receive { [self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("收到的 string: \(text)")
                    
                    
                    let jsonString = """
                            \(text)
                            """
                    print(jsonString)
                    
                    //將JSON字串轉換成Data
                    if let jsonData = jsonString.data(using: .utf8) {
                        do {
                            let jsonDecoder = JSONDecoder()
                            let myJSONModel = try jsonDecoder.decode(DataStruct.MyJSONModel.self, from: jsonData)
                            //判斷事件
                            if myJSONModel.event == "undefined"{
                            }
                            if myJSONModel.event == "default_message"{
                                self.receiveResult.append("\(myJSONModel.body!.nickname!):\(myJSONModel.body!.text!)")
                            }
                            if myJSONModel.event == "sys_updateRoomStatus"{
                                if myJSONModel.body!.entry_notice!.action! == "enter"{
                                    self.receiveResult.append("\(myJSONModel.body!.entry_notice!.username!):\(NSLocalizedString("into-room", comment: ""))")
                                    self.realCount.text = ("\(NSLocalizedString("real-count", comment: ""))\(String(describing: myJSONModel.body!.real_count!))")
                                }else{
                                    self.receiveResult.append("\(myJSONModel.body!.entry_notice!.username!):\(NSLocalizedString("leave-room", comment: ""))")
                                    self.realCount.text = ("\(NSLocalizedString("real-count", comment: ""))\(String(describing: myJSONModel.body!.real_count!))")
                                }
                            }
                            if myJSONModel.event == "admin_all_broadcast"{
                                self.receiveResult.append(myJSONModel.body!.content!.tw!)
                                self.runLabel.text = myJSONModel.body!.content!.tw!
                                if self.runLabel.frame.maxX == 0{
                                    self.runLabel.frame.origin.x = 414
                                    UIView.animate(withDuration: 10) {
                                        self.runLabel.frame.origin.x = -414
                                    }
                                }else{
                                    UIView.animate(withDuration: 10) {
                                        self.runLabel.frame.origin.x = -414
                                    }
                                }
                            }
                            if myJSONModel.event == "sys_room_endStream"{
                                self.receiveResult.append(myJSONModel.body!.text!)
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }
            case .failure(let error):
                print(error)
                return
            }
            self.tableView.reloadData()
            print("開始接收資料")
            //有新留言時捲到底部
            //            if self.receiveResult.count > 0 {
            //                self.tableView.scrollToRow(at: IndexPath(row: self.receiveResult.count - 1, section: 0), at: .bottom, animated: true)
            //            }
            
            self.receive()
        }
    }
    
    private func webSocketDisConnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("斷開連線")
    }
    
    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didOpenWithProtocol protocol: String?) {
        print("URLSessionWebSocketTask 連線")
    }
    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                           reason: Data?) {
        let reasonString: String
        if let reason = reason, let string = String(data: reason, encoding: .utf8) {
            reasonString = string
        } else {
            reasonString = ""
        }
        print("URLSessionWebSocketTask 關閉: code=\(closeCode), reason=\(reasonString)")
    }
}

//extension LiveRoomViewController: YTPlayerViewDelegate {
//
//    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
//        if state == .ended {
//            videoPlayerView.playVideo()
//        }
//    }
//
//
//    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
//        self.videoPlayerView.playVideo()
//    }
//
//    func fetchChanelInfo(){
//
//        let strUrl = "https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics&id=\(CommonData().channelID)&key=\(CommonData().ApiKeys)"
//
//        if let url = URL(string: strUrl){
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data{
//                    let decoder = JSONDecoder()
//                    do {
//                        let searchResponse = try decoder.decode(ChannelResponse.self, from: data)
//
//                        self.channelInfo = searchResponse.items![0]
//                        //                        print(searchResponse.items![0])
//
//                    }
//                    catch  {
//                        print("channel response is invalid\(error)")
//                    }
//                }
//            }.resume()
//
//
//        }
//
//    }
//
//
//    func fetchPlayListInfo(){
//        //  guard let uploadID = g_CommomData?.uploadID else { print("no uploadId"); return  }
//        //        guard let uploadID = uploadId else { print("no uploadId"); return  }
//
//        let strUrl =
//        "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&maxResults=\(CommonData().maxResult)&playlistId=\(CommonData().playlistID)&key=\(CommonData().ApiKeys)"
//
//
//
//        if let url = URL(string: strUrl){
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data{
//                    let decoder = JSONDecoder()
//                    do {
//                        let searchResponse = try decoder.decode(PlayListResponse.self, from: data)
//                        self.videoResult = searchResponse.items
//                    } catch  {
//                        print("playlist response is invalid\(error)")
//                    }
//
//                }
//            }.resume()
//        }
//    }
//}

extension LiveRoomViewController: LabelDelegate {
    
    
    
    func runlabel(message: String) {
        
        runLabel2.text = message
        if self.runLabel2.frame.minX == -414{
            self.runLabel2.frame.origin.x = 414
            UIView.animate(withDuration: 5) {
                self.runLabel2.frame.origin.x = -414
            }
        }else{
            UIView.animate(withDuration: 5) {
                self.runLabel2.frame.origin.x = -414
            }
        }
        followPic.isHidden = false
        sendMessage(sendmessage: "追蹤了主播！！")
    }
    
    func cancelFollow(message: String) {
        runLabel2.text = message
        if self.runLabel2.frame.minX == -414{
            self.runLabel2.frame.origin.x = 414
            UIView.animate(withDuration: 5) {
                self.runLabel2.frame.origin.x = -414
            }
        }else{
            UIView.animate(withDuration: 5) {
                self.runLabel2.frame.origin.x = -414
            }
        }
        followPic.isHidden = true
        sendMessage(sendmessage: "取消追蹤主播！！")
    }
    
}
