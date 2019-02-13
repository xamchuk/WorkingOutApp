//
//  TimerStatusNameLabel.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 13/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class TimerStatusTitlesLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        textAlignment = .center
        textColor = .white
        font = UIFont.systemFont(ofSize: 12)
    }

}
