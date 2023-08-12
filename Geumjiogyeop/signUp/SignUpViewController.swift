//
//  SignUpViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/13.
//

import UIKit

class SignUpViewController: UIViewController {

    var agreeclickcount = 1
    var isagreeclick = false
    @IBOutlet weak var firstagreeBtn : UIButton!
    @IBOutlet weak var secondagreeBtn : UIButton!
    @IBOutlet weak var thirdagreeBtn : UIButton!
    @IBOutlet weak var nexttoinfoBtn : UIButton!
//    @IBOutlet weak var agreeBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        let storyboard = UIStoryboard(name: "loginStoryboard", bundle: nil)
        if isagreeclick == true {
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as? SignUpViewController {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
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
//                agreeBtn.setTitleColor(.white, for: .normal)
                firstagreeBtn.setTitleColor(.black, for: .normal)
                secondagreeBtn.setTitleColor(.black, for: .normal)
                thirdagreeBtn.setTitleColor(.black, for: .normal)
                nexttoinfoBtn.backgroundColor = UIColor(hex: 0xFFA24B)
            } else {
                isagreeclick = false
//                agreeBtn.setTitleColor(.black, for: .normal)
                firstagreeBtn.setTitleColor(.white, for: .normal)
                secondagreeBtn.setTitleColor(.white, for: .normal)
                thirdagreeBtn.setTitleColor(.white, for: .normal)
                nexttoinfoBtn.backgroundColor = .gray
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
