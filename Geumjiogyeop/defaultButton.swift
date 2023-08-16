//
//  defaultButton.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/14.
//

import UIKit

class defaultButton: UIButton {
    
    override func awakeFromNib() {
            super.awakeFromNib()
            configureButton()
        }
        
        private func configureButton() {
            layer.cornerRadius = 5
           
        }

}
