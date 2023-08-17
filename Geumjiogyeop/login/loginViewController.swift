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
        
    }
    @IBAction func loginBtn(_ sender: UIButton) {
           performLogin()
       }
    
//    @IBAction func gotoLoginBtn(_ sender: UIButton) {
//        guard let vc = storyboard?.instantiateViewController(withIdentifier: "loginView") as? loginViewController else{
//            print("로그인못해ㅠ")
//            return
//        }
//        navigationController?.pushViewController(vc, animated: true)
//        print("로그인할래!")
//        
//    }
    
    @IBAction func nologinBtn(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
//                let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "mainViewController") as! UITabBarController
//                mainTabBarController.modalPresentationStyle = .fullScreen
//                present(mainTabBarController, animated: true, completion: nil)
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
//                           if let nextVC = UIStoryboard(name: "todayStoryboard", bundle: nil).instantiateViewController(withIdentifier: "todayViewController") as? todayViewController {
//                               self.navigationController?.pushViewController(nextVC, animated: true)
//                           }
                           if let nextVC = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "mainViewController") as? todayViewController {
                               self.navigationController?.pushViewController(nextVC, animated: true)
                           }
                       }
                   case .failure(let error):
                       // 로그인 실패 시 처리
                       print("Login Error: \(error)")
                   }
               }
       }
}
