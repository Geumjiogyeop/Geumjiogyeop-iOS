//
//  myPageViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/09.
//

import UIKit
import Alamofire
import SwiftyJSON

// 유저 정보 모델
struct UserInfo: Codable {
    let user_id: Int
    let name: String
    let adoptions: [Adoption]
    let adoptions_count: Int?
}

struct Adoption: Codable {
    let adoption_id: Int
    let name: String
    let breed: Bool
    let gender: String
    let age: Int
    let weight: Int
    let is_neutralized: Int
    let center: String
    let introduction: String
    let letter: String
    let photo: String
    let likes: Int
    let contact_num: Int
    let adoption_availability: Bool
    let created_at: String
    let user: Int
}

class myPageViewController: UIViewController {
    
    
    
    @IBOutlet weak var userInfoButton: UIButton!
    @IBOutlet weak var serviceInfoView: UIView!
    @IBOutlet weak var serviceInfoLabel: UILabel!
    
    var userInfo: UserInfo?  // 유저 정보를 저장하는 변수
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10  //행간
        paragraphStyle.alignment = .center // 텍스트 정렬
        let attributedText = NSAttributedString(string: "만 50세 이상, 1인 가구 이신가요?\n갑작스러운 사고를 대비해 반려동물 등록해두세요", attributes: [.paragraphStyle: paragraphStyle])
        
        // Attributed text 설정
        serviceInfoLabel.attributedText = attributedText
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(serviceInfoViewTapped))
        serviceInfoView.addGestureRecognizer(tapGesture)
        
        getUserInfo()
    }
    
    @objc func serviceInfoViewTapped() {
        let storyboard = UIStoryboard(name: "myPageStoryboard", bundle: nil)
           
        if let adoptions_count = userInfo?.adoptions_count {
            if adoptions_count > 0 {
                // myListViewController로 이동
                if let myListViewController = storyboard.instantiateViewController(withIdentifier: "myListViewController") as? myListViewController {
                    myListViewController.userInfo = userInfo  // 유저 정보 전달
                    navigationController?.pushViewController(myListViewController, animated: true)
                }
            } else {
                // serviceInfoView로 이동
                if let nextViewController = storyboard.instantiateViewController(withIdentifier: "serviceInfoView") as? serviceInfoViewController {
                    navigationController?.pushViewController(nextViewController, animated: true)
                }
            }
        }
    }

    
    // GET 요청을 보내고 응답을 처리하는 함수
    func getUserInfo() {
        let url = "http://175.45.194.93/user/my"
        
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    if let detail = value as? String, detail == "UnAuthenticated!" {
                        // 로그인이 안된 경우 처리
                        self.userInfoButton.setTitle("로그인을 해주세요", for: .normal)
                    } else {
                        // 로그인이 된 경우 처리
                        let decoder = JSONDecoder()
                        let jsonData = try JSONSerialization.data(withJSONObject: value)
                        let userInfo = try decoder.decode(UserInfo.self, from: jsonData)
                        self.userInfo = userInfo  // userInfo 변수에 값을 설정
                        self.updateUserInfoLabel(with: userInfo)
                        self.updateServiceInfoLabel(with: userInfo)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("API Failure: \(error)")
            }
        }
    }

    // 유저 정보에 따라 userInfoLabel을 업데이트하는 함수
    func updateUserInfoLabel(with userInfo: UserInfo) {
        let user_id = userInfo.user_id
        let name = userInfo.name
        userInfoButton.setTitle("\(name) #\(user_id)님", for: .normal)
        userInfoButton.setImage(nil, for: .normal) // 이미지 제거
        print(user_id, name)
    }

    func updateServiceInfoLabel(with userInfo: UserInfo) {
               if let adoptions_count = userInfo.adoptions_count {
                   if adoptions_count > 0 {
                       // 내가 올린 입양공고 보러가기
                       serviceInfoLabel.text = "내가 올린 \(adoptions_count)개의 입양공고 보러가기"
                   } else {
                       // 만 50세 이상, 1인 가구 이신가요?
                       let paragraphStyle = NSMutableParagraphStyle()
                       paragraphStyle.lineSpacing = 10
                       paragraphStyle.alignment = .center
                       let attributedText = NSAttributedString(string: "만 50세 이상, 1인 가구 이신가요?\n갑작스러운 사고를 대비해 반려동물 등록해두세요", attributes: [.paragraphStyle: paragraphStyle])
                       serviceInfoLabel.attributedText = attributedText
                   }
               }
           }

}
