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
    let circleStatusView = CircleStatusView()
    let screenImage = UIImageView()
    let titleLabel = TimerLabel()
    let breakLabel = TimerLabel()
    let singleTimerLabel = TimerLabel()
    let allProgramLabel = TimerLabel()
    let allTimerLabel = TimerLabel()
    var strokesCount = 0
    var startButton = UIButton(type: .system)
    var nextButton = UIButton(type: .system)
    var stopButton = UIButton(type: .system)
    let timerControllView = TimerControllView()
    var timerModel = TimerModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisualEffects()
        setupAllViews()
        timerModel.coreDataStack = coreDataStack
        timerModel.workout = workout
        timerModel.delegate = self
        timerModel.refreshExercises()
    }

    @objc func handleStartButton(_ sender: UIButton) {
        timerModel.handleStartButton()
    }

    @objc func handleNextButton() {
        timerModel.indexOfSets += 1
        timerModel.switchNextExerciseOrSet()
        timerModel.isBreak = true
        nextButton.isEnabled = false
        titleLabel.isHidden = true
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
// TODO: MAKE VIEW MODEL
extension TimerViewController {

    fileprivate func setupVisualEffects() {
        view.addSubview(screenImage)
        screenImage.image = UIImage(named: "screen")
        screenImage.contentMode = .scaleAspectFill
        screenImage.fillSuperview()
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.9
        view.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        let viewGradient = UIView()
        viewGradient.alpha = 0.6
        view.addSubview(viewGradient)
        viewGradient.frame = view.frame
        viewGradient.makeGradients()
    }

    fileprivate func setupAllViews() {
        setupTitleLabel()
        setupCyrcleStatusView()
        setupExerciseControllView()
    }

    fileprivate  func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 32))
        titleLabel.style = UIFont.TextStyle.largeTitle
    }

    fileprivate func setupCyrcleStatusView() {
        view.addSubview(circleStatusView)
        circleStatusView.anchor(top: titleLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 24, bottom: 0, right: 24))
        circleStatusView.heightAnchor.constraint(lessThanOrEqualTo: circleStatusView.widthAnchor, multiplier: 1).isActive = true
        circleStatusView.addSubview(breakLabel)
        breakLabel.anchor(top: circleStatusView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 28, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        breakLabel.centerXAnchor.constraint(equalTo: circleStatusView.centerXAnchor).isActive = true
        breakLabel.text = "WORK"
        breakLabel.style = UIFont.TextStyle.title2
        circleStatusView.addSubview(singleTimerLabel)
        singleTimerLabel.anchor(top: breakLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        singleTimerLabel.centerXAnchor.constraint(equalTo: circleStatusView.centerXAnchor).isActive = true
        singleTimerLabel.style = UIFont.TextStyle.title1
        circleStatusView.addSubview(allTimerLabel)
        allTimerLabel.anchor(top: nil, leading: nil, bottom: circleStatusView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 40, right: 0))
        allTimerLabel.centerXAnchor.constraint(equalTo: circleStatusView.centerXAnchor).isActive = true
        allTimerLabel.text = "00:00:00"
        allProgramLabel.style = UIFont.TextStyle.title3
        circleStatusView.addSubview(allProgramLabel)
        allProgramLabel.anchor(top: nil, leading: nil, bottom: allTimerLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        allProgramLabel.centerXAnchor.constraint(equalTo: circleStatusView.centerXAnchor).isActive = true
        allProgramLabel.text = "Full Program"
        allProgramLabel.style = UIFont.TextStyle.title2
    }

    fileprivate func setupExerciseControllView() {
        view.addSubview(timerControllView)
        timerControllView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 8, right: 8), size: CGSize(width: 0, height: 200))
        startButton = timerControllView.startButton
        nextButton = timerControllView.nextButton
        nextButton.isEnabled = false
        stopButton = timerControllView.stopButton
        startButton.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(handleStopButton), for: .touchUpInside)
    }
}

extension TimerViewController: TimerDelegate {
    func nextButton(isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
    }

    func refresh(titleOfExercise: String) {
        timerControllView.titleLabel.text = titleOfExercise
    }

    func refresh(sets: String, reps: String, weight: String) {
        timerControllView.sets.text = sets
        timerControllView.repsAndweight.text = reps + weight
    }

    func refresh(title: String, startButtonTitle: String) {
        titleLabel.text = title
        startButton.setTitle(startButtonTitle, for: .normal)
    }

    func refresh(breakTitle: String) {
        breakLabel.text = breakTitle
    }

    func refresh(singleSeconds: String) {
        singleTimerLabel.text = singleSeconds
    }

    func refreshAllSeconds(seconds: Int) {
        allTimerLabel.text = timeString(time: Double(seconds))
    }

    func refresh(strokeEnd: CGFloat) {
        circleStatusView.value = strokeEnd
    }
}
