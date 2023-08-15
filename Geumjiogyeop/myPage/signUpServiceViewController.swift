//
//  signUpServiceViewController.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/14.
//

import UIKit

class signUpServiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "서비스 가입 안내"
        navigationController?.navigationBar.tintColor = UIColor.black
        // Do any additional setup after loading the view.
    }
    @IBAction func goToFirstButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "myPageStoryboard", bundle: nil)
        
        // Storyboard ID에 해당하는 뷰 컨트롤러 인스턴스화
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "firstStep") as? firstStepViewController {
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
}


class firstStepViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "주민등록등본 촬영"
        navigationController?.navigationBar.tintColor = UIColor.black
        // Do any additional setup after loading the view.
    }

}
