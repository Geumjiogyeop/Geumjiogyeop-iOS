//
//  DetailViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/11.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentLabel.numberOfLines = 0
        contentLabel.sizeToFit()
    }

}
