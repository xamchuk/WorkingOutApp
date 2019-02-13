//
//  WorkingOutProgrammCell.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {

    let topVerticalLine = LineView()
    let imageViewOfExersice = UIImageView()
    let bottomVerticalLine = LineView()
    let bodyView = UIView()
    let titleLabel = UILabel()
    let stackView = UIStackView()
    let roundsLabel = UILabel()
    let groupLabel = UILabel()
    var item: Item? { didSet { loadImage() } }

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
        roundsLabel.text = "\(item.sets?.count ?? 0) reps  ||"
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
        addSubview(imageViewOfExersice)
        setupImageView()
        addSubview(bottomVerticalLine)
        setupBottomVerticlLine()
        addSubview(bodyView)
        setupBackgroundView()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(stackView)
        setupStackView()
        setupRoundsLabel()
        setupGroupLabel()
    }

    fileprivate func setupTopVerticlLine() {
        NSLayoutConstraint.activate([
            topVerticalLine.topAnchor.constraint(equalTo: topAnchor),
            topVerticalLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 58),
            topVerticalLine.widthAnchor.constraint(equalToConstant: 4),
            topVerticalLine.heightAnchor.constraint(equalToConstant: 10)])
    }

    fileprivate func setupImageView() {
        imageViewOfExersice.contentMode = .scaleAspectFill
        imageViewOfExersice.layer.cornerRadius = 16
        imageViewOfExersice.layer.borderColor = UIColor.linesColor.cgColor
        imageViewOfExersice.layer.borderWidth = 3
        imageViewOfExersice.layer.masksToBounds = true
        imageViewOfExersice.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
        imageViewOfExersice.centerXAnchor.constraint(equalTo: topVerticalLine.centerXAnchor),
        imageViewOfExersice.topAnchor.constraint(equalTo: topVerticalLine.bottomAnchor),
        imageViewOfExersice.heightAnchor.constraint(equalToConstant: 75),
        imageViewOfExersice.widthAnchor.constraint(equalToConstant: 75)])
    }

    fileprivate func setupBottomVerticlLine() {
        NSLayoutConstraint.activate([
            bottomVerticalLine.topAnchor.constraint(equalTo: imageViewOfExersice.bottomAnchor),
            bottomVerticalLine.centerXAnchor.constraint(equalTo: imageViewOfExersice.centerXAnchor),
            bottomVerticalLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomVerticalLine.widthAnchor.constraint(equalToConstant: 4),
            bottomVerticalLine.heightAnchor.constraint(equalToConstant: 10)])
    }

    fileprivate func setupBackgroundView() {
        bodyView.alpha = 0.5
        bodyView.layer.cornerRadius = imageViewOfExersice.layer.cornerRadius
        bodyView.backgroundColor = UIColor.gradientLighter
        bodyView.layer.masksToBounds = true
        bodyView.anchor(top: imageViewOfExersice.topAnchor, leading: imageViewOfExersice.trailingAnchor, bottom: imageViewOfExersice.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 16))
        let tabView = UIView()
        bodyView.addSubview(tabView)
        tabView.backgroundColor = .darkOrange
        tabView.anchor(top: bodyView.topAnchor, leading: nil, bottom: bodyView.bottomAnchor, trailing: bodyView.trailingAnchor, size: CGSize(width: 8, height: 0))
    }

    fileprivate func setupTitleLabel() {
        titleLabel.textAlignment = .center
        let style = UIFont.TextStyle.title3
        titleLabel.font = UIFont.preferredFont(forTextStyle: style)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .darkOrange
        titleLabel.layer.masksToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: bodyView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: bodyView.heightAnchor, multiplier: 0.5)])
    }

    fileprivate func setupStackView() {
        [roundsLabel, groupLabel].forEach({ stackView.addArrangedSubview($0)})
        stackView.distribution = .fillProportionally
        addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, leading: bodyView.leadingAnchor, bottom: bodyView.bottomAnchor, trailing: bodyView.trailingAnchor, padding: .init(top: 2, left: 6, bottom: 2, right: 10))
    }

    fileprivate func setupRoundsLabel() {
        roundsLabel.textColor = .textColor
        let style = UIFont.TextStyle.body
        roundsLabel.font = UIFont.preferredFont(forTextStyle: style)
        groupLabel.adjustsFontSizeToFitWidth = true
    }

    fileprivate func setupGroupLabel() {
        groupLabel.textColor = .darkOrange
        let style = UIFont.TextStyle.body
        groupLabel.font = UIFont.preferredFont(forTextStyle: style)
        groupLabel.adjustsFontSizeToFitWidth = true
    }
}
