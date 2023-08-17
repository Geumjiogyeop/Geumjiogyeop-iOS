//
//  InterestViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/17.
//

import UIKit
import Alamofire
import SwiftyJSON

class Post {
    let name: String
    let gender: String
    let age: String
    let location: String
    let comment: String
    let imageName: String

    init(name: String, gender: String, age: String, location: String, comment: String, imageName: String) {
        self.name = name
        self.gender = gender
        self.age = age
        self.location = location
        self.comment = comment
        self.imageName = imageName
    }
}

    class LikeCell: UICollectionViewCell {
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var genderLabel: UILabel!
        @IBOutlet weak var ageLabel: UILabel!
        @IBOutlet weak var locationLabel: UILabel!
        @IBOutlet weak var commentLabel: UILabel!
        @IBOutlet weak var mainImage: UIImageView!
    }



    class InterestViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        @IBOutlet weak var collectionView: UICollectionView!
        
        var posts: [Post] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Call the AF.request inside the viewDidLoad method
            AF.request("http://175.45.194.93/today").responseJSON { response in
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
                                        let name = json["name"] as? String ?? "Unknown Name"
                                        let gender = json["gender"] as? String ?? "Unknown Gender"
                                        let age = json["age"] as? String ?? "Unknown Age"
                                        let location = json["location"] as? String ?? "Unknown Location"
                                        let comment = json["comment"] as? String ?? "No Comment"
                                        
                                        let post = Post(name: name, gender: gender, age: age, location: location, comment: comment, imageName: "image")  // Replace "image" with the actual image name
                                        self.posts.append(post)
                                        self.collectionView.reloadData() // Reload data inside the closure
                                    }
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            
            // collectionView3 설정
            collectionView.dataSource = self
            collectionView.delegate = self
            let layout3 = UICollectionViewFlowLayout()
            layout3.scrollDirection = .horizontal
            collectionView.collectionViewLayout = layout3
            collectionView.register(LikeCell.self, forCellWithReuseIdentifier: "LikeCell")  // Register the correct cell class
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return posts.count  // Replace with the number of items you want to display
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCell", for: indexPath) as! LikeCell

            let post = posts[indexPath.item]
           // cell.mainImage?.image = post.image
            cell.nameLabel.text = "Name: " + post.name
            cell.genderLabel.text = "Gender: " + post.gender
            cell.ageLabel.text = "Age: " + post.age
            cell.locationLabel.text = "Location: " + post.location
            cell.commentLabel.text = post.comment

            return cell
        }
    }

