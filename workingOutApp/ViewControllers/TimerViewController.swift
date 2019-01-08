//
//  TimerViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    var widthOfTimerView: CGFloat!
    var heightOfTimerView: CGFloat!
    var cornerRadius: CGFloat!
    let shapeLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    let strokeLines = CAShapeLayer()
    let borderWidthOfTimerView: CGFloat = 2
    let colorStroke: CGColor = UIColor.gray.cgColor

    

    var isRunning = false
    var secondsTimer: Double = 10
    var startSeconds: Double = 10
    var startValue: Double = 100

    var timer = Timer()
    
    

    var level: CGFloat = 1 {
        didSet {
            if level < 0.5 {
                shapeLayer.strokeColor = UIColor.purple.cgColor
            } else {
                shapeLayer.strokeColor = UIColor.green.cgColor
            }
        }
    }

    let screenImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "screen")
        image.contentMode = .scaleAspectFill
        return image
    }()


    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.text = "00:00:00"
        return label
    }()

    lazy var timerView: UIView = {
        let timerview = UIView()
        timerview.layer.cornerRadius = cornerRadius
        let path = UIBezierPath()
        path.move(to: CGPoint(x: widthOfTimerView / 2, y: heightOfTimerView))
        path.addLine(to: CGPoint(x: widthOfTimerView / 2, y: 0))
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = widthOfTimerView

        timerview.layer.addSublayer(shapeLayer)
        timerview.backgroundColor = .clear
        timerview.layer.borderColor = colorStroke
        timerview.layer.borderWidth = borderWidthOfTimerView
        timerview.layer.masksToBounds = true
        timerview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:))))

        let strokePath = UIBezierPath()

        var y: CGFloat = 0
        for i in 0...10 {
            y = y + (heightOfTimerView / 10 / 2)
            strokePath.move(to: CGPoint(x: 0, y: y + y))
            strokePath.addLine(to: CGPoint(x: widthOfTimerView, y: y + y))
        }

        strokeLines.path = strokePath.cgPath
        strokeLines.lineWidth = borderWidthOfTimerView
        strokeLines.strokeColor = colorStroke
        timerview.layer.addSublayer(strokeLines)
        return timerview
    }()

    lazy var startButton: UIButton = {
        let button = UIButton.init(type: .roundedRect)
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        button.layer.borderColor = colorStroke
        button.layer.borderWidth = borderWidthOfTimerView
        button.layer.cornerRadius = cornerRadius
        button.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
        return button
    }()




    override func viewDidLoad() {
        super.viewDidLoad()

        setupVisualEffects()
        setupReusebleConstraints()
        setupViews()
        
    }

    fileprivate func setupReusebleConstraints() {
        heightOfTimerView = view.frame.height / 3
        widthOfTimerView = view.frame.width / 4
        cornerRadius = widthOfTimerView / 3
    }

    // TODO: redraw layauts when oriontation has changed ???

    fileprivate func setupVisualEffects() {

        view.addSubview(screenImage)
        screenImage.fillSuperview()

        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 1
        view.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
    }

    fileprivate func setupViews() {

        view.addSubview(timerView)
        timerView.centerInSuperview(size: CGSize(width: widthOfTimerView, height: heightOfTimerView))

        view.addSubview(timerLabel)
        timerLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: timerView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 24, right: 16))

        view.addSubview(startButton)
        startButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 48, right: 0), size: CGSize(width: heightOfTimerView, height: widthOfTimerView / 1.2))
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let percent = translation.y / timerView.bounds.height

        level = max(0, min(1, shapeLayer.strokeEnd - percent))

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        shapeLayer.strokeEnd = level
        CATransaction.commit()

        gesture.setTranslation(.zero, in: gesture.view)
    }


    @objc func handleStartButton(_ sender: UIButton) {
        if !isRunning {
            startValue = 100 / startSeconds
             timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)

            startButton.setTitle("Pause", for: .normal)

        } else if secondsTimer > 0 && isRunning {
            timer.invalidate()
            startButton.setTitle("Start", for: .normal)
        }
        
        isRunning = !isRunning
    }
    @objc func updateTimer() {
        if secondsTimer >= 0 {
            timerLabel.text = timeString(time: TimeInterval(secondsTimer)) //This will update the label.
            secondsTimer -= 1
            let newValue: Double = startValue * secondsTimer / 100
            level = CGFloat(newValue)
            shapeLayer.strokeEnd = level


        } else {
            timer.invalidate()
            startButton.setTitle("Start", for: .normal)
        }
    }
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

