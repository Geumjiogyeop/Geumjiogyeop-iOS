//
//  RoundedImageView.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/18.
//

import UIKit

class RoundedImageView: UIImageView {
    
    override func awakeFromNib() {
           super.awakeFromNib()
           layer.cornerRadius = 15
           layer.masksToBounds = true
       }
}
