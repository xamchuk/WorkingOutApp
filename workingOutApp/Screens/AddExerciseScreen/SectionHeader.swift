//
//  SectionHeader.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 21/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {

    let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        setupNameLabel()
    }

    fileprivate func setupNameLabel() {
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .mainDark
        nameLabel.layer.cornerRadius = 10
        let style  = UIFont.TextStyle.headline
        nameLabel.font = UIFont.preferredFont(forTextStyle: style)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = .white
        nameLabel.layer.masksToBounds = true
        nameLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
