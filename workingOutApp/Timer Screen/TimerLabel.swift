//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import UIKit

class TimerLabel: UILabel {

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
        adjustsFontSizeToFitWidth = true
        textAlignment = .center
        textColor = .white
        font = UIFont.preferredFont(forTextStyle: style)
    }
}
