//
//  ManageViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/14.
//

import UIKit
import Alamofire
import SwiftyJSON

class ManageCollectionView: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

class ManageViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var contentView: UIView!
    
    
    
    var clickRecommend = 1
    
//    var posts: [(image: UIImage,postID:String)] = [
//        (postID: "1",image: UIImage(named: "testImg")!),(postID: "2",image: UIImage(named: "testImg")!),(postID: "3",image: UIImage(named: "testImg")!),(postID: "4",image: UIImage(named: "testImg")!),(postID: "5",image: UIImage(named: "testImg")!),(postID: "6",image: UIImage(named: "testImg")!),(postID: "7",image: UIImage(named: "testImg")!),(postID: "8",image: UIImage(named: "testImg")!),(postID: "9",image: UIImage(named: "testImg")!),(postID: "10",image: UIImage(named: "testImg")!),(postID: "11",image: UIImage(named: "testImg")!),(postID: "12",image: UIImage(named: "testImg")!)
//    ]
    
    var posts: [(image: UIImage,postID:Int,userID: String,date: String, content: String, likes:Int, beforetitle: String)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        

        // Set up UICollectionViewFlowLayout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let itemWidth = collectionView.frame.width / 3
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth) // Square aspect ratio

        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        collectionView.collectionViewLayout = flowLayout
        
        AF.request("http://175.45.194.93/today/my").responseJSON { response in
            switch response.result {
            case .success(let value):
                if let jsonArray = value as? [[String: Any]] {
                    for json in jsonArray {
                        if let imagesArray = json["images"] as? [[String: Any]],
                           let imageUrlString = imagesArray.first?["image"] as? String,
                           let imageUrl = URL(string: imageUrlString)
                        {
                            AF.request(imageUrl).responseData { response in
                                if let imageData = response.data,
                                    let image = UIImage(data: imageData)
                                {
                                    let writer = json["writer"] as? [String: Any] ?? [:]
                                    let username = writer["name"] as? String ?? "Unknown"
                                    let userid = writer["user_id"] as? Int ?? 0
                                    let title = json["title"] as? String ?? "No Title"
                                    let date = json["created_at"] as? String ?? "Unknown Date"
                                    let content = json["content"] as? String ?? "No Content"
                                    let postID = json["id"] as? Int ?? 0
                                    let likes = json["likes"] as? Int ?? 0
                                    let editable = json["editable"] as? Bool ?? false
                                    
                                    let userID = username + "#\(userid)"
                                    self.posts.append((image: image, postID: postID,userID: userID,date: date, content: content, likes:likes,beforetitle: title))
                                    self.collectionView.reloadData()
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
//       AF.request("http://175.45.194.93/today/my").responseJSON { response in
//        switch response.result {
//        case .success(let value):
//            if let jsonArray = value as? [[String: Any]] {
//                for json in jsonArray {
//                    if let postId = json["id"] as? String,
//                       let imageUrlString = json["imageUrl"] as? String,
//                        let imagesArray = json["images"] as? [String] {
//
//        // Assume there is only one image URL in the imagesArray
//        if let imageUrlString = imagesArray.first,
//           let imageUrl = URL(string: imageUrlString) {
//
//            AF.request(imageUrl).responseData { response in
//                switch response.result {
//                case .success(let imageData):
//                    if let image = UIImage(data: imageData) {
//                        let userID = writer
//                        self.posts.append((image: image, postId: postId))
//                        self.collectionView.reloadData()
//                    }
//                case .failure(let error):
//                    print("Error downloading image: \(error)")
//                }
//            }
//        }
//    }
//}
//}
//case .failure(let error):
//print("Error: \(error)")
//}
//}

        
        
        let fixedBtn = UIButton()
        if let image = UIImage(named: "fixedBtn"){
            fixedBtn.setImage(image, for: .normal)
        }
        fixedBtn.translatesAutoresizingMaskIntoConstraints=false
        
        view.addSubview(fixedBtn)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            fixedBtn.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),
            fixedBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32),
            fixedBtn.widthAnchor.constraint(equalToConstant: 60),
            fixedBtn.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        fixedBtn.addTarget(self, action: #selector(fixedBtnTapped), for: .touchUpInside)
        
                
        
    }

        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return posts.count
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "manageCollectionView", for: indexPath) as? ManageCollectionView else {
            return UICollectionViewCell()
        }

        let post = posts[indexPath.item]

        // Set the image view's image
        cell.imageView.image = post.image

        // Set the content mode to scale the image within the imageView
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.clipsToBounds = true

        // Set the imageView's height constraint to match the width (since it's a square)
        cell.imageView.translatesAutoresizingMaskIntoConstraints = false
        cell.imageView.heightAnchor.constraint(equalToConstant: cell.frame.width).isActive = true

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.item]
        
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController {
            nextVC.postID = selectedPost.postID
            nextVC.userID = selectedPost.userID
            nextVC.date = selectedPost.date
            nextVC.content = selectedPost.content
            nextVC.likes = selectedPost.likes
            nextVC.beforetitle = selectedPost.beforetitle
            
            print(nextVC.postID)
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func fixedBtnTapped() {
        let storyboard = UIStoryboard(name: "todayStoryboard", bundle: nil)

        // WriteViewController의 storyboardID를 가진 뷰 컨트롤러 인스턴스 생성
        let writeViewController = storyboard.instantiateViewController(withIdentifier: "WriteViewController")
        self.navigationController?.pushViewController(writeViewController, animated: true)
    }
}
