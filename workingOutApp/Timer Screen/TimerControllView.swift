//
//  File.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 04/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class TimerControllView: UIView {

    let titleLabel = UILabel()
    let sets = TimerStatusTitlesLabel()
    let repsAndweight = TimerStatusTitlesLabel()
    let stackView = UIStackView()
    let buttonStackView = UIStackView()
    let startButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)
    let stopButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        layer.masksToBounds = true
        layer.borderWidth = 4
        layer.borderColor = UIColor.clear.cgColor
        setupTitle()
        setupButtonsStackView()
        setupStartButton()
        setupNextButton()
        setupStopButton()
        setupStackView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupTitle() {
        addSubview(titleLabel)
        let style  = UIFont.TextStyle.title1
        titleLabel.font = UIFont.preferredFont(forTextStyle: style)
        titleLabel.backgroundColor = .gradientDarker
        titleLabel.textColor = .textColor
        titleLabel.textAlignment = .center
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 5).isActive = true
    }

    fileprivate  func setupStartButton() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.textColor, for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        startButton.backgroundColor = UIColor.gradientDarker
        startButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor, multiplier: 3 / 5, constant: -12).isActive = true
    }

    fileprivate func setupNextButton() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.textAlignment = .center
        nextButton.titleLabel?.numberOfLines = 0
        nextButton.setTitleColor(.textColor, for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        nextButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextButton.backgroundColor = UIColor.gradientDarker
        nextButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor, multiplier: 1 / 5).isActive = true
    }

    fileprivate func setupStopButton() {
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.setTitle("Stop", for: .normal)
        stopButton.titleLabel?.textAlignment = .center
        stopButton.titleLabel?.numberOfLines = 0
        stopButton.setTitleColor(.textColor, for: .normal)
        stopButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        stopButton.titleLabel?.adjustsFontSizeToFitWidth = true
        stopButton.backgroundColor = UIColor.red
        stopButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor, multiplier: 1 / 5).isActive = true
    }

    fileprivate func setupButtonsStackView() {
        addSubview(buttonStackView)
        buttonStackView.spacing = 6
        buttonStackView.distribution = .equalCentering
        buttonStackView.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil , trailing: trailingAnchor, padding: .init(top: 6, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 100))
        [stopButton, startButton, nextButton].forEach { buttonStackView.addArrangedSubview($0) }
    }

    fileprivate func setupStackView() {
        addSubview(stackView)
        stackView.anchor(top: buttonStackView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 6, left: 0, bottom: 0, right: 0))
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.distribution = .fillProportionally
        [sets, repsAndweight].forEach { (i) in stackView.addArrangedSubview(i)}
    }
}
