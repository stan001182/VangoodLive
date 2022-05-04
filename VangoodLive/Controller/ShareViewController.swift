//
//  shareViewController.swift
//  
//
//  Created by Stan_Tseng on 2022/4/28.
//

import UIKit

class ShareViewController: UIViewController {

    var hostPic : UIImage?
    var hostName : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareToLine(_ sender: UIButton) {
        let application = UIApplication.shared
        let url = URL(string: "https://line.me/R/msg/text/?https://www.youtube.com")!
        if application.canOpenURL(url){
            application.open(url, options: [:], completionHandler: nil)
        }else{
            let lineURL = URL(string: "https://line.me/R/")!
            application.open(lineURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func share(_ sender: UIButton) {
        let hostPic = hostPic ?? UIImage(named: "paopao")
        let info = "\(hostName ?? "主播")正在直播快來看看吧!"
        let shareURL = URL(string: "https://www.youtube.com")!
        let item: [Any] = [hostPic!,info,shareURL]
        let shareController = UIActivityViewController(activityItems: item, applicationActivities: nil)
        present(shareController, animated: true)
    }
    
    @IBAction func tapToDissmiss(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
}
