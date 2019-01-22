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
        nameLabel.backgroundColor = .linesColor
        nameLabel.layer.cornerRadius = 10
        nameLabel.layer.borderColor = UIColor.linesColor.cgColor
        nameLabel.layer.borderWidth = 1
        let style  = UIFont.TextStyle.title3
        nameLabel.font = UIFont.preferredFont(forTextStyle: style)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = .gradientDarker
        nameLabel.layer.masksToBounds = true
        nameLabel.centerInSuperview()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
