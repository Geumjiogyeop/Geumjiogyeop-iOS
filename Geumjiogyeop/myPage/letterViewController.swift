//
//  letterViewController.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/17.
//

import UIKit
import Alamofire
import SwiftyJSON

class letterViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var introductionTextField: UITextField!
    @IBOutlet weak var letterTextView: borderTextView!
    
    @IBOutlet weak var submitButton: defaultButton!
    
    var name: String = ""
    var breed: Bool = false
    var gender: String = ""
    var age: Int = 0
    var weight: Int = 0
    var is_neutralized: Int = 0
    var center: String = "미정"
    var introduction: String = ""
    var letter: String = ""
    var photo: UIImage?
    var uploadImage: UIImage?  // 선택된 이미지를 저장할 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "편지쓰기"
        navigationController?.navigationBar.tintColor = UIColor.black
        print("name: \(name)")
        print("breed: \(breed)")
        print("gender: \(gender)")
        print("age: \(age)")
        print("weight: \(weight)")
        print("is_neutralized: \(is_neutralized)")
        print("center: \(center)")
        print("introduction: \(introduction)")
        print("letter: \(letter)")
        print("photo: \(photo)")
        // 텍스트 필드와 텍스트 뷰의 내용이 변경될 때마다 호출되는 메서드 등록
        introductionTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        letterTextView.delegate = self
        introductionTextField.delegate = self
    }
    // 텍스트 필드의 내용이 변경될 때 호출되는 메서드
        @objc func textFieldDidChange(_ textField: UITextField) {
            updateSubmitButtonState()
        }
        
        // 제출 버튼의 활성화 여부 업데이트 메서드
        func updateSubmitButtonState() {
            let isIntroductionFilled = !(introductionTextField.text?.isEmpty ?? true)
            let isLetterFilled = !(letterTextView.text.isEmpty)
            submitButton.isEnabled = isIntroductionFilled && isLetterFilled
            
            if submitButton.isEnabled {
                submitButton.backgroundColor = UIColor.orange
            } else {
                submitButton.backgroundColor = UIColor.systemGray5
            }
        }
        
    @IBAction func submitButtonTapped(_ sender: defaultButton) {
        introduction = (introductionTextField?.text)!
        letter = (letterTextView?.text)!
        sendPetDataToServer()
        // 이동할 뷰 컨트롤러 인스턴스 생성
        // 탭 바의 첫 번째 탭(myPageViewController)로 돌아가기
            if let tabBarController = self.tabBarController, let myPageViewController = tabBarController.viewControllers?[3] as? myPageViewController {
                tabBarController.selectedIndex = 3
                myPageViewController.getUserInfo() // 유저 정보 업데이트
            }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //API 요청
    func sendPetDataToServer() {
        let url = "http://175.45.194.93/adoption/create" // 적절한 API 엔드포인트로 변경

 //이미지 데이터를 JPEG로 변환
        if let imageData = photo?.jpegData(compressionQuality: 0.5) {
            let parameters: [String: Any] = [
                "name": name,
                "breed": breed,
                "gender": gender,
                "age": age,
                "weight": weight,
                "is_neutralized": is_neutralized,
                "center": center,
                "introduction": introduction,
                "letter": letter
            ]

            AF.upload(multipartFormData: { multipartFormData in
                // 텍스트 데이터 추가
                for (key, value) in parameters {
                    if let stringValue = value as? String {
                        multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                    }
                }
                // 이미지 데이터 추가
                multipartFormData.append(imageData, withName: "photo", fileName: "image.jpg", mimeType: "image/jpeg")
            }, to: url).response { response in
                switch response.result {
                case .success(let value):
                    print("API Success: \(value)")
                    // 성공 처리
                case .failure(let error):
                    print("API Failure: \(error)")
                    // 실패 처리
                }
            }
        } else {
            print("Failed to convert image to data")
        }

    }
}


extension letterViewController: UITextViewDelegate {
    // 텍스트 뷰의 내용이 변경될 때 호출되는 메서드
    func textViewDidChange(_ textView: UITextView) {
        updateSubmitButtonState()
    }
}
