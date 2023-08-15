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
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var recommendBtn: UIButton!
    
    var postID: String?
    var editable: Bool?
    
    var clickRecommend = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let postID = postID {
                    print(postID)
        }
        
//        AF.request("http://175.45.194.93/today/\(postID)").responseJSON { response in
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
//                                          let postID = json["id"] as? String,
        //                                    let likes = json["likes"] as? Int,
        //                                    let editable = json["editable"] as? Bool,
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
//                                             self.postID = postID
//                                             self.likes = "\(likes)"
//                                             self.editable = editable
                                                
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
        
//        recommendLabel.text = likes
    }
    @IBAction func deleteBtn(_ sender: UIButton) {
        let deleteURL = "http://175.45.194.93/\(postID)/"
        AF.request(deleteURL, method: .delete).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Delete success: \(value)")
                // 서버 응답을 처리하는 코드 추가
            case .failure(let error):
                print("Delete failure: \(error)")
            }
        }
    }
    
    @IBAction func modifyBtn(_ sender: UIButton) {
    }

    @IBAction func recommendBtn(_ sender: UIButton) {
        clickRecommend += 1
        if clickRecommend % 2 == 0 {
            // 이미지 뷰 클릭 시 실행될 코드
            if let newImage = UIImage(systemName: "hand.thumbsup.fill") {
                sender.setImage(newImage, for: .normal)
            }
        } else {
            if let newImage = UIImage(systemName: "hand.thumbsup") {
                sender.setImage(newImage, for: .normal)
            }
        }
        let likeURL = "http://175.45.194.93/\(postID)/like/"
        
        AF.request(likeURL, method: .patch).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Like success: \(value)")
                // 서버 응답을 처리하는 코드 추가
            case .failure(let error):
                print("Like failure: \(error)")
            }
        }
    }

    
}
