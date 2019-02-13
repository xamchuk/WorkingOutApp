//
//  TimerStatusValuesLabel.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 13/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class TimerStatusValuesLabel: UILabel {

    var style = UIFont.TextStyle.body {
        didSet {
            font = UIFont.preferredFont(forTextStyle: style)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        text = "100"
        adjustsFontSizeToFitWidth = true
        textAlignment = .center
        textColor = .white
        font = UIFont.preferredFont(forTextStyle: style)
        layer.masksToBounds = true
        backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 50).isActive = true
        heightAnchor.constraint(equalToConstant: 25).isActive = true
        layer.cornerRadius = 12.5
    }
}
