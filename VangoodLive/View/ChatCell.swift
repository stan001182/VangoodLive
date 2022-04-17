//
//  ChatCell.swift
//  VangoodLive
//
//  Created by Class on 2022/4/10.
//

import UIKit

class ChatCell: UITableViewCell {
    
    
    @IBOutlet weak var messageTV: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        //        let selectedBackgroundView = UIView()
        //        selectedBackgroundView.backgroundColor = .clear
        //        self.selectedBackgroundView = selectedBackgroundView
        
        //        let gradientLayer = CAGradientLayer()
        //        gradientLayer.frame = self.contentView.bounds
        //        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor,
        //                                UIColor.black.cgColor]
        
        messageTV.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        let contentSize = messageTV.sizeThatFits(messageTV.bounds.size)
        var frame = messageTV.frame
        frame.size.height = contentSize.height
        messageTV.frame = frame
        print(contentSize.height)
        messageTV.layer.cornerRadius = 20
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
