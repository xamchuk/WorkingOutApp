//
//  MainCollectionViewCell.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    let cellImageView = UIImageView()
    let cellTitle = UILabel()
    var isLaunched = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.rgb(r: 0, g: 0, b: 0, a: 0.2)
        setupCellImageView()
        setupCellTitle()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLaunched {
            setupLayers(frame: frame)
            isLaunched.toggle()
        }
    }

    func setupLayers(frame: CGRect) {
        layer.masksToBounds = true
        layer.cornerRadius = frame.width / 8
    }

    fileprivate func setupCellImageView() {
        cellImageView.contentMode = .scaleAspectFill
        addSubview(cellImageView)
        cellImageView.fillSuperview()
    }

    fileprivate func setupCellTitle() {
        let style = UIFont.TextStyle.body
        cellTitle.backgroundColor = UIColor.rgb(r: 0, g: 0, b: 0, a: 0.6)
        cellTitle.textAlignment = .center
        cellTitle.font = UIFont.preferredFont(forTextStyle: style)
        cellTitle.textColor = .white
        cellTitle.adjustsFontSizeToFitWidth = true
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        cellTitle.numberOfLines = 0
        addSubview(cellTitle)
        NSLayoutConstraint.activate([
            cellTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            cellTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellTitle.widthAnchor.constraint(equalTo: widthAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
