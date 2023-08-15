//
//  ModifyViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/16.
//

import UIKit
import Alamofire
import SwiftyJSON

class ModifyViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    var postID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(postID)
        
        
//        /AF.request("http://175.45.194.93/today").responseJSON { response in
            //                    switch response.result {
            //                    case .success(let value):
            //                        if let jsonArray = value as? [[String: Any]] {
            //                            for json in jsonArray {
            //                                if let title = json["title"] as? String,
            //                                   let content = json["content"] as? String,
            //                                   let imageUrlString = json["imageUrl"] as? String,
            //                                   let imageUrl = URL(string: imageUrlString),
            //                                   let imageData = try? Data(contentsOf: imageUrl),
            //                                   let image = UIImage(data: imageData)
            //                                     {
            //                                    self.imageView.setImage = image
//        self.contentTextView = content
//        self.titleTextField = title
            //
            //                                }
            //                            }
            //
            //                            // 데이터 가져오기 완료 후, collectionView를 리로드하거나 UI 업데이트
            //                            self.reloadData()
            //                        }
            //                    case .failure(let error):
            //                        print("Error: \(error)")
            //                    }
            //                }
        
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
    
    @IBAction func modifyButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty,
              let content = contentTextView.text, !content.isEmpty,
              let image = imageView.image,
              let postID = self.postID else {
            print("Title, content, and image must not be empty")
            return
        }
        
        let parameters: [String: Any] = [
            "title": title,
            "content": content,
            // 기타 수정할 필드들 추가
        ]
        
        let url = "http://175.45.194.93/today/\(postID)"
        
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            AF.upload(
                multipartFormData: { multipartFormData in
                    // 이미지 데이터를 파라미터에 추가
                    multipartFormData.append(imageData, withName: "images", fileName: "image.jpg", mimeType: "image/jpeg")
                    
                    // 기타 파라미터들을 추가
                    for (key, value) in parameters {
                        if let data = "\(value)".data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                },
                to: url,
                method: .put, // PUT 메서드 사용
                headers: nil
            )
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Success: \(value)")
                    // 서버 응답을 처리하는 코드 추가
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }

    }

}
extension ModifyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
