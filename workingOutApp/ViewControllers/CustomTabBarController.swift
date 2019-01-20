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
    var secondController: ExerciseTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setingsOfTebleView()
        let testMainController = MainViewController()
        self.testMainController = testMainController
        let secondController = ExerciseTableViewController()
        self.secondController = secondController
        secondController.delegate = self
        let nc = UINavigationController(rootViewController: secondController)
        testMainController.tabBarItem.title = "Timer"
        testMainController.tabBarItem.image = UIImage(named: "timer")
        nc.tabBarItem.title = "Exercise"
        nc.tabBarItem.image = UIImage(named: "fitness")
        viewControllers = [nc, testMainController]
    }

    fileprivate func setingsOfTebleView() {
        tabBar.barTintColor = .gradientLighter
        tabBar.tintColor = .textColor
    }
}

extension CustomTabBarController: PassDataFromTableControllerToTabBar {
    func passingProgram(program: [Item]) {
        var seconds: Int16 = 0
        for i in program {
            guard let i = i.sets else { return }
                for rep in i {
                    let sec = (rep as! Sets).repeats * 3
                    seconds += sec + 60
                }

        }
        testMainController?.timer.invalidate()
        testMainController?.items = program
        testMainController?.secondsTimer = Int(seconds)
    }
}
