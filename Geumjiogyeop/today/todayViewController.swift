//
//  todayViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/03.
//

import UIKit
import Alamofire
import SwiftyJSON

class todayCollectionView: UICollectionViewCell {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var recommendImgView: UIImageView!
    @IBOutlet weak var userIconStackView: UIStackView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var modifyBtn: UIButton!
}

class todayViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var contentView: UIView!
    
    
    
    
    var clickRecommend = 1
    
    var posts: [(image: UIImage, title: String, date: String,content: String,userID: String,postID: String,likes: Int,editable: Bool)] = [
        (userID: "이서연#1111",image: UIImage(named: "testImg")!, title: "첫 번째 게시물", date: "2023-08-03",content: "도롱이는 잘 적응하고 지내고 있습니다:) 저희 가족에 행운이ㅏ 찾아온 것 같아요 감사합니다",postID:"1",likes: 123,editable: true),
        (userID: "이자민#2222",image: UIImage(named: "logo")!, title: "두 번째 게시물", date: "2023-08-03",content: "도롱이는 잘 적응하고 지내고 있습니다:) 저희 가족에 행운이ㅏ 찾아온 것 같아요 감사합니다",postID:"1",likes: 123,editable: false),
        (userID: "이장혁#3333",image: UIImage(named: "logo")!, title: "세 번째 게시물", date: "2023-08-03",content: "도롱이는 잘 적응하고 지내고 있습니다:) 저희 가족에 행운이ㅏ 찾아온 것 같아요 감사합니다",postID:"3",likes: 123,editable: true),
        (userID: "김예란#4444",image: UIImage(named: "logo")!, title: "네 번째 게시물", date: "2023-08-03",content: "도롱이는 잘 적응하고 지내고 있습니다:) 저희 가족에 행운이ㅏ 찾아온 것 같아요 감사합니다",postID:"4",likes: 123,editable: true),
        (userID: "이자민#1234",image: UIImage(named: "logo")!, title: "첫 번째 게시물", date: "2023-08-03",content: "도롱이는 잘 적응하고 지내고 있습니다:) 저희 가족에 행운이ㅏ 찾아온 것 같아요 감사합니다",postID:"5",likes: 123,editable: true),
        (userID: "이자민#1234",image: UIImage(named: "logo")!, title: "첫 번째 게시물", date: "2023-08-03",content: "도롱이는 잘 적응하고 지내고 있습니다:) 저희 가족에 행운이ㅏ 찾아온 것 같아요 감사합니다",postID:"1",likes: 123,editable: true)
    ]
    
//    var posts: [(image: UIImage, title: String, date: String,content: String,userID:String)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        

        // Set up UICollectionViewFlowLayout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0 // 셀 사이의 수평 간격
        flowLayout.minimumLineSpacing = 0 // 셀 사이의 수직 간격
        flowLayout.itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)

        collectionView.collectionViewLayout = flowLayout
        
        
