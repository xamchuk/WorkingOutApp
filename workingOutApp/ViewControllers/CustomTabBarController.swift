//
//  CustomTabBarController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    // MARK: I've not used protocols to pass data from tabBar to Timer. Couldn't figure out how to do that. 


    var firstController: TimerViewController?
    var secondController: WorckingOutTableTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setingsOfTebleView()

        let firstController = TimerViewController()
        self.firstController = firstController

        let secondController = WorckingOutTableTableViewController()
        self.secondController = secondController

        secondController.delegate = self

        let nc = UINavigationController(rootViewController: secondController)
        
        firstController.tabBarItem.title = "Timer"
        nc.tabBarItem.title = "Program"


        viewControllers = [firstController, nc]


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
        firstController?.secondsTimer = seconds
        firstController?.startSeconds = seconds
        firstController?.timerLabel.text = "\(firstController?.timeString(time: seconds) ?? "00:00:00")"
    }
}
