//
//  ModifyViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/16.
//

import UIKit
import Alamofire
import SwiftyJSON

class ModifyViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate {

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
        navigationController?.delegate = self
        print(postID!)
        self.imageView.image = image
        self.contentTextView.text = content
        self.titleTextField.text = beforetitle
        
        let saveButton = UIBarButtonItem(title: "수정하기", style: .plain, target: self, action: #selector(saveButtonTapped))
                navigationItem.rightBarButtonItem = saveButton

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
                imageView.addGestureRecognizer(tapGesture)
                imageView.isUserInteractionEnabled = true
        
        self.imagePicker.sourceType = .photoLibrary //앨범에서 가졍오는 코드
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        
        self.titleTextField.delegate = self
        self.contentTextView.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // 텍스트 필드의 텍스트가 변경될 때 호출됩니다.
            // 변경된 텍스트를 사용하여 원하는 처리를 수행할 수 있습니다.
            if textField == titleTextField {
                // titleTextField의 변경 처리
                let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
                titleTextField.text = updatedText
                return true
            }
            return true
        }
    
    @objc func saveButtonTapped() {
        guard let title = self.titleTextField.text,
              let content = self.contentTextView.text,
              let image = imageView.image,
              let postID = self.postID else {
            print("Title, content, and image must not be empty")
            return
        }

        let parameters: [String: Any] = [
            "title": title,     // 수정된 title 사용
            "content": content, // 수정된 content 사용
            // 기타 수정할 필드들 추가
        ]

        let url = "http://175.45.194.93/today/\(postID)/"

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
                    self.showModificationAlert()
                    DispatchQueue.main.asyncAfter(deadline: .now()+6) {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }

    
    func showModificationAlert() {
            let alert = UIAlertController(title: nil, message: "수정되었습니다.", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
   
    
    @objc func pickImage(){
        self.present(self.imagePicker, animated: true)
    }
    
    @IBAction func modifyButtonTapped(_ sender: UIBarButtonItem) {
       

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
