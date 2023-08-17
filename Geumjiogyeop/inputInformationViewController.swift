//
//  inputInformationViewController.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/17.
//

import UIKit
import Alamofire
import SwiftyJSON


class inputInformationViewController: UIViewController{
    
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageButton: UIButton!
    
    @IBOutlet weak var femaleButton: defaultButton!
    @IBOutlet weak var maleButton: defaultButton!
    @IBOutlet weak var genderButton: UIButton!
    
    @IBOutlet weak var notNeutralizedButton: defaultButton!
    @IBOutlet weak var isNeutralizedButton: defaultButton!
    @IBOutlet weak var neutralizedButton: UIButton!
    
    @IBOutlet weak var nextButton: defaultButton!
    
    var name: String = ""
    var breed: Bool = false
    var photo: UIImage?
    var gender: String = ""
    var age: Int = 0
    var weight: Int = 0
    var is_neutralized: Int = 0
    var uploadImage: UIImage?  // 선택된 이미지를 저장할 변수
    
    var ageButtonSelected: Bool = false // ageButton의 선택 여부를 나타내는 변수
    var isGenderButtonSelected: Bool = false // genderButton의 선택 여부를 나타내는 변수
    var isNeutralizedSelected: Bool = false //neutralizedButton 선택 여부
    
    
    var selectedGender: String = ""
    var selectedNeutralized: Int = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "반려동물 정보 입력"
        navigationController?.navigationBar.tintColor = UIColor.black
        ageButtonSelected = false
        isGenderButtonSelected = false
        isNeutralizedSelected = false
        print(name)
        print(photo)
    
        // UISlider의 값을 변경했을 때 호출되는 메서드 등록
        ageSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

