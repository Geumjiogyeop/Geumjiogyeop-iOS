//
//  webKitViewController.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/17.
//

import UIKit
import WebKit

class webKitViewController: UIViewController {
    
    var webView = WKWebView()
    
    override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            view = webView
//            
//            // ios 16.4 에서 DEBUG 모드인 경우에만
//            // webview inspector 가능하도록 설정
//            if #available(iOS 16.4, *) {
//                #if DEBUG
//                webView.isInspectable = true  // webview inspector 가능하도록 설정
//                #endif
//            }
//            
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("WebViewController >> viewDidLoad ")
                loadUrl("https://kr.object.ncloudstorage.com/geumjioyeop-bucket/index.html")
    }
    

    
       func loadUrl(_ url: String) {
           let myURL = URL(string: url)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest) // 웹뷰 load
       }

}
