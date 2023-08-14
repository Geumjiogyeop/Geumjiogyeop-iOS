//
//  DetailViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/11.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailViewController: UIViewController {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var postId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let postId = postId {
                    print(postId)
        }
        
//        AF.request("http://175.45.194.93/today/\(postId)").responseJSON { response in
       //                    switch response.result {
       //                    case .success(let value):
       //                        if let jsonArray = value as? [[String: Any]] {
       //                            for json in jsonArray {
       //                                if let writer = json["writer"] as? [String: Any],
       //                                   let username = writer["username"] as? String,
       //                                   let userid = writer["id"] as? String,
       //                                   let title = json["title"] as? String,
       //                                   let date = json["created_at"] as? String,
       //                                   let content = json["content"] as? String,
//                                          let content = json["editable"] as? String,
       //                                   let imageUrlString = json["imageUrl"] as? String,
       //                                   let imageUrl = URL(string: imageUrlString),
       //                                   let imageData = try? Data(contentsOf: imageUrl),
       //                                   let image = UIImage(data: imageData)
       //                                     {
       //                                    let userID = username+userid
//                                           self.userLabel.text = userID
                                    //        self.imageView = image
                                    //        self.titleLabel = title
                                    //        self.contentLabel = content
                                    //        self.dateLabel = date
       //                                }
       //                            }
       //
       //                            // 데이터 가져오기 완료 후, collectionView를 리로드하거나 UI 업데이트
       //                            self.collectionView.reloadData()
       //                        }
       //                    case .failure(let error):
       //                        print("Error: \(error)")
       //                    }
       //                }
        
        contentLabel.numberOfLines = 0
        contentLabel.sizeToFit()
        
        
    }

    
}
