//
//  CollectionViewCell.swift
//  VangoodLive
//
//  Created by Stan on 2022/3/28.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var head_photo: UIImageView!
    @IBOutlet weak var online_num: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var stream_title: UILabel!
    
    var fullScreenSize :CGSize!
    
    override func awakeFromNib() {
        
        fullScreenSize = UIScreen.main.bounds.size
        contentView.layer.cornerRadius = (fullScreenSize.width)/15
        
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        gradientLayer.frame.size.height = contentView.bounds.height/4
        gradientLayer.frame.origin.y = contentView.frame.maxY/1.3
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor,
                                UIColor.black.withAlphaComponent(0.5).cgColor]
        view.layer.addSublayer(gradientLayer)
        contentView.addSubview(view)
        
    }
    
}
