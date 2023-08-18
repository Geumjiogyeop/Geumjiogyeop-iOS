//
//  loginViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/13.
//
//
import UIKit
import Alamofire
import SwiftyJSON

class loginViewController: UIViewController {

    @IBOutlet weak var phonenumTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    override func viewDidLoad(){
        navigationController?.navigationBar.tintColor = UIColor(hex: 0xFFA24B)
        let backButton = UIBarButtonItem()
                backButton.title = "홈" // 원하는 텍스트로 변경
                self.navigationItem.backBarButtonItem = backButton
    }
    @IBAction func loginBtn(_ sender: UIButton) {
           performLogin()
       }
    

    
    @IBAction func noLogin(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
                
                // Instantiate the tab bar controller from the second storyboard
                if let tabBarController = storyboard.instantiateInitialViewController() as? UITabBarController {
                    tabBarController.modalPresentationStyle = .fullScreen
                    // Present the tab bar controller
                    self.present(tabBarController, animated: true, completion: nil)
                }
    }
    
       func performLogin() {
           guard let phone = phonenumTextField.text, !phone.isEmpty,
                 let password = pwTextField.text, !password.isEmpty else {
               // 필수 입력 필드가 비어있을 경우 처리
               return
           }
           
           let parameters: [String: Any] = [
               "identifier": phone,
               "password": password
           ]
           
           AF.request("http://175.45.194.93/user/login/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
               .validate()
               .responseData { response in
                   switch response.result {
                   case .success(let value):
                       // 로그인 성공 시 처리
                       let json = JSON(value)
                       print(json)
                       DispatchQueue.main.async {
                           let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
                                   
                                   // Instantiate the tab bar controller from the second storyboard
                                   if let tabBarController = storyboard.instantiateInitialViewController() as? UITabBarController {
                                       tabBarController.modalPresentationStyle = .fullScreen
                                       // Present the tab bar controller
                                       self.present(tabBarController, animated: true, completion: nil)
                                   }
                       }
                   case .failure(let error):
                       // 로그인 실패 시 처리
                       print("Login Error: \(error)")
                   }
               }
       }
}
