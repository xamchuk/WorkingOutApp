//
//  TimerButton.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 13/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class TimerButton: UIButton {


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var firstLoad = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if firstLoad {
           setupLayer(frame: frame)
        }
    }

    private func setup() {
        titleLabel?.adjustsFontSizeToFitWidth = true
        translatesAutoresizingMaskIntoConstraints = false
        setTitle("Start", for: .normal)
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle)
        backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
    }
    
     private func setupLayer(frame: CGRect) {
        layer.cornerRadius = frame.width / 2
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
    }
}
