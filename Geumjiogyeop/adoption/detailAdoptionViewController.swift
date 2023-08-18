//
//  detailAdoptionViewController.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/18.
//

import UIKit
import Alamofire

class detailAdoptionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var adoption: AllAdoption? // 선택한 입양 정보를 저장할 변수
    override func viewDidLoad() {
        super.viewDidLoad()

        // 선택한 입양 정보가 있다면 화면에 표시
        if let selectedAdoption = adoption {
            nameLabel.text = selectedAdoption.name
//            introductionLabel.text = selectedAdoption.introduction
//            dateLabel.text = selectedAdoption.created_at
//            breedLabel.text = "\( selectedAdoption.breed)"
//            genderLabel.text = selectedAdoption.gender
//            ageLabel.text = "\( selectedAdoption.age)"
//            weightLabel.text = "\( selectedAdoption.weight)"
//            isNeutralized.text = "\( selectedAdoption.is_neutralized)"
//            letterTextView.text = selectedAdoption.letter
            
            
            
            // 이미지 설정 (이미지 경로가 문자열로 오는 경우 처리 필요)
            let baseURL = "http://175.45.194.93"
            if let imageUrl = URL(string: baseURL + selectedAdoption.photo) {
                // 이미지를 비동기적으로 가져와서 이미지 뷰에 설정
                AF.request(imageUrl).responseData { response in
                    switch response.result {
                    case .success(let imageData):
                        if let image = UIImage(data: imageData) {
                            self.imageView.image = image
                        } else {
                            self.imageView.image = nil
                        }
                    case .failure(let error):
                        print("Image loading error: \(error)")
                        self.imageView.image = nil
                    }
                }
            } else {
                self.imageView.image = nil // 이미지 로딩 실패 시 기본 이미지 또는 빈 이미지 설정
            }
        }
        
    }
    


}
