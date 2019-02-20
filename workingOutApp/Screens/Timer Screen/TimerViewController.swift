//
//  MainViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 12/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox
import UserNotifications

class TimerViewController: UIViewController {

    var timerView = TimerView()
    var timerModel: TimerModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        timerModel.delegate = timerView
        timerModel.refreshExercises()
        view.addSubview(timerView)
        timerView.fillSuperview()
        timerView.setupSubViews()
        setupButtons()
    }

    func setupButtons() {
        timerView.startButton.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
        timerView.nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        timerView.stopButton.addTarget(self, action: #selector(handleStopButton), for: .touchUpInside)
    }

    @objc func handleStartButton() {
        timerModel.handleStartButton()
    }

    @objc func handleNextButton() {
        timerModel.indexOfSets += 1
        timerModel.switchNextExerciseOrSet()
        timerModel.isBreak = true
        timerView.nextButton.isEnabled = false
        timerView.circleStatusView.value = 1
    }

    @objc func handleStopButton() {
        timerModel.timer.invalidate()
        dismiss(animated: true)
    }
}


