//
//  SignUpViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/13.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var name : String?
    var birthbay : String?
    var gender : Bool?
    var is_foreigner : Bool?
    var isCilck = false
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var nexttophone: UIButton!
    @IBOutlet weak var womanBtn: UIButton!
    @IBOutlet weak var manBtn: UIButton!
    @IBOutlet weak var local: UIButton!
    @IBOutlet weak var foreign: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()

            // UITextFieldDelegate 설정
            nameTextField.delegate = self
            birthTextField.delegate = self
        }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
            if textField == nameTextField {
                name = textField.text
            } else if textField == birthTextField {
                birthbay = textField.text
            }

            updateNextButtonState()
        }
    
    @IBAction func nexttophone(_ sender: UIButton) {
        print("isCiick")
        print(isCilck)
        if isCilck == true{
            print("조건 성립함")
            //화면 이동 코드 넣기
        }
    }
    
    @IBAction func womanBtn(_ sender: UIButton) {
        gender = true
        if gender == true{
            womanBtn.backgroundColor = UIColor.orange
            manBtn.backgroundColor = UIColor.white
        }
        updateNextButtonState()
    }
    
    @IBAction func manBtn(_ sender: UIButton) {
        gender = false
        
        if gender == false{
            manBtn.backgroundColor = UIColor.orange
            womanBtn.backgroundColor = UIColor.white
        }
        updateNextButtonState()
    }
    @IBAction func local(_ sender: UIButton) {
        is_foreigner = true
        if is_foreigner == true{
            local.backgroundColor = UIColor.orange
            foreign.backgroundColor = UIColor.white
        }
        updateNextButtonState()
    }
    @IBAction func foreign(_ sender: UIButton) {
        is_foreigner = false
        if is_foreigner == false{
            foreign.backgroundColor = UIColor.orange
            local.backgroundColor = UIColor.white
        }
        updateNextButtonState()
    }
    
    func updateNextButtonState() {
            if let name = name, !name.isEmpty,
               let birthbay = birthbay, !birthbay.isEmpty,
               let _ = gender,
               let _ = is_foreigner {
                nexttophone.isEnabled = true
//                nexttophone.backgroundColor = UIColor.blue // 배경색을 원하는 색상으로 변경해주세요. 변경이 안됌!!!!!!
                isCilck = true
            } else {
                nexttophone.isEnabled = false
//                nexttophone.backgroundColor = UIColor.gray // 배경색을 원하는 색상으로 변경해주세요.
                isCilck = false
            }
        }
}
