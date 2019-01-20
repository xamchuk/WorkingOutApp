//
//  DetailTableViewCell.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var set: Sets? {
        didSet {
            guard let set = set else { return }
            repeatsTextField.text = "\(set.repeats)"
            weightTextField.text = "\(set.weight)"
        }
    }

    var verticalStrokeView = UIView()
    var numberLabel = UILabel()
    var repeatsTextField = UITextField()
    var repeatsLabel = UILabel()
    var weightTextField = UITextField()
    var weightLabel = UILabel()
    var restImageView = UIImageView()
    var restLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    fileprivate func setupUI() {
        addSubview(verticalStrokeView)
        setupVerticalStroke()
        addSubview(numberLabel)
        setupNumberOfSetLabel()
        addSubview(repeatsTextField)
        setupRepeatsTextField()
        addSubview(repeatsLabel)
        setupRepeatsLabel()
        addSubview(weightTextField)
        setupWeightTextField()
        addSubview(weightLabel)
        setupWeightLabel()
        addSubview(restImageView)
        setupRestImageView()
        addSubview(restLabel)
        setupRestLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailTableViewCell {

    fileprivate func setupVerticalStroke() {
        verticalStrokeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStrokeView.topAnchor.constraint(equalTo: topAnchor),
            verticalStrokeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            verticalStrokeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            verticalStrokeView.widthAnchor.constraint(equalToConstant: 2)
            ])
        verticalStrokeView.layer.borderWidth = 2
        verticalStrokeView.layer.borderColor = UIColor.linesColor.cgColor
    }

    fileprivate func setupNumberOfSetLabel() {
        numberLabel.textAlignment = .center
        numberLabel.backgroundColor = .linesColor
        numberLabel.layer.cornerRadius = 10
        numberLabel.layer.borderColor = UIColor.linesColor.cgColor
        numberLabel.layer.borderWidth = 1
        numberLabel.font = UIFont.boldSystemFont(ofSize: 20)
        numberLabel.textColor = .gradientDarker
        numberLabel.layer.masksToBounds = true
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: verticalStrokeView.centerXAnchor),
            numberLabel.topAnchor.constraint(equalTo: verticalStrokeView.topAnchor, constant: 16),
            numberLabel.widthAnchor.constraint(equalToConstant: 30),
            numberLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
    }

    fileprivate func setupRepeatsTextField() {
        repeatsTextField.font = UIFont.boldSystemFont(ofSize: 32)
        repeatsTextField.textColor = .textColor
        repeatsTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            repeatsTextField.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            repeatsTextField.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 24)])
    }

    fileprivate func setupRepeatsLabel() {
        repeatsLabel.text = "repeats   /"
        repeatsLabel.textColor = .textColor
        repeatsLabel.font = UIFont.systemFont(ofSize: 24)
        repeatsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            repeatsLabel.centerYAnchor.constraint(equalTo: repeatsTextField.centerYAnchor),
            repeatsLabel.leadingAnchor.constraint(equalTo: repeatsTextField.trailingAnchor, constant: 8)])
    }

    fileprivate func setupWeightTextField() {
        weightTextField.text = "100"
        weightTextField.textColor = .textColor
        weightTextField.font = UIFont.boldSystemFont(ofSize: 32)
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weightTextField.centerYAnchor.constraint(equalTo: repeatsLabel.centerYAnchor),
            weightTextField.leadingAnchor.constraint(equalTo: repeatsLabel.trailingAnchor, constant: 24)])
    }

    fileprivate func setupWeightLabel() {
        weightLabel.text = "kilos"
        weightLabel.textColor = .textColor
        weightLabel.font = UIFont.systemFont(ofSize: 24)
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weightLabel.centerYAnchor.constraint(equalTo: weightTextField.centerYAnchor),
            weightLabel.leadingAnchor.constraint(equalTo: weightTextField.trailingAnchor, constant: 8)])
    }

    fileprivate func setupRestImageView() {
        restImageView.image = UIImage(named: "timer")
        restImageView.tintColor = .darckOrange
        restImageView.contentMode = .scaleAspectFill
        restImageView.layer.masksToBounds = false
        restImageView.layer.cornerRadius = 18
        restImageView.backgroundColor = .gradientDarker
        restImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restImageView.centerXAnchor.constraint(equalTo: verticalStrokeView.centerXAnchor),
            restImageView.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 16),
            restImageView.widthAnchor.constraint(equalToConstant: 20),
            restImageView.heightAnchor.constraint(equalToConstant: 20)])
    }

    fileprivate func setupRestLabel() {
        restLabel.text = "Rest 1:00"
        restLabel.font = UIFont.systemFont(ofSize: 16)
        restLabel.textColor = .darckOrange
        restLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restLabel.centerYAnchor.constraint(equalTo: restImageView.centerYAnchor),
            restLabel.leadingAnchor.constraint(equalTo: restImageView.trailingAnchor, constant: 16)])
    }
}
