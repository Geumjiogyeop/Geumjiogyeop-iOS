import UIKit
class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure tab bar items
        if let items = tabBar.items {
            for item in items {
                // Adjust the icon size
                item.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)
                
                // Adjust the title size
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 100)
            }
        }
    }
}
