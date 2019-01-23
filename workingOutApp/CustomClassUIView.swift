//
//  CustomClassUIView.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 21/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class LineView : UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.linesColor.cgColor
        layer.borderWidth = 3
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class ExerciceControllView: UIView {
    let title = CustomLabel()
    let sets = CustomLabel()
    let repsAndweight = CustomLabel()
    let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        layer.masksToBounds = true
        layer.borderWidth = 4
        layer.borderColor = UIColor.clear.cgColor
        setupTitle()
        setupStackView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupTitle() {
        addSubview(title)
        let style  = UIFont.TextStyle.largeTitle
        title.font = UIFont.preferredFont(forTextStyle: style)
        title.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        title.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.55).isActive = true
    }

    fileprivate func setupStackView() {
        addSubview(stackView)
        stackView.anchor(top: title.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 6, left: 0, bottom: 0, right: 0))
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.distribution = .fillProportionally
        [sets, repsAndweight].forEach { (i) in stackView.addArrangedSubview(i)}
    }
}

class CustomLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        textColor = .textColor
        adjustsFontSizeToFitWidth = true
        let style  = UIFont.TextStyle.body
        font = UIFont.preferredFont(forTextStyle: style)
        backgroundColor = .gradientDarker
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
