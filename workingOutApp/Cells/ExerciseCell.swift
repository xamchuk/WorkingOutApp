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

    var item: Item? {
        didSet {
            titleLabel.text = "     \(item?.name ?? "noName") "
            roundsLabel.text = "\(item?.sets?.count ?? 0) reps"
            if let imageData = item?.imageData {
                imageViewOfExersice.image = UIImage(data: imageData as Data)
            } else if let imageURL = item?.imageURL {
                imageViewOfExersice.downloaded(from: imageURL, item: item!)
            } else  if let image = item?.imageName{
                imageViewOfExersice.image = UIImage(named: image)
            }
        }
    }

    weak var delegate: ExerciseCellDelegate?

    let titleLabel = UILabel()
    let roundsLabel = UILabel()
    let imageViewOfExersice = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewsInCell()

        }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewOfExersice.image = nil
        titleLabel.text = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupViewsInCell() {

        addSubview(imageViewOfExersice)
        setupImageView()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(roundsLabel)
        setupRoundsLabel()


    }
    fileprivate func setupImageView() {
        imageViewOfExersice.contentMode = .scaleAspectFill
        imageViewOfExersice.layer.cornerRadius = 50
        imageViewOfExersice.layer.borderColor = UIColor.darckOrange.cgColor
        imageViewOfExersice.layer.borderWidth = 4
        imageViewOfExersice.layer.masksToBounds = true
        imageViewOfExersice.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 8, left: 8, bottom: 8, right: 0), size: .init(width: 100, height: 100))
    }
    fileprivate func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .linesColor
        titleLabel.layer.cornerRadius = 10
        titleLabel.layer.borderColor = UIColor.darckOrange.cgColor
        titleLabel.layer.borderWidth = 1
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .gradientDarker
        titleLabel.layer.masksToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: imageViewOfExersice.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageViewOfExersice.trailingAnchor, constant: -20)
            ])
        sendSubviewToBack(titleLabel)
    }
    fileprivate func setupRoundsLabel() {
        roundsLabel.textColor = .textColor
        roundsLabel.font = UIFont.boldSystemFont(ofSize: 16)
        roundsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([roundsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8), roundsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0)])

    }
}