//        AF.request("http://175.45.194.93/today").responseJSON { response in
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
//                                     let postID = json["id"] as? String,
//                                    let likes = json["likes"] as? Int,
//                                    let editable = json["editable"] as? Bool,
//                                   let imageUrlString = json["imageUrl"] as? String,
//                                   let imageUrl = URL(string: imageUrlString),
//                                   let imageData = try? Data(contentsOf: imageUrl),
//                                   let image = UIImage(data: imageData)
//                                     {
//                                    let userID = username+userid
//                                    self.posts.append((image: image, title: title, date: date, content: content, userID: userID,postID: postID,likes: likes,editable: editable))
//
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCollectionView", for: indexPath) as? todayCollectionView else {
                return UICollectionViewCell()
            }

            let post = posts[indexPath.item]

            cell.userLabel.text = post.userID
            cell.imageView.image = post.image
            cell.titleLabel.text = post.title
            cell.titleLabel.numberOfLines = 0 // 여러 줄 텍스트 지원
            cell.titleLabel.adjustsFontSizeToFitWidth = true // 글자 크기 자동 조절
            cell.contentLabel.text = post.content
            cell.dateLabel.text = post.date
            
            cell.contentLabel.numberOfLines = 0
            cell.contentLabel.sizeToFit()
            
            // 지정된 indexPath를 저장하여 recommendImgViewTapped 함수에서 사용할 수 있도록 함
            cell.recommendImgView.tag = indexPath.item

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recommendImgViewTapped(_:)))
            cell.recommendImgView.isUserInteractionEnabled = true
            cell.recommendImgView.addGestureRecognizer(tapGesture)
            
            cell.recommendLabel.text = "\(post.likes)"
            
            let deleteTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteBtnViewTapped(_:)))
            cell.deleteBtn.addGestureRecognizer(deleteTapGesture)
            
            let modifyTapGesture = UITapGestureRecognizer(target: self, action: #selector(modifyBtnViewTapped(_:)))
            cell.modifyBtn.addGestureRecognizer(modifyTapGesture)
//            
            if post.editable == true{
                cell.userIconStackView.isHidden = false
            }else if post.editable == false{
                cell.userIconStackView.isHidden = true
            }
            
            

            return cell
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = posts[indexPath.item]
        
        // UILabel의 크기 계산
        let labelWidth = collectionView.frame.width - 16 // 여백 8씩
        let labelHeight = post.content.boundingRect(with: CGSize(width: labelWidth, height: .greatestFiniteMagnitude),
                                                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)],
                                                    context: nil).height
        
        // 다른 요소들의 높이
        let titleLabelHeight: CGFloat = 20
        let dateLabelHeight: CGFloat = 16
        let userLabelHeight: CGFloat = 16
        
        // 모든 요소들의 높이를 더한 값을 cellHeight로 설정
        let cellHeight = labelHeight + titleLabelHeight + dateLabelHeight + userLabelHeight
        
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    @objc func deleteBtnViewTapped(_ sender: UITapGestureRecognizer) {
        if let delete = sender.view as? UIButton {
            let location = sender.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: location) {
                if let clickedCell = collectionView.cellForItem(at: indexPath) as? todayCollectionView {
                    print("delete 선택")
                    let postID = posts[indexPath.item].postID
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
            }
        }
    }

    @objc func modifyBtnViewTapped(_ sender: UITapGestureRecognizer) {
        if let modify = sender.view as? UIButton {
            let location = sender.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: location) {
                if let clickedCell = collectionView.cellForItem(at: indexPath) as? todayCollectionView {
                    print("modify 선택")
                    let postID = posts[indexPath.item].postID
                    if let nextVC = storyboard?.instantiateViewController(withIdentifier: "ModifyViewController") as? ModifyViewController {
                        nextVC.postID = postID
                        navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
        }
    }
    @objc func recommendImgViewTapped(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            let location = sender.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: location) {
                if let clickedCell = collectionView.cellForItem(at: indexPath) as? todayCollectionView {
                    clickRecommend += 1
                    if clickRecommend % 2 == 0 {
                        // 이미지 뷰 클릭 시 실행될 코드
                        if let newImage = UIImage(systemName: "hand.thumbsup.fill") {
                            clickedCell.recommendImgView.image = newImage
                        }
                        let postID = posts[indexPath.item].postID
                        let likeURL = "http://175.45.194.93/\(postID)/like/"
                        AF.request(likeURL, method: .patch).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                print("Delete success: \(value)")
                                // 서버 응답을 처리하는 코드 추가
                            case .failure(let error):
                                print("Delete failure: \(error)")
                            }
                        }
                    } else {
                        if let newImage = UIImage(systemName: "hand.thumbsup") {
                            clickedCell.recommendImgView.image = newImage
                        }
                        let postID = posts[indexPath.item].postID
                        let likeURL = "http://175.45.194.93/\(postID)/like/"
                        AF.request(likeURL, method: .patch).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                print("Delete success: \(value)")
                                // 서버 응답을 처리하는 코드 추가
                            case .failure(let error):
                                print("Delete failure: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }

    
    @objc func fixedBtnTapped() {

        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as? writePostViewController {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
