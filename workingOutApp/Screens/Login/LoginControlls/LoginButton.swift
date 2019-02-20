//
//  LoginButton.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 20/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    var attributedTitle = "" {
        didSet {
            let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: attributedTitle, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.white]))
            setAttributedTitle(attributedString, for: .normal)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupButton() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.mainLight.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}
