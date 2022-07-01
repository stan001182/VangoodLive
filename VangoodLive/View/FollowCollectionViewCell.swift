//
//  FollowCollectionViewCell.swift
//  VangoodLive
//
//  Created by Stan_Tseng on 2022/5/5.
//

import UIKit

class FollowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hostPic: UIImageView!
    
    override func awakeFromNib() {
        hostPic.clipsToBounds = true
        hostPic.layer.cornerRadius = self.contentView.frame.height/2
    }
}
