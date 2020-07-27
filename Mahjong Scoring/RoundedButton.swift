//
//  RoundedButton.swift
//  Mahjong Scoring
//
//  Created by 戚越 on 2018/12/7.
//  Copyright © 2018 Yue QI. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        layer.borderWidth = 1/UIScreen.main.nativeScale
//        contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        titleLabel?.adjustsFontForContentSizeCategory = true
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
//        layer.cornerRadius = 6
        layer.borderColor = isEnabled ? tintColor.cgColor : UIColor.lightGray.cgColor
    }
}
