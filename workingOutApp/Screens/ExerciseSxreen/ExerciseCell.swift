//
//  WorkingOutProgrammCell.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {

    let view = UIView()
    let imageViewOfExersice = UIImageView()
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
        roundsLabel.text = "\(item.sets?.count ?? 0) reps"
        groupLabel.text = "\(item.group ?? " Group is unknown")"
        imageViewOfExersice.image = UIImage(named: item.group ?? "")
//        if let imageData = item.imageData {
//            imageViewOfExersice.image = UIImage(data: imageData as Data)
//        } else if let imageURL = item.imageURL {
//            imageViewOfExersice.downloaded(from: imageURL) { [weak self] (data) in
//                self?.item?.imageData = data as NSData
//            }
//        } else  if let image = item.imageName {
//            imageViewOfExersice.image = UIImage(named: image)
//        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExerciseCell {

    fileprivate func setupViewsInCell() {
        addSubview(view)
        setupView()
        addSubview(imageViewOfExersice)
        setupImageView()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(stackView)
        setupStackView()
        setupRoundsLabel()
        setupGroupLabel()
    }

    fileprivate func setupView() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .blackColor
        view.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 4, bottom: 4, right: 4))
    }

    fileprivate func setupImageView() {
        imageViewOfExersice.contentMode = .scaleAspectFill
        imageViewOfExersice.layer.cornerRadius = 10
        imageViewOfExersice.layer.masksToBounds = true
        imageViewOfExersice.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
        imageViewOfExersice.topAnchor.constraint(equalTo: view.topAnchor, constant: 2),
        imageViewOfExersice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
        imageViewOfExersice.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
        imageViewOfExersice.heightAnchor.constraint(equalToConstant: 75),
        imageViewOfExersice.widthAnchor.constraint(equalToConstant: 75)])
    }

    fileprivate func setupTitleLabel() {
        let style = UIFont.TextStyle.title1
        titleLabel.font = UIFont.preferredFont(forTextStyle: style)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .white
        titleLabel.layer.masksToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageViewOfExersice.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageViewOfExersice.trailingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 4)])
    }

    fileprivate func setupStackView() {
        [roundsLabel, groupLabel].forEach({ stackView.addArrangedSubview($0)})
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: view.bottomAnchor, trailing: titleLabel.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 2, right: 4))
    }

    fileprivate func setupRoundsLabel() {
        roundsLabel.textColor = .white
        let style = UIFont.TextStyle.body
        roundsLabel.font = UIFont.preferredFont(forTextStyle: style)
        groupLabel.adjustsFontSizeToFitWidth = true
    }

    fileprivate func setupGroupLabel() {
        groupLabel.textColor = .mainLight
        let style = UIFont.TextStyle.body
        groupLabel.font = UIFont.preferredFont(forTextStyle: style)
        groupLabel.adjustsFontSizeToFitWidth = true
    }
}
