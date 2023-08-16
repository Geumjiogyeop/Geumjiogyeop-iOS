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
        if textField == titleTextField {
            // 기존 텍스트에서 변경된 부분을 새로운 텍스트로 대체
            if let currentText = titleTextField.text,
               let range = Range(range, in: currentText) {
                let updatedText = currentText.replacingCharacters(in: range, with: string)
                titleTextField.text = updatedText
            }
            return false // false를 반환하여 기존 텍스트가 변경되지 않도록 함
        }
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == contentTextView {
            // 기존 텍스트에서 변경된 부분을 새로운 텍스트로 대체
            if let currentText = contentTextView.text,
               let range = Range(range, in: currentText) {
                let updatedText = currentText.replacingCharacters(in: range, with: text)
                contentTextView.text = updatedText
            }
            return false // false를 반환하여 기존 텍스트가 변경되지 않도록 함
        }
        return true
    }

    
    @objc func saveButtonTapped() {
        guard let title = self.titleTextField.text, !title.isEmpty,
              let content = self.contentTextView.text, !content.isEmpty,
              let image = imageView.image,
              let postID = self.postID else {
            print("Title, content, and image must not be empty")
            return
        }
        print(content)
        print(self.contentTextView.text)

        let url = "http://175.45.194.93/today/\(postID)/"

        AF.upload(
            multipartFormData: { multipartFormData in
                // 이미지 데이터를 파라미터에 추가
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                }

                // 기타 파라미터들을 추가
                multipartFormData.append(title.data(using: .utf8)!, withName: "title")
                multipartFormData.append(content.data(using: .utf8)!, withName: "content")
                print(title)
                print(content)
                // 기타 수정할 파라미터들 추가

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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print("Error: \(error)")
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
