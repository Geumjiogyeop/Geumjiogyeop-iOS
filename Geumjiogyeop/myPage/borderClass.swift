//
//  borderClass.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/09.
//

import UIKit

class borderClass: UIView {

    override func awakeFromNib() {
           super.awakeFromNib()
           layer.cornerRadius = 15
           layer.masksToBounds = true
       }

}
