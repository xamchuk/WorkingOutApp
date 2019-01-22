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
        layer.borderWidth = 1
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
