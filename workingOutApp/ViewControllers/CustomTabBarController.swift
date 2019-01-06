//
//  CustomTabBarController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    var secondsFromTableView = 0.00 {
        didSet {
            firstController?.secondsTimer = secondsFromTableView
            firstController?.timerLabel.text = "\(firstController?.timeString(time: secondsFromTableView)))"
        }
    }

    var firstController: TimerViewController?
    var secondController: WorckingOutTableTableViewController?

    weak var delegateCustom: PassDataFromTabBarToTimer?
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        delegateCustom?.passingSeconds(seconds: Double(item.tag))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setingsOfTebleView()

        firstController = TimerViewController()
        secondController = WorckingOutTableTableViewController()

        secondController?.delegate = self

        let nc = UINavigationController(rootViewController: secondController!)
        
        firstController?.tabBarItem.title = "Timer"
        nc.tabBarItem.title = "Program"


        viewControllers = [firstController, nc] as? [UIViewController]

    }

    fileprivate func setingsOfTebleView() {
        tabBar.backgroundColor = .red
        tabBar.layer.cornerRadius = 40
        tabBar.layer.borderWidth = 2
        tabBar.layer.borderColor = UIColor.purple.cgColor
        tabBar.barTintColor = .white
        tabBar.isTranslucent = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
        tabBar.layer.masksToBounds = false
    }

}

extension CustomTabBarController: PassDataFromTableControllerToTabBar {
    func passingSeconds(seconds: Double) {
        secondsFromTableView = seconds
        print("\(secondsFromTableView)")
    }
}
