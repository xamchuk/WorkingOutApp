//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import UIKit

class CircleStatusView: UIView {
    enum Defaults {
        static let trackStrokeColor: UIColor = .textColor
        static let circleStrokeStatusColor: UIColor = .darkOrange
    }

    private let trackLayer = CAShapeLayer()
    private let circleStrokeStatusLayer = CAShapeLayer()

    var trackStrokeColor: UIColor = Defaults.trackStrokeColor {
        didSet {
            trackLayer.strokeColor = trackStrokeColor.cgColor
        }
    }

    var circleStrokeStatusColor: UIColor = Defaults.circleStrokeStatusColor {
        didSet {
            circleStrokeStatusLayer.strokeColor = circleStrokeStatusColor.cgColor
        }
    }

    var value: CGFloat = 0 {
        didSet {
            circleStrokeStatusLayer.strokeEnd = value
        }
    }

    var firstLoad = true
    override func layoutSubviews() {
        super.layoutSubviews()
        if firstLoad {
            setupLayers(frame)
            firstLoad = false
        }
    }

    private func setupLayers(_ frame: CGRect) {
        [trackLayer, circleStrokeStatusLayer].forEach {
            $0.lineWidth = 20
            $0.fillColor = UIColor.clear.cgColor
            $0.lineCap = CAShapeLayerLineCap.round
            $0.position = CGPoint(x: bounds.midX, y: bounds.midY)
            let circularPath = UIBezierPath(arcCenter: .zero, radius: frame.height / 2 - ($0.lineWidth / 2), startAngle: (3 * CGFloat.pi / 4), endAngle: (CGFloat.pi / 4), clockwise: true)
            $0.path = circularPath.cgPath
            layer.addSublayer($0)
        }
        value = 0
        trackStrokeColor = Defaults.trackStrokeColor
        circleStrokeStatusColor = Defaults.circleStrokeStatusColor
    }
}
