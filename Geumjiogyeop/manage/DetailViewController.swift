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
    
    var clickRecommend = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    @IBAction func deleteBtn(_ sender: UIButton) {
        let deleteURL = "http://175.45.194.93/\(postID)/"
        AF.request(deleteURL, method: .delete).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Delete success: \(value)")
                self.showDeleteModificationAlert()
                // 서버 응답을 처리하는 코드 추가
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
