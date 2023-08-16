//
//  AgreeViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/13.
//

import UIKit

class AgreeViewController: UIViewController {

    var agreeclickcount = 1
    var isagreeclick = false
    @IBOutlet weak var firstagreeBtn : UIButton!
    @IBOutlet weak var secondagreeBtn : UIButton!
    @IBOutlet weak var thirdagreeBtn : UIButton!
    @IBOutlet weak var nexttoinfoBtn : UIButton!
    @IBOutlet weak var allagreeBtn : UIButton!
    
//    @IBOutlet weak var agreeBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nexttoinfoBtn.backgroundColor = UIColor(hex: 0xEBEBEB)
        nexttoinfoBtn.setTitleColor(UIColor.black, for: .normal)
        
        allagreeBtn.setTitleColor(UIColor.black, for: .normal)
        allagreeBtn.backgroundColor = UIColor(hex: 0xEBEBEB)
        nexttoinfoBtn.setTitle("다음", for: .normal)
        
    }
//    @IBAction func firstagreeBtn(_ sender: UIButton){
//
//    }
//    @IBAction func secondagreeBtn(_ sender: UIButton){
//
//    }
//    @IBAction func thirdagreeBtn(_ sender: UIButton){
//
//    }
    @IBAction func nexttoinfoBtn(_ sender: UIButton){
        print(isagreeclick)
        if isagreeclick == true {
            print("화면 전환")
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "phoneViewController") as? PhoneViewController {
                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
//        else if isagreeclick == false{
//            print("false임")
//        }
    }
    @IBAction func allagreeBtn(_ sender: UIButton) {
        agreeclickcount+=1
        print(agreeclickcount)
        if agreeclickcount % 2 == 0 {
                isagreeclick = true
                allagreeBtn.setTitleColor(UIColor.white, for: .normal)
            allagreeBtn.backgroundColor = UIColor.black
                firstagreeBtn.setTitleColor(UIColor.black, for: .normal)
            firstagreeBtn.titleLabel?.alpha = 1
                secondagreeBtn.setTitleColor(UIColor.black, for: .normal)
            secondagreeBtn.titleLabel?.alpha = 1
                thirdagreeBtn.setTitleColor(UIColor.black, for: .normal)
            thirdagreeBtn.titleLabel?.alpha = 1
                nexttoinfoBtn.backgroundColor = UIColor(hex: 0xFFA24B)
            nexttoinfoBtn.setTitleColor(UIColor.white, for: .normal)
            allagreeBtn.setTitle("필수 약관 전체동의", for: .normal)
            allagreeBtn.setImage(.checkmark, for: .normal)
            firstagreeBtn.setTitle("[필수] 만 14세 이상입니다", for: .normal)
            secondagreeBtn.setTitle("[필수] 서비스 이용약관 동의", for: .normal)
            thirdagreeBtn.setTitle("[필수] 개인정보 처리방침 동의", for: .normal)
            nexttoinfoBtn.setTitle("다음", for: .normal)
            } else {
                isagreeclick = false
                allagreeBtn.setTitleColor(UIColor.black, for: .normal)
                allagreeBtn.backgroundColor = UIColor(hex: 0xEBEBEB)
                firstagreeBtn.setTitleColor(UIColor(hex: 0x333333), for: .normal)
                firstagreeBtn.titleLabel?.alpha = 0.5
                
                secondagreeBtn.setTitleColor(UIColor(hex: 0x333333), for: .normal)
                secondagreeBtn.titleLabel?.alpha = 0.5
                thirdagreeBtn.setTitleColor(UIColor(hex: 0x333333), for: .normal)
                thirdagreeBtn.titleLabel?.alpha = 0.5
                nexttoinfoBtn.backgroundColor = UIColor(hex: 0xEBEBEB)
                nexttoinfoBtn.setTitleColor(UIColor.black, for: .normal)
                allagreeBtn.setTitle("필수 약관 전체동의", for: .normal)
                allagreeBtn.setImage(.checkmark, for: .normal)
                firstagreeBtn.setTitle("[필수] 만 14세 이상입니다", for: .normal)
                secondagreeBtn.setTitle("[필수] 서비스 이용약관 동의", for: .normal)
                thirdagreeBtn.setTitle("[필수] 개인정보 처리방침 동의", for: .normal)
                nexttoinfoBtn.setTitle("다음", for: .normal)
            }
    }
    

}
extension UIColor {
    convenience init?(hex: Int, alpha: CGFloat = 1.0) {
        guard (0...0xFFFFFF) ~= hex else {
            return nil
        }
        
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

}
