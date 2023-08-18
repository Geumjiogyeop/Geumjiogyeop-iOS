//
//  kakaoWebKitViewController.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/18.
//

import UIKit
import WebKit

class kakaoWebKitViewController: UIViewController {
    
    var webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUrl("http://pf.kakao.com/_sxcyEG")
    }
    
    override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            view = webView
        }
    
    func loadUrl(_ url: String) {
        let myURL = URL(string: url)
         let myRequest = URLRequest(url: myURL!)
         webView.load(myRequest) // 웹뷰 load
    }
}
