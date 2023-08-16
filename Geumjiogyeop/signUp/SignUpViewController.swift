//
//  SignUpViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/13.
//

import UIKit
import Alamofire
import SwiftyJSON
//

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var name : String?
    var birthbay : String?
    var password : String?
    var gender : Bool?
    var is_foreigner : Bool?
    var isCilck = false
    var phonenumber : String?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
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
        pwTextField.delegate = self
            
        nexttophone.isEnabled = false
        nexttophone.backgroundColor = UIColor(hex: 0xEBEBEB) // 배경색을 원하는 색상으로 변경해주세요.
        nexttophone.setTitle("가입완료", for: .normal)
        nexttophone.setTitleColor(UIColor.white, for: .normal)
        
        }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
            if textField == nameTextField {
                name = textField.text
            } else if textField == birthTextField {
                birthbay = textField.text
            }
        else if textField == pwTextField {
            password = textField.text
        }

            updateNextButtonState()
        }
    
   
    @IBAction func nexttophone(_ sender: UIButton) {
        print("isCiick")
        print(isCilck)
        if isCilck == true{
            print("조건 성립함")
            alamofire()
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "loginView") as? loginViewController {
                print("??")
                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    @IBAction func womanBtn(_ sender: UIButton) {
        gender = true
        if gender == true{
            womanBtn.backgroundColor = UIColor(hex: 0xFFA24B)
            womanBtn.setTitleColor(UIColor.white, for: .normal)
            manBtn.backgroundColor = UIColor.white
            manBtn.setTitleColor(UIColor.black, for: .normal)
            womanBtn.setTitle("여자", for: .normal)
            manBtn.setTitle("남자", for: .normal)
        }
        updateNextButtonState()
    }
    
    @IBAction func manBtn(_ sender: UIButton) {
        gender = false
        
        if gender == false{
            manBtn.backgroundColor = UIColor(hex: 0xFFA24B)
            manBtn.setTitleColor(UIColor.white, for: .normal)
            womanBtn.backgroundColor = UIColor.white
            womanBtn.setTitleColor(UIColor.black, for: .normal)
            womanBtn.setTitle("여자", for: .normal)
            manBtn.setTitle("남자", for: .normal)

        }
        updateNextButtonState()
    }
    @IBAction func local(_ sender: UIButton) {
        is_foreigner = true
        if is_foreigner == true{
            local.backgroundColor = UIColor(hex: 0xFFA24B)
            local.setTitleColor(UIColor.white, for: .normal)
            foreign.backgroundColor = UIColor.white
            foreign.setTitleColor(UIColor.black, for: .normal)
            local.setTitle("내국인", for: .normal)
            foreign.setTitle("외국인", for: .normal)
        }
        updateNextButtonState()
    }
    @IBAction func foreign(_ sender: UIButton) {
        is_foreigner = false
        if is_foreigner == false{
            foreign.backgroundColor = UIColor(hex: 0xFFA24B)
            foreign.setTitleColor(UIColor.white, for: .normal)
            local.backgroundColor = UIColor.white
            local.setTitleColor(UIColor.black, for: .normal)
            local.setTitle("내국인", for: .normal)
            foreign.setTitle("외국인", for: .normal)
        }
        updateNextButtonState()
    }
    
    func updateNextButtonState() {
            if let name = name, !name.isEmpty,
               let birthbay = birthbay, !birthbay.isEmpty,
               let password = password, !password.isEmpty,
               let _ = gender,
               let _ = is_foreigner {
                nexttophone.isEnabled = true
                nexttophone.backgroundColor = UIColor(hex: 0xFFA24B) // 배경색을 원하는 색상으로 변경해주세요. 변경이 안됌!!!!!!
                nexttophone.setTitle("가입완료", for: .normal)
                nexttophone.setTitleColor(UIColor.white, for: .normal)
                isCilck = true
            } else {
                nexttophone.isEnabled = false
                nexttophone.backgroundColor = UIColor(hex: 0xEBEBEB) // 배경색을 원하는 색상으로 변경해주세요.
                nexttophone.setTitle("가입완료", for: .normal)
                nexttophone.setTitleColor(UIColor.white, for: .normal)
                isCilck = false
            }
        }
    func alamofire() {
        // HTTP 네트워킹을 통해 전송 할 데이터
       
        let parameters: [String: Any] = [
            "phonenumber": phonenumber!,
            "password" : password!,
            "name": name!,
            "birthday": birthbay!,
            "gender" : gender!,
            "is_foreigner" : is_foreigner!
        ]

        AF.request("http://175.45.194.93/user/signin", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()  // 이 부분이 .request 메서드 다음에 와야 합니다.
            .responseData { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                case .failure(let error):
                    print("\(#function): \(error)")
                }
            }
    }
}

