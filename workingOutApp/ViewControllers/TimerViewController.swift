//
//  TimerViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import AudioToolbox


class TimerViewController: UIViewController {

    var items: [Item]? 
    var widthOfTimerView: CGFloat!
    var heightOfTimerView: CGFloat!
    var cornerRadius: CGFloat!
    let shapeLayerOfTimer = CAShapeLayer()
    let shapeLayerOfStatus = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    let strokeLinesOfTimerView = CAShapeLayer()
    let strokeLinesOfStatus = CAShapeLayer()
    let borderWidthOfTimerView: CGFloat = 2
    let colorStroke: CGColor = UIColor.gray.cgColor
    var isRunning = false


    /// timers vars
    var secondsTimer: Double = 0
    var startSeconds: Double = 0
    var startValue: Double = 100
    var rounds = -1
    var timer = Timer()
    ///
    
    

    var level: CGFloat = 1 {
        didSet {
            if level < 0.5 {
                shapeLayer.strokeColor = UIColor.purple.cgColor
            } else {
                 let redC = UIColor(displayP3Red: 0/255, green: 234/255, blue: 255/255, alpha: 1)
                shapeLayer.strokeColor = redC.cgColor

            }
        }
    }




    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.text = "00:00:00"
        return label
    }()



/////////// shape layer circle

    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!

    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()

    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = view.center
        return layer
    }

    private func setupPercentageLabel() {
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
    }

    private func setupCircleLayers() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .red, fillColor: .clear)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()

        let trackLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: .clear)
        view.layer.addSublayer(trackLayer)

        shapeLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: .clear)

        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }

    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")

        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity

        pulsatingLayer.add(animation, forKey: "pulsing")
    }

    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

        basicAnimation.toValue = 1

        basicAnimation.duration = 2

        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false

        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

    }




    // TODO: redraw layauts when oriontation has changed ???



//////


}

/*

 var shapeLayer: CAShapeLayer!
 var pulsatingLayer: CAShapeLayer!

 let percentageLabel: UILabel = {
 let label = UILabel()
 label.text = "Start"
 label.textAlignment = .center
 label.font = UIFont.boldSystemFont(ofSize: 32)
 label.textColor = .white
 return label
 }()



 private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
 let layer = CAShapeLayer()
 let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
 layer.path = circularPath.cgPath
 layer.strokeColor = strokeColor.cgColor
 layer.lineWidth = 20
 layer.fillColor = fillColor.cgColor
 layer.lineCap = CAShapeLayerLineCap.round
 layer.position = view.center
 return layer
 }

 override func viewDidLoad() {
 super.viewDidLoad()

 setupCircleLayers()

 setupPercentageLabel()
 }

 private func setupPercentageLabel() {
 view.addSubview(percentageLabel)
 percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
 percentageLabel.center = view.center
 }

 private func setupCircleLayers() {
 pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
 view.layer.addSublayer(pulsatingLayer)
 animatePulsatingLayer()

 let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
 view.layer.addSublayer(trackLayer)

 shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)

 shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
 shapeLayer.strokeEnd = 0
 view.layer.addSublayer(shapeLayer)
 }

 private func animatePulsatingLayer() {
 let animation = CABasicAnimation(keyPath: "transform.scale")

 animation.toValue = 1.5
 animation.duration = 0.8
 animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
 animation.autoreverses = true
 animation.repeatCount = Float.infinity

 pulsatingLayer.add(animation, forKey: "pulsing")
 }

 fileprivate func animateCircle() {
 let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

 basicAnimation.toValue = 1

 basicAnimation.duration = 2

 basicAnimation.fillMode = CAMediaTimingFillMode.forwards
 basicAnimation.isRemovedOnCompletion = false

 shapeLayer.add(basicAnimation, forKey: "urSoBasic")
 }



 }



*/
