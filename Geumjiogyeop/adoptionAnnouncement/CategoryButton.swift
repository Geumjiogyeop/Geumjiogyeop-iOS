//
//  CategoryButton.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/13.

import UIKit

@IBDesignable
class CategoryButton: UIButton {
    

    override func awakeFromNib() {
            super.awakeFromNib()
            configureButton()
        }
        
        private func configureButton() {
            layer.cornerRadius = 18
            layer.masksToBounds = true
            layer.borderWidth = 1
            layer.borderColor = UIColor.orange.cgColor
           
        }
}
