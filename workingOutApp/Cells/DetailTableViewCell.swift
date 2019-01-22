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
    
    //var index = 0
    //var sets = [Sets]()
    var set: Sets? {
        didSet {
            guard let set = set else { return }
            repeatsNumberLabel.text = "\(set.repeats)"
            weightTextLabel.text = "\(set.weight)"
        }
    }

    let verticalStrokeView = UIView()
    let numberLabel = UILabel()
    var repeatsNumberLabel = UILabel() 
    let repeatsLabel = UILabel()
    let weightTextLabel = UILabel()
    let weightLabel = UILabel()
    let restImageView = UIImageView()
    let restLabel = UILabel()
    let pickerView = UIPickerView()


    var repsIntegers: [String] = []
    var weightDoubles: [String] = []
    var pickerData: [[String]] = [[]]
    var heightOfComponent: CGFloat = 30
    var widthOfComponentsTitles: CGFloat = 80
    var widhtOfComponentsNumbers: CGFloat = 40


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        pickerView.delegate = self
    }

    fileprivate func setupUI() {
        addSubview(verticalStrokeView)
        setupVerticalStroke()
        addSubview(numberLabel)
        setupNumberOfSetLabel()
        addSubview(repeatsNumberLabel)
        setupRepeatsTextField()
        addSubview(repeatsLabel)
        setupRepeatsLabel()
        addSubview(weightTextLabel)
        setupWeightTextField()
        addSubview(weightLabel)
        setupWeightLabel()
        addSubview(restImageView)
        setupRestImageView()
        addSubview(restLabel)
        setupRestLabel()
        addSubview(pickerView)
        setupPickerView()

        makeVarsForPicker()
    }
    func makeVarsForPicker() {
        var reps: Int = 0
        for _ in 0..<50 {
            reps += 1
            repsIntegers.append("\(reps)")
        }

        var weight: Double = 0
        for _ in 0..<50 {
            weight += 2.5
            weightDoubles.append("\(weight)")
        }
        pickerData = [[" Reps"], repsIntegers, ["Weight"], weightDoubles]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            repeatsNumberLabel.text = pickerData[component][row]
        } else {
            weightTextLabel.text = pickerData[component][row]
        }
        set?.repeats = Int16(repeatsNumberLabel.text!)!
        set?.weight = Double(weightTextLabel.text!)!
        appDelegate.saveContext()
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if component == 1 || component == 3 {
            let numbersView = UIView(frame: CGRect(x: 0, y: 0, width: widhtOfComponentsNumbers, height: heightOfComponent))
            let label = UILabel(frame: numbersView.frame)
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: heightOfComponent - 2)
            label.adjustsFontSizeToFitWidth = true
            label.textColor = .darckOrange
            label.text = pickerData[component][row]
            numbersView.addSubview(label)
            return numbersView
        } else {
            let titlesView = UIView(frame: CGRect(x: 0, y: 0, width: widthOfComponentsTitles, height: heightOfComponent))
            let label = UILabel(frame: titlesView.frame)
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: heightOfComponent - 2)
            label.adjustsFontSizeToFitWidth = true
            label.textColor = .textColor
            label.text = pickerData[component][row]
            titlesView.addSubview(label)
            return titlesView
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 1 || component == 3 {
            return widthOfComponentsTitles + 2
        } else {
            return widhtOfComponentsNumbers + 2
        }
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
        repeatsNumberLabel.font = UIFont.boldSystemFont(ofSize: 32)
        repeatsNumberLabel.textColor = .textColor
        repeatsNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            repeatsNumberLabel.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            repeatsNumberLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 24)])
    }

    fileprivate func setupRepeatsLabel() {
        repeatsLabel.text = "repeats   /"
        repeatsLabel.textColor = .textColor
        repeatsLabel.font = UIFont.systemFont(ofSize: 24)
        repeatsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            repeatsLabel.centerYAnchor.constraint(equalTo: repeatsNumberLabel.centerYAnchor),
            repeatsLabel.leadingAnchor.constraint(equalTo: repeatsNumberLabel.trailingAnchor, constant: 8)])
    }

    fileprivate func setupWeightTextField() {
        weightTextLabel.text = "100"
        weightTextLabel.textColor = .textColor
        weightTextLabel.font = UIFont.boldSystemFont(ofSize: 32)
        weightTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weightTextLabel.centerYAnchor.constraint(equalTo: repeatsLabel.centerYAnchor),
            weightTextLabel.leadingAnchor.constraint(equalTo: repeatsLabel.trailingAnchor, constant: 24)])
    }

    fileprivate func setupWeightLabel() {
        weightLabel.text = "kilos"
        weightLabel.textColor = .textColor
        weightLabel.font = UIFont.systemFont(ofSize: 24)
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weightLabel.centerYAnchor.constraint(equalTo: weightTextLabel.centerYAnchor),
            weightLabel.leadingAnchor.constraint(equalTo: weightTextLabel.trailingAnchor, constant: 8)])
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

    fileprivate func setupPickerView() {
        pickerView.tintColor = .gradientDarker
        pickerView.layer.cornerRadius = 20
        pickerView.contentMode = .center
        pickerView.anchor(top: restLabel.bottomAnchor, leading: verticalStrokeView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 24, bottom: 8, right: 24))
        pickerView.isHidden = true
    }
}



