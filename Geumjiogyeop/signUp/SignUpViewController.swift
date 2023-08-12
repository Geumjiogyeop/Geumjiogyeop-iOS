//
//  SignUpViewController.swift
//  Geumjiogyeop
//
//  Created by 이서연 on 2023/08/13.
//

import UIKit

class SignUpViewController: UIViewController {
    var name : String?
    var birthbay : String?
    var gender : Bool?
    var is_foreigner : Bool?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var birthTextField: UITextField!
    
    @IBAction func womanBtn(_ sender: UIButton) {
        gender = true
    }
    
    @IBAction func manBtn(_ sender: UIButton) {
        gender = false
    }
    @IBAction func local(_ sender: UIButton) {
        is_foreigner = true
    }
    @IBAction func foreign(_ sender: UIButton) {
        is_foreigner = false
    }
}
