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
    
    var postID: Int?
    var editable: Bool?
    var userID: String?
    var date: String?
    var content: String?
    var likes: Int?
    var beforetitle: String?
    var image: UIImage?
    var phoneumber: String?
    var isLike: Bool?
    
    var clickRecommend = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor(hex: 0xFFA24B)
        if let postID = postID {
                    print(postID)
        }
        userLabel.text = userID
        titleLabel.text = beforetitle
        contentLabel.text = content
        contentLabel.numberOfLines = 0
        contentLabel.sizeToFit()
        recommendLabel.text = "\(likes!)"
        imageView.image = image
        dateLabel.text = date
        
        if isLike == true {
            if let newImage = UIImage(systemName: "hand.thumbsup.fill") {
                recommendBtn.setImage(newImage, for: .normal)
                recommendBtn.tintColor = UIColor.lightGray
            }
        } else{
            if let newImage = UIImage(systemName: "hand.thumbsup") {
                recommendBtn.setImage(newImage, for: .normal)
                recommendBtn.tintColor = UIColor.lightGray
            }
        }
    }
    @IBAction func deleteBtn(_ sender: UIButton) {
        let deleteURL = "http://175.45.194.93/today/\(postID!)/"
        AF.request(deleteURL, method: .delete).responseData { response in
            switch response.result {
            case .success(let value):
                print("Delete success: \(value)")
                self.showDeleteModificationAlert()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print("Delete failure: \(error)")
            }
        }
    }

    func showDeleteModificationAlert() {
            let alert = UIAlertController(title: nil, message: "삭제되었습니다.", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    
    @IBAction func modifyBtn(_ sender: UIButton) {
        if let postID = self.postID,
           let postImage = self.image,
           let postTitle = self.beforetitle,
           let postContent = self.content {
            
            let storyboard = UIStoryboard(name: "todayStoryboard", bundle: nil)
            if let nextVC = storyboard.instantiateViewController(withIdentifier: "ModifyViewController") as? ModifyViewController {
                nextVC.postID = postID
                nextVC.image = postImage
                nextVC.beforetitle = postTitle
                nextVC.content = postContent
                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }

    @IBAction func recommendBtn(_ sender: UIButton) {
        let likeURL = "http://175.45.194.93/today/\(postID!)/like/"
        
        AF.request(likeURL, method: .patch).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Like success: \(value)")
                // 서버 응답을 처리하는 코드 추가
            case .failure(let error):
                print("Like failure: \(error)")
            }
        }
        
        func updateData() {
            AF.request("http://175.45.194.93/today/\(postID!)/").responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let jsonArray = value as? [[String: Any]] {
                        var newPosts: [(image: UIImage, title: String, date: String, content: String, userID: String, postID: Int, likes: Int, editable: Bool,isLike: Bool)] = []
                        
                        for json in jsonArray {
                            if let imagesArray = json["images"] as? [[String: Any]],
                               let imageUrlString = imagesArray.first?["image"] as? String,
                               let imageUrl = URL(string: imageUrlString)
                            {
                                AF.request(imageUrl).responseData { [self] response in
                                    if let imageData = response.data,
                                        let image = UIImage(data: imageData)
                                    {
                                  
                                        let postID = json["id"] as? Int ?? 0
                                        let likes = json["likes"] as? Int ?? 0
                                        let isLike = json["isLike"] as? Bool ?? false
                                        self.isLike = isLike
                                        print(self.isLike)
                                        
                                    }
                                    recommendLabel.text = "\(self.likes!)"
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        
        if self.isLike == true {
            if let newImage = UIImage(systemName: "hand.thumbsup.fill") {
                recommendBtn.setImage(newImage, for: .normal)
                recommendBtn.tintColor = UIColor.lightGray
            }
        } else{
            if let newImage = UIImage(systemName: "hand.thumbsup") {
                recommendBtn.setImage(newImage, for: .normal)
                recommendBtn.tintColor = UIColor.lightGray
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // 뷰가 사라질 때 데이터 업데이트
            updateTodayData()
        }
        
        func updateTodayData() {
           
            if let todayVC = navigationController?.viewControllers.first(where: { $0 is ManageViewController }) as? ManageViewController {
                todayVC.updateData()
            }
        }

    
}
