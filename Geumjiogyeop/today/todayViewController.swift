//
//  todayViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/03.
//

import UIKit

class todayCollectionView: UICollectionViewCell {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}

class todayViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var contentView: UIView!
    
    var posts: [(image: UIImage, title: String, date: String,content: String,userID:String)] = [
        (userID: "이서연#1111",image: UIImage(named: "logo")!, title: "첫 번째 게시물", date: "2023-08-03",content: "도롱이는 잘 적응하고 지내고 있습니다:) 저희 가족에 행운이ㅏ 찾아온 것 같아요 감사합니다"),
        (userID: "이자민#2222",image: UIImage(named: "logo")!, title: "두 번째 게시물", date: "2023-08-03",content: "도롱이는 잘 적응하고 지내고 있습니다:) 저희 가족에 행운이ㅏ 찾아온 것 같아요 감사합니다"),
        (userID: "이장혁#3333",image: UIImage(named: "logo")!, title: "세 번째 게시물", date: "2023-08-03",content: "도롱이는 잘 적응하고 지내고 있습니다:) 저희 가족에 행운이ㅏ 찾아온 것 같아요 감사합니다"),
        (userID: "김예란#4444",image: UIImage(named: "logo")!, title: "네 번째 게시물", date: "2023-08-03",content: "도롱이는 잘 적응하고 지내고 있습니다:) 저희 가족에 행운이ㅏ 찾아온 것 같아요 감사합니다"),
        (userID: "이자민#1234",image: UIImage(named: "logo")!, title: "첫 번째 게시물", date: "2023-08-03",content: "도롱이는 잘 적응하고 지내고 있습니다:) 저희 가족에 행운이ㅏ 찾아온 것 같아요 감사합니다"),
        (userID: "이자민#1234",image: UIImage(named: "logo")!, title: "첫 번째 게시물", date: "2023-08-03",content: "도롱이는 잘 적응하고 지내고 있습니다:) 저희 가족에 행운이ㅏ 찾아온 것 같아요 감사합니다")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        

        // Set up UICollectionViewFlowLayout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0 // 셀 사이의 수평 간격
        flowLayout.minimumLineSpacing = 0 // 셀 사이의 수직 간격
        flowLayout.itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height/3*2)

        collectionView.collectionViewLayout = flowLayout
        
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

            return cell
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.item]

        // 스토리보드에서 DetailViewController의 식별자를 설정하세요.
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.detailUser = selectedPost.userID
            detailVC.detailImage = selectedPost.image
            detailVC.detailTitle = selectedPost.title
            detailVC.detailContent = selectedPost.content
            detailVC.detailDate = selectedPost.date
            
            print(detailVC.detailUser)
            print("Selected Post: \(selectedPost)")
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
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
        let imageViewHeight: CGFloat = 100 // 이미지 뷰 높이
        
        // 모든 요소들의 높이를 더한 값을 cellHeight로 설정
        let cellHeight = labelHeight + titleLabelHeight + dateLabelHeight + userLabelHeight + imageViewHeight
        
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }




//        // Function to add new data
//        func addNewPost() {
//            // 새로운 데이터를 추가
//            let newPost = (image: UIImage(named: "new_post_image")!, title: "새로운 게시물", date: "2023-08-05")
//            posts.append(newPost)
//
//            // UICollectionView를 갱신하여 새로운 데이터를 반영
  
    //            collectionView.reloadData()
//        }
//
//        // Function to modify existing data
//        func modifyFirstPost() {
//            // 데이터 수정 예시: 첫 번째 게시물의 제목을 수정
//            if posts.count > 0 {
//                var modifiedPost = posts[0]
//                modifiedPost.title = "수정된 제목"
//                posts[0] = modifiedPost
//
//                // UICollectionView를 갱신하여 수정된 데이터를 반영
//                collectionView.reloadData()
//            }
//        }
    
    @objc func fixedBtnTapped() {
        let storyboard = UIStoryboard(name: "todayStoryboard", bundle: nil)

        // WriteViewController의 storyboardID를 가진 뷰 컨트롤러 인스턴스 생성
        let writeViewController = storyboard.instantiateViewController(withIdentifier: "WriteViewController")
        self.navigationController?.pushViewController(writeViewController, animated: true)
    }
}
