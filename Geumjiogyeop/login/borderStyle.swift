//
//  borderStyle.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/03.
//

import UIKit

@IBDesignable
class CategoryButton: UIButton {
    

    override func awakeFromNib() {
            super.awakeFromNib()
            configureButton()
        }
        
        private func configureButton() {
            layer.cornerRadius = 5
            layer.masksToBounds = true
            layer.borderWidth = 1
            layer.borderColor = UIColor.orange.cgColor
           
        }
}

