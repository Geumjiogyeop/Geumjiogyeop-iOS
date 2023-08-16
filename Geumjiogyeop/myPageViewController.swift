//
//  myPageViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/09.
//

import UIKit

class myPageViewController: UIViewController {

    @IBOutlet weak var serviceInfoView: UIView!
    @IBOutlet weak var serviceInfoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10  //행간
            paragraphStyle.alignment = .center // 텍스트 정렬
        let attributedText = NSAttributedString(string: "만 50세 이상, 1인 가구 이신가요?\n갑작스러운 사고를 대비해 반려동물 등록해두세요", attributes: [.paragraphStyle: paragraphStyle])
        
        // Attributed text 설정
        serviceInfoLabel.attributedText = attributedText

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(serviceInfoViewTapped))
                serviceInfoView.addGestureRecognizer(tapGesture)
    }
    
    @objc func serviceInfoViewTapped() {
            let storyboard = UIStoryboard(name: "myPageStoryboard", bundle: nil)
            
            // Storyboard ID에 해당하는 뷰 컨트롤러 인스턴스화
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "serviceInfoView") as? serviceInfoViewController {
                navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
    

}
