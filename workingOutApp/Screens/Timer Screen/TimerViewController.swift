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

    var coreDataStack: CoreDataStack!
    var workout: Workouts?
    var timerView = TimerView()
    var timerModel = TimerModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        timerModel.coreDataStack = coreDataStack
        timerModel.workout = workout
        timerModel.delegate = self
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
        dismiss(animated: true)
    }


    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

extension TimerViewController: TimerDelegate {
    func refresh(exerice: String, sets: String, reps: String, weight: String) {
        timerView.exerciseValue.text = exerice
        timerView.setsValue.text = sets
        timerView.repsValue.text = reps
        timerView.weightValue.text = weight
    }

    func nextButton(isEnabled: Bool) {
        timerView.nextButton.isEnabled = isEnabled
    }

    func refresh(titleOfExercise: String) {
        timerView.titleLabel.text = titleOfExercise
    }


    func refresh(title: String, startButtonTitle: String) {
        timerView.startButton.setTitle(startButtonTitle, for: .normal)
    }

    func refresh(breakTitle: String) {
       timerView.breakLabel.text = breakTitle
    }

    func refresh(singleSeconds: String) {
        timerView.singleTimerLabel.text = singleSeconds
    }

    func refreshAllSeconds(seconds: Int) {
        timerView.allTimerCounterLabel.text = timeString(time: Double(seconds))
    }

    func refresh(strokeEnd: CGFloat) {
        timerView.circleStatusView.value = strokeEnd
    }
}
