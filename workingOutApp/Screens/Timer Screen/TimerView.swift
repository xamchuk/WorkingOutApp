//
//  TimerView.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 13/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class TimerView: UIView {

    let titleLabel = UILabel()
    let statusStackView = UIStackView()
    let rowStackView = UIStackView()
    let exerciseValue = TimerStatusValuesLabel()
    let setsValue = TimerStatusValuesLabel()
    let repsValue = TimerStatusValuesLabel()
    let weightValue = TimerStatusValuesLabel()
    let circleStatusView = CircleStatusView()
    let breakLabel = TimerLabel()
    let singleTimerLabel = TimerLabel()
    let allProgramTitleLabel = TimerLabel()
    let allTimerCounterLabel = TimerLabel()
    let infoLabel = TimerLabel()
    var startButton = TimerButton(type: .system)
    var nextButton = TimerButton(type: .system)
    var stopButton = TimerButton(type: .system)

    func setupSubViews() {
        setupBackgroundImage()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(statusStackView)
        setupStatusStackView()
        addSubview(circleStatusView)
        setupCircleView()
        addSubview(infoLabel)
        setupInfoLabel()
        addSubview(allProgramTitleLabel)
        setupAllProgramTitleLabel()
        addSubview(allTimerCounterLabel)
        setupAllTimerCounterLabel()
        addSubview(stopButton)
        setupStopButton()
        addSubview(nextButton)
        setupNextButton()
    }

    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

extension TimerView {
    fileprivate func setupBackgroundImage() {
       setBackgroudView()
    }

