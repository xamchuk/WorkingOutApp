//
//  WorkingOutProgrammCell.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

protocol ExerciseCellDelegate: AnyObject {
    func passingSeconds(item: Item)
}

class ExerciseCell: UITableViewCell {

    let topVerticalLine = LineView()
    let midleHorizontalFirstLine = LineView()
    let midleHorizontalSecondLine = LineView()
    let titleLabel = UILabel()
    let roundsLabel = UILabel()
    let groupLabel = UILabel()
    let imageViewOfExersice = UIImageView()
    var item: Item? { didSet { loadImage() } }
    weak var delegate: ExerciseCellDelegate?


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewsInCell()
        }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewOfExersice.image = nil
        titleLabel.text = nil
    }

    fileprivate func loadImage() {
        guard let item = item else { return }
        titleLabel.text = " \(item.name)"
        roundsLabel.text = "\(item.sets?.count ?? 0) reps"
        groupLabel.text = "\(item.group ?? " Group is unknown")"
        if let imageData = item.imageData {
            imageViewOfExersice.image = UIImage(data: imageData as Data)
        } else if let imageURL = item.imageURL {
            imageViewOfExersice.downloaded(from: imageURL) { [weak self] (data) in
                self?.item?.imageData = data as NSData
            }
        } else  if let image = item.imageName {
            imageViewOfExersice.image = UIImage(named: image)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExerciseCell {

    fileprivate func setupViewsInCell() {
        addSubview(topVerticalLine)
        setupTopVerticlLine()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(midleHorizontalFirstLine)
        setupMidleHorizontalFirstLine()
        addSubview(imageViewOfExersice)
        setupImageView()
        addSubview(midleHorizontalSecondLine)
        setupMidleHorizontalSecondLine()
        addSubview(roundsLabel)
        setupRoundsLabel()
        addSubview(groupLabel)
        setupGroupLabel()
        setupBackgroundView()
    }

    fileprivate func setupTopVerticlLine() {
        NSLayoutConstraint.activate([
            topVerticalLine.topAnchor.constraint(equalTo: topAnchor),
            topVerticalLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 58),
            topVerticalLine.widthAnchor.constraint(equalToConstant: 4),
            topVerticalLine.heightAnchor.constraint(equalToConstant: 50)])
    }

    fileprivate func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .darkOrange
        titleLabel.layer.masksToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: topVerticalLine.bottomAnchor, constant: -15),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)])
    }

    fileprivate func setupMidleHorizontalFirstLine() {
        NSLayoutConstraint.activate([
            midleHorizontalFirstLine.topAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            midleHorizontalFirstLine.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            midleHorizontalFirstLine.leadingAnchor.constraint(equalTo: topVerticalLine.leadingAnchor),
            midleHorizontalFirstLine.heightAnchor.constraint(equalToConstant: 2)])
    }

    fileprivate func setupImageView() {
        imageViewOfExersice.contentMode = .scaleAspectFill
        imageViewOfExersice.layer.cornerRadius = 25
        imageViewOfExersice.layer.borderColor = UIColor.linesColor.cgColor
        imageViewOfExersice.layer.borderWidth = 4
        imageViewOfExersice.layer.masksToBounds = true
        imageViewOfExersice.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
        imageViewOfExersice.centerXAnchor.constraint(equalTo: topVerticalLine.centerXAnchor),
        imageViewOfExersice.topAnchor.constraint(equalTo: topVerticalLine.bottomAnchor),
        imageViewOfExersice.bottomAnchor.constraint(equalTo: bottomAnchor),
        imageViewOfExersice.heightAnchor.constraint(equalToConstant: 100),
        imageViewOfExersice.widthAnchor.constraint(equalToConstant: 100)])
    }

    fileprivate func setupMidleHorizontalSecondLine() {
        NSLayoutConstraint.activate([
            midleHorizontalSecondLine.centerYAnchor.constraint(equalTo: imageViewOfExersice.centerYAnchor),
            midleHorizontalSecondLine.leadingAnchor.constraint(equalTo: imageViewOfExersice.trailingAnchor),
            midleHorizontalSecondLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            midleHorizontalSecondLine.heightAnchor.constraint(equalToConstant: 4)])
    }

    fileprivate func setupRoundsLabel() {
        roundsLabel.textColor = .textColor
        let style = UIFont.TextStyle.headline
        roundsLabel.font = UIFont.preferredFont(forTextStyle: style)
        roundsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundsLabel.bottomAnchor.constraint(equalTo: midleHorizontalSecondLine.topAnchor, constant: -2),
            roundsLabel.trailingAnchor.constraint(equalTo: midleHorizontalSecondLine.trailingAnchor, constant: 0)])
    }

    fileprivate func setupGroupLabel() {
        groupLabel.textColor = .darkOrange
        let style = UIFont.TextStyle.headline
        groupLabel.font = UIFont.preferredFont(forTextStyle: style)
        groupLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupLabel.topAnchor.constraint(equalTo: midleHorizontalSecondLine.bottomAnchor, constant: 2),
            groupLabel.trailingAnchor.constraint(equalTo: midleHorizontalSecondLine.trailingAnchor, constant: 0)])
    }

    fileprivate func setupBackgroundView() {
        let backgroundView = UIView()
        backgroundView.alpha = 0.5
        addSubview(backgroundView)
        sendSubviewToBack(backgroundView)
        backgroundView.layer.cornerRadius = 25
        backgroundView.backgroundColor = UIColor.gradientLighter
        backgroundView.anchor(top: titleLabel.topAnchor, leading: imageViewOfExersice.leadingAnchor, bottom: imageViewOfExersice.bottomAnchor, trailing: midleHorizontalSecondLine.trailingAnchor, padding: .init(top: 0, left: -4, bottom: 0, right: -4))
    }
}
