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
    
    var detailUser: String!
    var detailImage: UIImage!
    var detailTitle: String!
    var detailContent: String!
    var detailDate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLabel.text=detailUser
        imageView.image=detailImage
        titleLabel.text=detailTitle
        contentLabel.text=detailContent
        dateLabel.text=detailDate
        
        print("detailViewController:"+(userLabel.text ?? "wewe"))
        // Do any additional setup after loading the view.
    }

}
