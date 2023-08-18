//
//  secondStepViewController.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/17.
//

import UIKit
import Alamofire
import SwiftyJSON

class secondStepViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var dogButton: UIButton!
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petNameTextField: UITextField!
    @IBOutlet weak var nextButton: defaultButton!
    @IBOutlet weak var uploadImageView: UIImageView!
    
    var name: String = ""
    var breed: Bool = false
    var photo: UIImage?
    var uploadImage: UIImage?  // 선택된 이미지를 저장할 변수
    
    
    let imagePicker = UIImagePickerController()
    var selectedBreed: Bool = true  // 강아지를 기본 선택으로 설정
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "반려동물 정보 입력"
        navigationController?.navigationBar.tintColor = UIColor.black
        
        // 처음에 강아지 버튼을 선택 상태로 변경
        updateButtonStyles()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        uploadImageView.addGestureRecognizer(tapGesture)
        uploadImageView.isUserInteractionEnabled = true
        
        self.imagePicker.sourceType = .photoLibrary //앨범에서 가져오는 코드
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        
        // 텍스트 필드의 편집 상태가 변경될 때마다 호출되는 메서드를 등록
        petNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //updateNextButtonState()
    }
    
    // 텍스트 필드의 값이 변경될 때마다 호출되는 메서드
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateNextButtonState()
    }
    
    // nextButton 상태 업데이트
    func updateNextButtonState() {
        let imageName = uploadImageView.image?.accessibilityIdentifier ?? ""
        nextButton.isEnabled = !petNameTextField.text!.isEmpty && imageName != "plus.square"
        
        if nextButton.isEnabled {
            nextButton.backgroundColor = UIColor.orange
            print("버튼 활성화")
        } else {
            nextButton.backgroundColor = UIColor.systemGray5
            print("버튼 비활성화")
        }
        
    }
    
    @objc func pickImage(){
        self.present(self.imagePicker, animated: true)
    }
    
    
    @IBAction func dogButton(_ sender: UIButton) {
        selectedBreed = true  // 강아지 선택
        updateButtonStyles()
    }
    
    @IBAction func catButton(_ sender: UIButton) {
        selectedBreed = false  // 고양이 선택
        updateButtonStyles()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // nextButton이 활성화된 상태에서만 데이터 전달 및 화면 전환
        if nextButton.isEnabled {
            let storyboard = UIStoryboard(name: "myPageStoryboard", bundle: nil)
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "inputInformationViewController") as? inputInformationViewController {
                // 데이터 전달
                nextViewController.name = petNameTextField.text ?? ""
                nextViewController.breed = selectedBreed
                nextViewController.photo = uploadImageView.image
                nextViewController.uploadImage = uploadImage
                // 네비게이션 컨트롤러를 이용하여 화면 전환
                navigationController?.pushViewController(nextViewController, animated: true)
            }
        } else {
            // nextButton이 비활성화된 상태일 때는 알림을 표시
            let alertController = UIAlertController(title: nil, message: "다음으로 넘어가지 못합니다. 필요한 정보를 모두 입력해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        
    }
    // 선택된 버튼 스타일 업데이트
    func updateButtonStyles() {
        if selectedBreed == true {
            dogButton.layer.borderWidth = 3.0
            dogButton.layer.borderColor = UIColor.orange.cgColor
            catButton.layer.borderWidth = 0
            petNameLabel.text = "우리집 강아지 이름은요,"
            print("강쥐")
        } else {
            catButton.layer.borderWidth = 3.0
            catButton.layer.borderColor = UIColor.orange.cgColor
            dogButton.layer.borderWidth = 0
            petNameLabel.text = "우리집 고양이 이름은요,"
            print("고먐")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            uploadImageView.image = pickedImage
            uploadImage = pickedImage  // 선택된 이미지 저장
        }
    }
    
}
