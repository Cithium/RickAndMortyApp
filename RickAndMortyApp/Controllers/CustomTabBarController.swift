//
//  CustomTabBarController.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-21.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        selectTab(0)
        
    }
    
    private func setAppearance() {
        tabBar.barTintColor = UIColor.lighterBlue
        tabBar.backgroundColor = UIColor.lighterBlue
        tabBar.shadowImage = UIImage()
        tabBar.tintColor = .neonGreen
        tabBar.backgroundImage = UIImage()
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.isTranslucent = true
        
        let titles = ["Characters", "Favorites"]
        if let items = tabBar.items, let font = UIFont(name: "LCD Solid", size: 10.0) {
            
            zip(items, titles).forEach { (item, title) in
                item.setTitleTextAttributes([NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
                item.setTitleTextAttributes([NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: UIColor.neonGreen], for: .selected)
                item.title = title
            }
        }
    }
}

extension CustomTabBarController {
    public func selectTab(_ index: Int) {
        selectedIndex = index
    }
}

