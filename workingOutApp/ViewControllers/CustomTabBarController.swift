//
//  CustomTabBarController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .red
        tabBar.layer.cornerRadius = 40
        tabBar.layer.borderWidth = 2
        tabBar.layer.borderColor = UIColor.purple.cgColor
        tabBar.barTintColor = .white
        tabBar.isTranslucent = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
        tabBar.layer.masksToBounds = false
        
        let worckingOutTableTableViewController = UINavigationController(rootViewController: WorckingOutTableTableViewController() as UIViewController)
        let timerViewController = TimerViewController() as UIViewController
        timerViewController.tabBarItem.title = "Timer"
    
        worckingOutTableTableViewController.tabBarItem.title = "Program"
        viewControllers = [timerViewController, worckingOutTableTableViewController]
        // Do any additional setup after loading the view.
    }
}
