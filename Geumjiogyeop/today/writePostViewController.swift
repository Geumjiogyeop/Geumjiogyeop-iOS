//
//  writePostViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/14.
//

import UIKit
import Alamofire
import SwiftyJSON

class writePostViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor(hex: 0xFFA24B)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
                imageView.addGestureRecognizer(tapGesture)
                imageView.isUserInteractionEnabled = true
        
        self.imagePicker.sourceType = .photoLibrary //앨범에서 가졍오는 코드
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        
    }
    
    @objc func pickImage(){
        self.present(self.imagePicker, animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIBarButtonItem) {
            guard let title = titleTextField.text, !title.isEmpty,
                  let content = contentTextField.text, !content.isEmpty,
                  let image = imageView.image else {
                print("Title and content must not be empty")
                return
            }
            
            let parameters: [String: Any] = [
                "title": title,
                "content": content
            ]
        AF.request("http://175.45.194.93/user/view", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .validate() // 응답을 검증하여 성공적인 응답인지 확인
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        // 요청이 성공한 경우 처리
                        print("Success: \(value)")
                    case .failure(let error):
                        // 요청이 실패한 경우 처리
                        print("Error: \(error)")
                    }
                }
            
            let url = "http://175.45.194.93/today/"
            
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    AF.upload(multipartFormData: { multipartFormData in
                        for (key, value) in parameters {
                            if let stringValue = value as? String {
                                multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                            }
                        }
                        multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                    }, to: url).response { response in
                        switch response.result {
                            
                        case .success(let value):
                            print("성공")
                            print(parameters)
                            print("Upload success: \(value)")
                            self.showModificationAlert()
                                    
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                            
                            // Handle server response
                        case .failure(let error):
                            print("Upload failure: \(error)")
                        }
                    }
                } else {
                    print("Failed to convert image to data")
                }
        }
    func showModificationAlert() {
            let alert = UIAlertController(title: nil, message: "글을 등록하였습니다.", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // 뷰가 사라질 때 데이터 업데이트
            updateTodayData()
        }
        
        func updateTodayData() {
            // "Today" 화면의 데이터를 업데이트
            if let todayVC = navigationController?.viewControllers.first(where: { $0 is todayViewController }) as? todayViewController {
                todayVC.updateData()
            }
            if let todayVC = navigationController?.viewControllers.first(where: { $0 is ManageViewController }) as? ManageViewController {
                todayVC.updateData()
            }
        }
}
extension writePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.imageView.image = newImage // 받아온 이미지를 update
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
        
    }
}
