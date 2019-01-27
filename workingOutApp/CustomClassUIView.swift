//
//  CustomClassUIView.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 21/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class LineView : UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.linesColor.cgColor
        layer.borderWidth = 3
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class ExerciceControllView: UIView {
    let title = CustomLabel()
    let sets = CustomLabel()
    let repsAndweight = CustomLabel()
    let stackView = UIStackView()

    let buttonStackView = UIStackView()
    let startButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)
    let resetButton = UIButton(type: .system)

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
        setupResetButton()
        setupStackView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupTitle() {
        addSubview(title)
        let style  = UIFont.TextStyle.largeTitle
        title.font = UIFont.preferredFont(forTextStyle: style)
        title.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        title.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 5).isActive = true
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

    fileprivate func setupResetButton() {
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.textAlignment = .center
        resetButton.titleLabel?.numberOfLines = 0
        resetButton.setTitleColor(.textColor, for: .normal)
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        resetButton.titleLabel?.adjustsFontSizeToFitWidth = true
        resetButton.backgroundColor = UIColor.gradientDarker
        resetButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor, multiplier: 1 / 5).isActive = true
    }

    fileprivate func setupButtonsStackView() {
        addSubview(buttonStackView)
        buttonStackView.spacing = 6
        buttonStackView.distribution = .equalCentering
        buttonStackView.anchor(top: title.bottomAnchor, leading: leadingAnchor, bottom: nil , trailing: trailingAnchor, padding: .init(top: 6, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 100))
        [resetButton, startButton, nextButton].forEach { buttonStackView.addArrangedSubview($0) }
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

class CustomLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        textColor = .textColor
        adjustsFontSizeToFitWidth = true
        let style  = UIFont.TextStyle.body
        font = UIFont.preferredFont(forTextStyle: style)
        backgroundColor = .gradientDarker
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