        // 초기 값 설정
        ageSlider.minimumValue = 0
        ageSlider.maximumValue = 30
        ageSlider.value = Float(age) // 초기 값 설정
        updateAgeLabel() // 초기 값에 따라 라벨 업데이트

    }
    

    @IBAction func ageButtonTapped(_ sender: UIButton) {
        ageButtonSelected.toggle() // 선택 여부 변경
                
        // ageButton 선택 여부에 따라 이미지 변경
        if ageButtonSelected {
            ageButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            ageSlider.isEnabled = false // 슬라이더 비활성화
            ageLabel.text = "잘 모르겠음" // 라벨 내용 변경
            updateNextButtonState()
        } else {
            ageButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            ageSlider.isEnabled = true // 슬라이더 활성화
            updateAgeLabel() // 라벨 내용 업데이트
            updateNextButtonState() // 다음 버튼 상태 업데이트
        }
    }
    
    @IBAction func maleButton(_ sender: defaultButton) {
        selectedGender = "남"
        updateGenderButtonStyles()
        updateNextButtonState()
    }
    
    @IBAction func femaleButton(_ sender: defaultButton) {
        selectedGender = "여"
        updateGenderButtonStyles()
        updateNextButtonState()
    }
    
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        isGenderButtonSelected.toggle() // 선택 여부 변경
        
    // genderButton 선택 여부에 따라 버튼 스타일 변경 및 버튼 비활성화
        if isGenderButtonSelected {
            genderButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
           selectedGender = "모름" // 선택 상태 변경
            print("성별 모름")
            femaleButton.isEnabled = false
            maleButton.isEnabled = false
        } else {
            genderButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            femaleButton.isEnabled = true
            maleButton.isEnabled = true
        }
       updateGenderButtonStyles() // 선택된 버튼의 스타일 변경
        updateNextButtonState() // 다음 버튼 상태 업데이트
    }
    
    @IBAction func isNeutralizedButton(_ sender: defaultButton) {
        selectedNeutralized = 1
        updateNeutralizedButtonStyles()
        updateNextButtonState()
    }
    
    @IBAction func notNeutralizedButton(_ sender: defaultButton) {
        selectedNeutralized = 0
        updateNeutralizedButtonStyles()
        updateNextButtonState()
    }
    
    @IBAction func neutralizedButtonTapped(_ sender: UIButton) {
        isNeutralizedSelected.toggle()
        
        if isNeutralizedSelected {
            neutralizedButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            selectedNeutralized = 2 // 선택 상태 변경
            print(selectedNeutralized)
            notNeutralizedButton.isEnabled = false
            isNeutralizedButton.isEnabled = false
        } else {
            neutralizedButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            notNeutralizedButton.isEnabled = true
            isNeutralizedButton.isEnabled = true
           
        }
        updateNeutralizedButtonStyles() // 선택된 버튼의 스타일 변경
        updateNextButtonState() // 다음 버튼 상태 업데이트
    }
    
    @IBAction func nextButtonTapped(_ sender: defaultButton) {
        // nextButton이 활성화된 상태에서만 데이터 전달 및 화면 전환
        if nextButton.isEnabled {
            let storyboard = UIStoryboard(name: "myPageStoryboard", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "letterViewController") as? letterViewController {
            // 데이터 전달
            nextViewController.name = name
            nextViewController.breed = breed
            nextViewController.photo = photo
            nextViewController.age = age
            nextViewController.gender = selectedGender
            nextViewController.is_neutralized = selectedNeutralized
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
    
    
    // UISlider 값 변경에 따른 처리 메서드
   @objc func sliderValueChanged(_ slider: UISlider) {
       // UISlider의 값을 받아와 Int로 변환하여 age 변수에 저장
       age = Int(slider.value)
       updateAgeLabel() // 라벨 업데이트
       updateNextButtonState()
   }

   // UILabel 업데이트 메서드
   func updateAgeLabel() {
       ageLabel.text = "\(age)살입니다"
   }
    
    
    // 성별 버튼 스타일 업데이트
    func updateGenderButtonStyles() {
        if selectedGender == "남" {
            maleButton.layer.borderWidth = 3.0
            maleButton.layer.borderColor = UIColor.orange.cgColor
            femaleButton.layer.borderWidth = 0
            femaleButton.setTitleColor(UIColor.label, for: .normal)
            maleButton.setTitleColor(UIColor.label, for: .normal)
            print("남아")
        } else if selectedGender == "여" {
            femaleButton.layer.borderWidth = 3.0
            femaleButton.layer.borderColor = UIColor.orange.cgColor
            maleButton.layer.borderWidth = 0
            femaleButton.setTitleColor(UIColor.label, for: .normal)
            maleButton.setTitleColor(UIColor.label, for: .normal)
            print("여아")
        } else if selectedGender == "모름" {
            maleButton.layer.borderWidth = 0
            femaleButton.layer.borderWidth = 0
            femaleButton.setTitleColor(UIColor.systemGray, for: .normal)
            maleButton.setTitleColor(UIColor.systemGray, for: .normal)
            
        }
    }
    
    // 중성화 여부 버튼 스타일 업데이트
    func updateNeutralizedButtonStyles() {
        if selectedNeutralized == 1 {
            isNeutralizedButton.layer.borderWidth = 3.0
            isNeutralizedButton.layer.borderColor = UIColor.orange.cgColor
            notNeutralizedButton.layer.borderWidth = 0
            notNeutralizedButton.setTitleColor(UIColor.label, for: .normal)
            maleButton.setTitleColor(UIColor.label, for: .normal)
            print("중성화 함")
        } else if selectedNeutralized == 0 {
            notNeutralizedButton.layer.borderWidth = 3.0
            notNeutralizedButton.layer.borderColor = UIColor.orange.cgColor
            isNeutralizedButton.layer.borderWidth = 0
            notNeutralizedButton.setTitleColor(UIColor.label, for: .normal)
            isNeutralizedButton.setTitleColor(UIColor.label, for: .normal)
            print("중성화 안함")
        } else if selectedNeutralized == 2 {
            isNeutralizedButton.layer.borderWidth = 0
            notNeutralizedButton.layer.borderWidth = 0
            notNeutralizedButton.setTitleColor(UIColor.systemGray, for: .normal)
            isNeutralizedButton.setTitleColor(UIColor.systemGray, for: .normal)
            
        }
    }
    
    func updateNextButtonState() {
        // 슬라이더의 값이 1 이상이거나 ageButton이 선택되어 있으면 true
        let isAgeValid = ageSlider.value >= 1 || ageButtonSelected
        
        // 남녀 값이 선택되었으면 true
        let isGenderSelected = selectedGender == "남" || selectedGender == "여" || isGenderButtonSelected
        
        // 중성화 여부가 선택되었으면 true
        let isNeutralizedSelected = selectedNeutralized == 0 || selectedNeutralized == 1 || isNeutralizedSelected
        
        // 모든 조건을 만족하면 다음 버튼 활성화
        nextButton.isEnabled = isAgeValid && isGenderSelected && isNeutralizedSelected
        
        if nextButton.isEnabled {
            nextButton.backgroundColor = UIColor.orange
        } else {
            nextButton.backgroundColor = UIColor.systemGray5
        }
    }

}
