//
//  LoginTextField.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 20/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {

    var placeholderString = "" {
        didSet {
            let placeholder = NSMutableAttributedString(attributedString:
                NSAttributedString(string: placeholderString,
                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                                                .foregroundColor: UIColor(white: 1, alpha: 0.7)]))
            attributedPlaceholder = placeholder
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTextField() {
        borderStyle = .none
        layer.cornerRadius = 5
        backgroundColor = UIColor.rgb(r: 216, g: 216, b: 216, a: 0.2)
        textColor = UIColor(white: 0.9, alpha: 0.8)
        font = UIFont.systemFont(ofSize: 17)
        autocorrectionType = .no
        setLeftPaddingPoints(10)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

}
