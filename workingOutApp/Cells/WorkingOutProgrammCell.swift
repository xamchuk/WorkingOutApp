//
//  WorkingOutProgrammCell.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class WorkingOutProgrammCell: UITableViewCell {

    var seconds = 0.0 {
        didSet {
            delegate?.passingSeconds(seconds: seconds)
        }
    }
    // MARK: I know its not corect. I need to change that...
    var rounds = 0.00  {
        didSet {
            seconds = rounds + amount * stepperOfRounds.value
        }
    }
    var amount = 0.00  {
        didSet {
            seconds = rounds + amount * stepperOfRounds.value
        }
    }

    weak var delegate: DidSetSecondsFromCellToTableController?
    
    let widthOfViewContainerForImage: CGFloat = 125
    let heightOfViewContainerForImage: CGFloat = 125

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Жим Лежа"
        return label
    }()

    let roundsLabel: UILabel = {
        let label = UILabel()
        label.text = "Rounds"
        return label
    }()

    let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Amount"

        return label
    }()

    let roundsNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()

    let amountNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()

    let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight"
        return label
    }()

    let weightNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()

    let stackViewOfMetrics: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.spacing = 16
        stack.axis = .horizontal
        return stack
    }()

    let stackViewOfLabels: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()

    let stackViewOfNumbers: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()

    let stackViewOfSteppers: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()

    lazy var stepperOfRounds: UIStepper = {
        let stepper = UIStepper()
        stepper.addTarget(self, action: #selector(handleStepper), for: UIControl.Event.valueChanged)
        return stepper
    }()

    lazy var stepperOfAmount: UIStepper = {
        let stepper = UIStepper()
        stepper.addTarget(self, action: #selector(handleStepper), for: UIControl.Event.valueChanged)
        return stepper
    }()

    lazy var stepperOfWeight: UIStepper = {
        let stepper = UIStepper()
        stepper.stepValue = 2.5
        stepper.addTarget(self, action: #selector(handleStepper), for: UIControl.Event.valueChanged)
        return stepper
    }()

    lazy var imageViewOfExersice: UIImageView = {
        let imageEx = UIImageView()
        imageEx.image = UIImage(named: "zhim-lezha")
        imageEx.contentMode = .scaleAspectFill
        imageEx.layer.cornerRadius = 16
        imageEx.backgroundColor = .white
        imageEx.layer.borderColor = UIColor.blue.cgColor
        imageEx.layer.borderWidth = 2
        imageEx.layer.masksToBounds = true
        return imageEx
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewsInCell()
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupViewsInCell() {
        addSubview(titleLabel)
        addSubview(imageViewOfExersice)
        addSubview(stackViewOfMetrics)
        [roundsLabel, amountLabel, weightLabel].forEach { stackViewOfLabels.addArrangedSubview($0) }
        [roundsNumberLabel, amountNumberLabel, weightNumberLabel].forEach { stackViewOfNumbers.addArrangedSubview($0) }
        [stepperOfRounds, stepperOfAmount, stepperOfWeight].forEach { stackViewOfSteppers.addArrangedSubview($0) }
        [stackViewOfLabels, stackViewOfNumbers, stackViewOfSteppers].forEach { stackViewOfMetrics.addArrangedSubview($0) }

        stackViewOfMetrics.anchor(top: imageViewOfExersice.topAnchor, leading: imageViewOfExersice.trailingAnchor, bottom: imageViewOfExersice.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 0))

        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 0))

        imageViewOfExersice.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 8, left: 8, bottom: 8, right: 0), size: .init(width: heightOfViewContainerForImage, height: heightOfViewContainerForImage))
    }
    
    @objc func handleStepper(_ sender: UIStepper) {
        // MARK: Its not realy good code. I'll chande it ...
        if sender == stepperOfRounds {
            roundsNumberLabel.text = String(Int(sender.value))
            rounds = (sender.value * 60)
        }
        if sender == stepperOfAmount {
            amountNumberLabel.text = String(Int(sender.value))
            amount = (sender.value * 3)
        }
        if sender == stepperOfWeight {
            weightNumberLabel.text = String("\(sender.value) kg")
        }
    }
}

