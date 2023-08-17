//
//  myAdoptionViewController.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/18.
//

import UIKit
import Alamofire


class myAdoptionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var myAdoptionCollectionView: UICollectionView!
    
    // 사용자 정보를 저장할 변수
    var userInfo: UserInfo?
    var adoptions: [Adoption] = [] // 사용자 정보에서 가져올 입양 정보 배열
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "금지옥엽 서비스"
        navigationController?.navigationBar.tintColor = UIColor.black

        //userInfoLabel.text = ("\(userInfo!.name) #\(userInfo!.user_id)님의")

        myAdoptionCollectionView.delegate = self
        myAdoptionCollectionView.dataSource = self

        if let userInfo = userInfo {
            adoptions = userInfo.adoptions
            myAdoptionCollectionView.reloadData()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // 세로 스크롤 방향으로 설정
                
        myAdoptionCollectionView.collectionViewLayout = layout
    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         
         // 컬렉션 뷰 가로 크기 설정
         if let flowLayout = myAdoptionCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
             flowLayout.itemSize = CGSize(width: myAdoptionCollectionView.bounds.width - 48, height: 128)
         }
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adoptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myAdoptionCell", for: indexPath) as! myAdoptionCell
                
        let adoption = adoptions[indexPath.item] // 해당 인덱스의 입양 정보 가져오기
        cell.nameLabel.text = adoption.name // 이름 설정
        print(adoption.name)
        cell.infoLabel.text = ("\(adoption.gender) / \(adoption.age)세")
        cell.introductionLabel.text = "\"\(adoption.introduction)\""

        // "T" 앞까지만 사용하기
        if let tIndex = adoption.created_at.firstIndex(of: "T") {
            let dateSubstring = adoption.created_at.prefix(upTo: tIndex)
            cell.dateLabel.text = String(dateSubstring)
        } else {
            cell.dateLabel.text = adoption.created_at
        }
        
        // 이미지 설정 (이미지 경로가 문자열로 오는 경우 처리 필요)
        print(adoption.photo)
        let baseURL = "http://175.45.194.93"
        if let imageUrl = URL(string: baseURL + adoption.photo) {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAdoption = adoptions[indexPath.item] // 선택한 셀의 입양 정보 가져오기
        
        let storyboard = UIStoryboard(name: "myPageStoryboard", bundle: nil) // Main 스토리보드로 전환
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "detailMyAdoptionViewController") as? detailMyAdoptionViewController {
            detailVC.adoption = selectedAdoption // 선택한 입양 정보를 전달
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }


}

class myAdoptionCell: UICollectionViewCell{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
