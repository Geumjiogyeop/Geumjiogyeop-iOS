//
//  serviceInfoViewController.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/10.
//

import UIKit

class serviceInfoViewController: UIViewController {

    @IBOutlet weak var serviceInfoLabel: UILabel!
    @IBAction func signUpServiceButton(_ sender: UIButton) {
        print(" 버튼 눌림!!!!")
        if let navigationController = navigationController {
                print("네비게이션 컨트롤러가 존재합니다.")
                
                let storyboard = UIStoryboard(name: "myPageStoryboard", bundle: nil)
                if let nextViewController = storyboard.instantiateViewController(withIdentifier: "signUpService") as? signUpServiceViewController {
                    navigationController.pushViewController(nextViewController, animated: true)
                }
            } else {
                print("네비게이션 컨트롤러가 존재하지 않습니다.")
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "금지옥엽 서비스"
        navigationController?.navigationBar.tintColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10  //행간
        let attributedText = NSAttributedString(string: "만 50세 이상, 1인 가구 이신가요?\n갑작스러운 사고를 대비해 반려동물 등록해두세요!", attributes: [.paragraphStyle: paragraphStyle])
        
        // Attributed text 설정
        serviceInfoLabel.attributedText = attributedText
        
        
    }


}
