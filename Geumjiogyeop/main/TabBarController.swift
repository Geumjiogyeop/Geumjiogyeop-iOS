//
//  TabBarController.swift
//  Geumjiogyeop
//
//  Created by 이자민 on 2023/08/19.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let secondTabItem = tabBar.items?[1]
        secondTabItem?.image = UIImage(systemName: "heart")
        secondTabItem?.selectedImage = UIImage(systemName: "heart.fill")
        
        let fourthTabItem = tabBar.items?[3]
        fourthTabItem?.image = UIImage(systemName: "heart")
        fourthTabItem?.selectedImage = UIImage(systemName: "heart.fill")
        
        // 선택된 탭 바 아이템의 색상 설정
        tabBar.tintColor = UIColor.orange
    }
    


}