    fileprivate func setupTitleLabel() {
        let color = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        titleLabel.backgroundColor = color
        titleLabel.layer.cornerRadius = 25
        titleLabel.layer.masksToBounds = true

        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        let style = UIFont.TextStyle.body
        titleLabel.font = UIFont.preferredFont(forTextStyle: style)
       // layer.shadowColor = UIColor.gradientLighter.cgColor
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 50))
    }

    fileprivate func setupStatusStackView() {

        let exerciseLabel = TimerStatusTitlesLabel()
        exerciseLabel.text = "Exercise"
        let setsLabel = TimerStatusTitlesLabel()
        setsLabel.text = "Sets"
        let repsLabel = TimerStatusTitlesLabel()
        repsLabel.text = "Reps"
        let weightLabel = TimerStatusTitlesLabel()
        weightLabel.text = "Kilos"

        statusStackView.distribution = .equalSpacing
        statusStackView.anchor(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: titleLabel.trailingAnchor, padding: .init(top: 4, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 45))

        let exerciseRow = stack(fisrtL: exerciseLabel, secondL: exerciseValue)
        let setsRow = stack(fisrtL: setsLabel, secondL: setsValue)
        let repsRow = stack(fisrtL: repsLabel, secondL: repsValue)
        let weightRow = stack(fisrtL: weightLabel, secondL: weightValue)

        [exerciseRow, setsRow, repsRow, weightRow].forEach { (v) in
            statusStackView.addArrangedSubview(v)
        }
    }
    func stack(fisrtL: UILabel, secondL: UILabel) -> UIStackView {
        let stackView = UIStackView()
        [fisrtL, secondL].forEach( { stackView.addArrangedSubview($0) })
        stackView.axis = .vertical
        return stackView
    }

    fileprivate func setupCircleView() {
        circleStatusView.anchor(top: nil, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 24, bottom: 0, right: 24))
        circleStatusView.heightAnchor.constraint(lessThanOrEqualTo: circleStatusView.widthAnchor, multiplier: 1).isActive = true
        circleStatusView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        circleStatusView.addSubview(breakLabel)
        breakLabel.anchor(top: circleStatusView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 28, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        breakLabel.centerXAnchor.constraint(equalTo: circleStatusView.centerXAnchor).isActive = true
        breakLabel.text = "WORK"
        breakLabel.style = UIFont.TextStyle.title2


        circleStatusView.addSubview(singleTimerLabel)
        singleTimerLabel.anchor(top: breakLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        singleTimerLabel.centerXAnchor.constraint(equalTo: circleStatusView.centerXAnchor).isActive = true
        singleTimerLabel.style = UIFont.TextStyle.title1
        singleTimerLabel.text = "00:00"

        circleStatusView.addSubview(startButton)
        startButton.centerXAnchor.constraint(equalTo: circleStatusView.centerXAnchor).isActive = true
        //startButton.topAnchor.constraint(equalTo: singleTimerLabel.bottomAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: circleStatusView.centerYAnchor).isActive = true

        let heightOfStartButton = startButton.heightAnchor.constraint(equalTo: circleStatusView.widthAnchor, multiplier: 1 / 3)
        heightOfStartButton.isActive = true
        startButton.widthAnchor.constraint(equalTo: startButton.heightAnchor).isActive = true
        startButton.layer.masksToBounds = true
    }

    fileprivate func setupInfoLabel() {
        infoLabel.text = "Press Start"
        infoLabel.anchor(top: nil, leading: circleStatusView.leadingAnchor, bottom: circleStatusView.topAnchor, trailing: circleStatusView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0))
    }


    fileprivate func setupAllProgramTitleLabel() {
        allProgramTitleLabel.anchor(top: nil, leading: nil, bottom: circleStatusView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: -8, right: 0))
        allProgramTitleLabel.centerXAnchor.constraint(equalTo: circleStatusView.centerXAnchor).isActive = true
        allProgramTitleLabel.text = "Full Program"
        allProgramTitleLabel.style = UIFont.TextStyle.title2
    }


    fileprivate func setupAllTimerCounterLabel() {

        allTimerCounterLabel.anchor(top: allProgramTitleLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 40, right: 0))
        allTimerCounterLabel.centerXAnchor.constraint(equalTo: circleStatusView.centerXAnchor).isActive = true
        allTimerCounterLabel.text = "00:00:00"
        allProgramTitleLabel.style = UIFont.TextStyle.title3
    }

    fileprivate func setupNextButton() {
        nextButton.isEnabled = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.anchor(top: allTimerCounterLabel.bottomAnchor, leading: allProgramTitleLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 24, left: 8, bottom: 0, right: 0), size: .init(width: 75, height: 75))
    }

    fileprivate func setupStopButton() {
        stopButton.setTitle("", for: .normal)
        stopButton.tintColor = .mainLight
        stopButton.setImage(UIImage(named: "stop"), for: .normal)
        stopButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stopButton.anchor(top: allTimerCounterLabel.bottomAnchor, leading: nil, bottom: nil, trailing: allProgramTitleLabel.leadingAnchor, padding: .init(top: 24, left: 0, bottom: 0, right: 8), size: .init(width: 75, height: 75))
    }
}

extension TimerView: TimerDelegate {
    func refresh(exerice: String, sets: String, reps: String, weight: String) {
        exerciseValue.text = exerice
        setsValue.text = sets
        repsValue.text = reps
        weightValue.text = weight
    }

    func nextButton(isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
    }

    func refresh(titleOfExercise: String) {
        titleLabel.text = titleOfExercise
    }


    func refresh(infoTitle: String) {
        infoLabel.text = infoTitle
    }
    func refresh(startButtonTitle: String) {
        startButton.setTitle(startButtonTitle, for: .normal)
    }

    func refresh(breakTitle: String) {
        breakLabel.text = breakTitle
    }

    func refresh(singleSeconds: String) {
        singleTimerLabel.text = singleSeconds
    }

    func refreshAllSeconds(seconds: Int) {
        allTimerCounterLabel.text = timeString(time: Double(seconds))
    }

    func refresh(strokeEnd: CGFloat) {
        circleStatusView.value = strokeEnd
    }
}
