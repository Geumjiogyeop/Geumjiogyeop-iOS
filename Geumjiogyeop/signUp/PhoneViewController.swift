//
//  PhoneViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/17.
//

import UIKit

class PhoneViewController: UIViewController {

    @IBOutlet weak var nexttoinfo: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    var sendphonenum: String?
    var isRegister: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nexttoinfo.isEnabled = false
        nexttoinfo.backgroundColor = UIColor(hex: 0xEBEBEB) // 배경색을 원하는 색상으로 변경해주세요.
        nexttoinfo.setTitle("다음", for: .normal)
        nexttoinfo.setTitleColor(UIColor.white, for: .normal)
    }
    @IBAction func nexttiinfo(_ sender: UIButton) {
        if isRegister == true {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as? SignUpViewController {
                nextVC.phonenumber = sendphonenum!
                print(nextVC.phonenumber)
                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        
    }

    @IBAction func registerBtn(_ sender: Any) {
        sendphonenum = phoneTextField.text
        isRegister = true
        
        nexttoinfo.isEnabled = true
        nexttoinfo.backgroundColor = UIColor(hex: 0xFFA24B) // 배경색을 원하는 색상으로 변경해주세요. 변경이 안됌!!!!!!
        nexttoinfo.setTitle("다음", for: .normal)
        nexttoinfo.setTitleColor(UIColor.white, for: .normal)
        
    }
}
