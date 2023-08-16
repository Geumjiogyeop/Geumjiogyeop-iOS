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
    
    var postID: Int!
    var beforetitle: String!
    var content: String!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(postID!)
        self.imageView.image = image
        self.contentTextView.text = content
        self.titleTextField.text = beforetitle
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
                navigationItem.rightBarButtonItem = saveButton
       
//        AF.request("http://175.45.194.93/today/\(postID!)").validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                if let jsonArray = value as? [[String: Any]], let json = jsonArray.first {
//                    let imagesArray = json["images"] as? [[String: Any]] ?? []
//                    if let imageUrlString = imagesArray.first?["image"] as? String,
//                       let imageUrl = URL(string: imageUrlString)
//                    {
//                        AF.request(imageUrl).responseData { imageResponse in
//                            if let imageData = imageResponse.data, let image = UIImage(data: imageData) {
//                                let writer = json["writer"] as? [String: Any] ?? [:]
//                                let username = writer["name"] as? String ?? "Unknown"
//                                let userid = writer["user_id"] as? Int ?? 0
//                                let title = json["title"] as? String ?? "No Title"
//                                let date = json["created_at"] as? String ?? "Unknown Date"
//                                let content = json["content"] as? String ?? "No Content"
//                                let postID = json["id"] as? Int ?? 0
//                                let likes = json["likes"] as? Int ?? 0
//                                let editable = json["editable"] as? Bool ?? false
//
//                                DispatchQueue.main.async {
//                                    self.imageView.image = image
//                                    self.contentTextView.text = content
//                                    self.titleTextField.text = title
//                                }
//                            }
//                        }
//                    }
//                }
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
                imageView.addGestureRecognizer(tapGesture)
                imageView.isUserInteractionEnabled = true
        
        self.imagePicker.sourceType = .photoLibrary //앨범에서 가졍오는 코드
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
    }
    
    @objc func saveButtonTapped() {
            // 여기에 버튼을 눌렀을 때 실행할 코드를 작성합니다.
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
                    multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                    
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
