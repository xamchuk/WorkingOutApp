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
    let topHorizontalLine = LineView()
    let midleHorizontalFirstLine = LineView()
    let midleVerticalLine = LineView()
    let midleHorizontalSecondLine = LineView()
    let bottomVerticalFirstLine = LineView()



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
        titleLabel.text = "\(item?.name ?? "No Name") "
        roundsLabel.text = "\(item?.sets?.count ?? 0) reps"
        groupLabel.text = "\(item?.group ?? " Group is unknown")"

        if let imageData = item?.imageData {
            imageViewOfExersice.image = UIImage(data: imageData as Data)

        } else if let imageURL = item?.imageURL {
            imageViewOfExersice.downloaded(from: imageURL) { [weak self] (data) in
                self?.item?.imageData = data as NSData
            }
        } else  if let image = item?.imageName {
            imageViewOfExersice.image = UIImage(named: image)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExerciseCell {

    fileprivate func setupViewsInCell() {

        addSubview(topHorizontalLine)
        setupTopHorizontalLine()
        addSubview(topVerticalLine)
        setupTopVerticlLine()

        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(midleHorizontalFirstLine)
        setupMidleHorizontalFirstLine()
        addSubview(midleVerticalLine)
        setupMidleVerticalLine()
        addSubview(imageViewOfExersice)
        setupImageView()
        addSubview(midleHorizontalSecondLine)
        setupMidleHorizontalSecondLine()
        addSubview(roundsLabel)
        setupRoundsLabel()
        addSubview(groupLabel)
        setupGroupLabel()
        addSubview(bottomVerticalFirstLine)
        setupBottomVerticalFirstLine()
    }

    fileprivate func setupTopHorizontalLine() {
        NSLayoutConstraint.activate([
            topHorizontalLine.topAnchor.constraint(equalTo: topAnchor),
            topHorizontalLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 58),
            topHorizontalLine.heightAnchor.constraint(equalToConstant: 2),
            topHorizontalLine.trailingAnchor.constraint(equalTo: centerXAnchor)
            ])

    }
    fileprivate func setupTopVerticlLine() {
        NSLayoutConstraint.activate([
            topVerticalLine.topAnchor.constraint(equalTo: topHorizontalLine.topAnchor),
            topVerticalLine.leadingAnchor.constraint(equalTo: topHorizontalLine.trailingAnchor),
            topVerticalLine.widthAnchor.constraint(equalToConstant: 2),
            topVerticalLine.heightAnchor.constraint(equalToConstant: 25)
            ])
    }



    fileprivate func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .linesColor
        titleLabel.layer.cornerRadius = 10
        titleLabel.layer.borderColor = UIColor.linesColor.cgColor
        titleLabel.layer.borderWidth = 1
        let style  = UIFont.TextStyle.title3
        titleLabel.font = UIFont.preferredFont(forTextStyle: style)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .gradientDarker
        titleLabel.layer.masksToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topVerticalLine.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: topVerticalLine.centerXAnchor),
            ])
    }

    fileprivate func setupMidleHorizontalFirstLine() {
        NSLayoutConstraint.activate([
            midleHorizontalFirstLine.topAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            midleHorizontalFirstLine.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            midleHorizontalFirstLine.leadingAnchor.constraint(equalTo: topHorizontalLine.leadingAnchor),
            midleHorizontalFirstLine.heightAnchor.constraint(equalToConstant: 2)
            ])
    }

    fileprivate func setupMidleVerticalLine() {
        NSLayoutConstraint.activate([
            midleVerticalLine.topAnchor.constraint(equalTo: midleHorizontalFirstLine.bottomAnchor),
            midleVerticalLine.leadingAnchor.constraint(equalTo: midleHorizontalFirstLine.leadingAnchor),
            midleVerticalLine.widthAnchor.constraint(equalToConstant: 2),
            midleVerticalLine.heightAnchor.constraint(equalToConstant: 10)
            ])
    }

    fileprivate func setupImageView() {
        imageViewOfExersice.contentMode = .scaleAspectFill
        imageViewOfExersice.layer.cornerRadius = 50
        imageViewOfExersice.layer.borderColor = UIColor.darckOrange.cgColor
        imageViewOfExersice.layer.borderWidth = 4
        imageViewOfExersice.layer.masksToBounds = true
        imageViewOfExersice.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
        imageViewOfExersice.centerXAnchor.constraint(equalTo: midleVerticalLine.centerXAnchor),
        imageViewOfExersice.topAnchor.constraint(equalTo: midleVerticalLine.bottomAnchor),
        imageViewOfExersice.heightAnchor.constraint(equalToConstant: 100),
        imageViewOfExersice.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    fileprivate func setupMidleHorizontalSecondLine() {
        NSLayoutConstraint.activate([
            midleHorizontalSecondLine.centerYAnchor.constraint(equalTo: imageViewOfExersice.centerYAnchor),
            midleHorizontalSecondLine.leadingAnchor.constraint(equalTo: imageViewOfExersice.trailingAnchor),
            midleHorizontalSecondLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            midleHorizontalSecondLine.heightAnchor.constraint(equalToConstant: 2)
            ])
    }



    fileprivate func setupRoundsLabel() {
        roundsLabel.textColor = .textColor
        let style = UIFont.TextStyle.headline
        roundsLabel.font = UIFont.preferredFont(forTextStyle: style)
        roundsLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            roundsLabel.bottomAnchor.constraint(equalTo: midleHorizontalSecondLine.topAnchor, constant: -2),
            roundsLabel.trailingAnchor.constraint(equalTo: midleHorizontalSecondLine.trailingAnchor, constant: 0)
            ])
    }

    fileprivate func setupGroupLabel() {
        groupLabel.textColor = .textColor
        let style = UIFont.TextStyle.headline
        groupLabel.font = UIFont.preferredFont(forTextStyle: style)
        groupLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            groupLabel.topAnchor.constraint(equalTo: midleHorizontalSecondLine.bottomAnchor, constant: 2),
            groupLabel.trailingAnchor.constraint(equalTo: midleHorizontalSecondLine.trailingAnchor, constant: 0)
            ])
    }

    fileprivate func setupBottomVerticalFirstLine() {
        NSLayoutConstraint.activate([
            bottomVerticalFirstLine.topAnchor.constraint(equalTo: imageViewOfExersice.bottomAnchor),
            bottomVerticalFirstLine.centerXAnchor.constraint(equalTo: imageViewOfExersice.centerXAnchor),
            bottomVerticalFirstLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomVerticalFirstLine.heightAnchor.constraint(equalToConstant: 5),
            bottomVerticalFirstLine.widthAnchor.constraint(equalToConstant: 2)
            ])
    }
}
