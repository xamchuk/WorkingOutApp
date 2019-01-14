//
//  CustomTabBarController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    var testMainController: MainViewController?
    var firstController: TimerViewController?
    var secondController: WorckingOutTableTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setingsOfTebleView()

        let testMainController = MainViewController()
        self.testMainController = testMainController

        let firstController = TimerViewController()
        self.firstController = firstController
        let secondController = WorckingOutTableTableViewController()
        self.secondController = secondController
        secondController.delegate = self
        let nc = UINavigationController(rootViewController: secondController)
        testMainController.tabBarItem.title = "Timer"
        testMainController.tabBarItem.image = UIImage(named: "timer")
        nc.tabBarItem.title = "Program"
        nc.tabBarItem.image = UIImage(named: "fitness")


        viewControllers = [testMainController, nc]
    }

    fileprivate func setingsOfTebleView() {
        tabBar.layer.borderColor = UIColor.purple.cgColor
       // UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
        tabBar.layer.masksToBounds = false
    }
}

extension CustomTabBarController: PassDataFromTableControllerToTabBar {
    func passingProgram(program: [Item]) {
        var secondsArray: [Double]  = []
        for i in program {
            let sec = (Double(i.rounds) * 60) + ((Double(i.amount) * 3 + 10) * Double(i.rounds))
            secondsArray.append(sec)
        }
        var seconds = 0.00
        for i in secondsArray {
            seconds += i
        }
        testMainController?.items = program
        testMainController?.secondsTimer = Int(seconds)
//        firstController?.secondsTimer = seconds
//        firstController?.startSeconds = seconds
       // firstController?.timerLabel.text = "\(firstController?.timeString(time: seconds) ?? "00:00:00")"
    }
}
