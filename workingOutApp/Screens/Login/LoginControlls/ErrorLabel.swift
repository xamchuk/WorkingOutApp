//
//  ErrorLabel.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 20/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class ErrorLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        textColor = .red
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 15)
        font = UIFont.systemFont(ofSize: 14)
    }


}
