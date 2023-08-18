//
//  MainViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/17.
//


import UIKit
import Alamofire
import SwiftyJSON

class ReviewCell: UICollectionViewCell {

}

class adoptionListCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    

}

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    
    var adoptions: [AllAdoption] = [] // 서버에서 가져온 입양 정보를 저장할 배열 //ㅇㅇ
    
    let images: [String] = ["main1", "main2"]
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var adoptionButton: UIButton!
    
    @IBOutlet weak var todayButton: UIButton!
    
    var posts: [(image: UIImage, title: String, date: String, content: String, userID: String, postID: Int, likes: Int, editable: Bool)] = []
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 컬렉션 뷰 가로 크기 설정
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: collectionView.bounds.width - 48, height: 150)
        }
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
                                    let post = (image: image, title: title, date: date, content: content, userID: userID, postID: postID, likes: likes, editable: editable)
                                    self.posts.append(post)
                                    self.collectionView.reloadData()
                                    self.collectionView2.reloadData() // Reload the collectionView2 as well
                                    self.collectionView3.reloadData() // Reload the collectionView3 as well
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
    
        // Set the image for the button
               if let image = UIImage(named: "report_btn") {
                   imageButton.setImage(image, for: .normal)
               }
               
               // Set the size of the image button
               let buttonWidth: CGFloat = 50
               let buttonHeight: CGFloat = 50
               imageButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
               
               // Add a target for the button
               imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView2.dataSource = self
        collectionView2.delegate = self
        
        // collectionView3 설정
                collectionView3.dataSource = self
                collectionView3.delegate = self
                let layout3 = UICollectionViewFlowLayout()
                layout3.scrollDirection = .horizontal
                collectionView3.collectionViewLayout = layout3
                collectionView3.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell3")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView2.register(ReviewCell.self, forCellWithReuseIdentifier: "ReviewCell")
                
        
        // Set the color of the scroll indicator
        collectionView.indicatorStyle = .default
        
        // Set the scroll indicator color
        if let scrollView = collectionView.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            scrollView.indicatorStyle = .default
            
            // Remove the default UIActivityIndicatorView
            scrollView.subviews.forEach { view in
                if view is UIActivityIndicatorView {
                    view.removeFromSuperview()
                }
            }
            
            // Add a custom UIActivityIndicatorView with the desired color
            let customActivityIndicator = UIActivityIndicatorView(style: .medium)
            customActivityIndicator.color = UIColor(hex: "#FF9635")
            customActivityIndicator.startAnimating()
            scrollView.addSubview(customActivityIndicator)
            
            // Set the frame and position of the custom UIActivityIndicatorView
            customActivityIndicator.frame.origin.x = (scrollView.bounds.width - customActivityIndicator.bounds.width) / 2
            customActivityIndicator.frame.origin.y = (scrollView.bounds.height - customActivityIndicator.bounds.height) / 2
        }
        
        // Adjust scroll indicator insets
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 100, bottom: collectionView.bounds.height / 20, right: 100)
    }
    
    @objc func imageButtonTapped() {
        // Handle button tap event
        let storyboard = UIStoryboard(name: "myPageStoryboard", bundle: nil)
        
        // WebKitViewController의 storyboardID를 가진 뷰 컨트롤러 인스턴스 생성
        if let webKitViewController = storyboard.instantiateViewController(withIdentifier: "webKitViewController") as? webKitViewController {
            self.present(webKitViewController, animated: true, completion: nil)
        }
        
        print("Image button tapped!")
    }
    
    @IBAction func adoptionButtonClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "adoptionStoryboard", bundle: nil)
        
        // WebKitViewController의 storyboardID를 가진 뷰 컨트롤러 인스턴스 생성
        if let adoptionViewController = storyboard.instantiateViewController(withIdentifier: "adoptionViewController") as? adoptionViewController {
            self.present(adoptionViewController, animated: true, completion: nil)
        }
        
        print("Image button tapped!")
    }
    
    @IBAction func todayButtonClick(_ sender: UIButton) {
        // Handle button tap event
        let storyboard = UIStoryboard(name: "todayStoryboard", bundle: nil)
        
        // WebKitViewController의 storyboardID를 가진 뷰 컨트롤러 인스턴스 생성
        if let todayViewController = storyboard.instantiateViewController(withIdentifier: "todayViewController") as? todayViewController {
            self.present(todayViewController, animated: true, completion: nil)
        }
        
        print("Image button tapped!")
    }
    

    
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView2 {
            guard let cell = collectionView2.dequeueReusableCell(withReuseIdentifier: "ReviewCell", for: indexPath) as? ReviewCell else {
                        return UICollectionViewCell()
                    }
            
            // Configure the ReviewCell here
            // For example:
            let dayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.contentView.bounds.width, height: 20))
            dayLabel.text = "도롱이는 잘 지냅니다~! \(indexPath.item + 1)"
            cell.contentView.addSubview(dayLabel)

            let reviewLabel = UILabel(frame: CGRect(x: 0, y: 25, width: cell.contentView.bounds.width, height: 20))
            reviewLabel.text = "2023.07.26 \(indexPath.item + 1)"
            cell.contentView.addSubview(reviewLabel)
            
            return cell
        }
        else if collectionView == collectionView3 {
            
            let cell = collectionView3.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath)

            // Clear the cell's content view before adding new subviews
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }

            // Example: You can set up UILabels and UIImageView here
            let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.contentView.bounds.width, height: 20))
            nameLabel.text = "Name \(indexPath.item + 1)"
            cell.contentView.addSubview(nameLabel)

            let genderLabel = UILabel(frame: CGRect(x: 0, y: 25, width: cell.contentView.bounds.width, height: 20))
            genderLabel.text = "Gender \(indexPath.item + 1)"
            cell.contentView.addSubview(genderLabel)

            // ... (Add other labels and image view)

            return cell
                }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adoptionListCell", for: indexPath) as! adoptionListCell
            
            let adoption = adoptions[indexPath.row]
            cell.nameLabel.text = adoption.name
            cell.introductionLabel.text = "\"\(adoption.introduction)\""
            
            let baseURL = "http://175.45.194.93"
            if let imageUrl = URL(string: adoption.photo) {
                        // 이미지를 비동기적으로 가져오기
                        AF.request(imageUrl).responseData { response in
                            switch response.result {
                            case .success(let imageData):
                                if let image = UIImage(data: imageData) {
                                    cell.imageView.image = image
                                } else {
                                    cell.imageView.image = nil
                                }
                            case .failure(let error):
                                print("Image loading error: \(error)")
                                cell.imageView.image = nil
                            }
                        }
                    } else {
                        cell.imageView.image = nil // 이미지 로딩 실패 시 기본 이미지 또는 빈 이미지 설정
                    }
            
            return cell
        }
    }
    // Customize cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    // This method is called when scrolling ends
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = collectionView.bounds.width
        let targetOffset = targetContentOffset.pointee.x
        let currentPage = targetOffset / pageWidth
        
        var nearestPage = round(currentPage)
        nearestPage = max(0, nearestPage) // Ensure the page is not negative
        nearestPage = min(CGFloat(images.count - 1), nearestPage) // Ensure the page is not beyond the last page
        
        targetContentOffset.pointee = CGPoint(x: nearestPage * pageWidth, y: targetContentOffset.pointee.y)
    }
}


// Extension to create UIColor from hex values
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


