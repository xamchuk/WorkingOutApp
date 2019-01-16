//
//  MainViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 12/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import AudioToolbox

class MainViewController: UIViewController {

    let statusView = UIView()
    let shapeLayerOfStatusView = CAShapeLayer()
    let cyrcleStatusView = UIView()
    var cyrcleShapeLayer = CAShapeLayer()
    var trackLayer = CAShapeLayer()

    let screenImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "screen")
        image.contentMode = .scaleAspectFill
        return image
    }()

    var nameOfExcercise = UILabel()
    var breakLabel = UILabel()
    var singleTimerLabel = UILabel()
    var allProgramLabel = UILabel()
    var allTimerLabel = UILabel()


    func makeLabel(label: UILabel, text: String, size: CGFloat ) {
        label.font = UIFont.boldSystemFont(ofSize: size)
        label.textAlignment = .center
        label.text = text
    }

    lazy var startButton: UIButton = {
        let button = UIButton.init(type: .roundedRect)
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        button.layer.borderColor = UIColor.trackStrokeColor.cgColor
        button.layer.borderWidth = 5
        button.layer.cornerRadius = 50
        button.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupVisualEffects()
        setupAllViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        statusView.setupSabLayer(shapelayerOfView: shapeLayerOfStatusView, cornerRadius: statusView.frame.height / 2, strokes: array.count, direction: .horizontal)
        setupLayerOfCyrcleView()
    }

    fileprivate func setupVisualEffects() {
        view.addSubview(screenImage)
        screenImage.fillSuperview()
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.9
        view.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
    }

    func setupAllViews() {
        setupStatusView()
        setupStartButton()
        setupCyrcleStatusView()
    }

    func setupStatusView() {
        view.addSubview(statusView)
        statusView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 20))
        statusView.isHidden = true
        view.addSubview(nameOfExcercise)
        nameOfExcercise.anchor(top: statusView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 32))
        makeLabel(label: nameOfExcercise, text: "Press Start", size: 32)
        nameOfExcercise.isHidden = true
    }

    func setupStartButton() {
        view.addSubview(startButton)
        startButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor , trailing: nil, padding: .init(top: 0, left: 0, bottom: 8, right: 0), size: CGSize(width: 100, height: 100))
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.isEnabled = false
    }

    func setupCyrcleStatusView() {
        view.addSubview(cyrcleStatusView)
        cyrcleStatusView.anchor(top: nameOfExcercise.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 24, bottom: 0, right: 24))
        cyrcleStatusView.heightAnchor.constraint(lessThanOrEqualTo: cyrcleStatusView.widthAnchor, multiplier: 1).isActive = true
        let constraint = cyrcleStatusView.bottomAnchor.constraint(equalTo: startButton.topAnchor)
        constraint.priority = UILayoutPriority(rawValue: 998)
        constraint.isActive = true
        //cyrcleStatusView.heightAnchor.constraint(equalTo: cyrcleStatusView.widthAnchor, constant: 0).isActive = true

        cyrcleStatusView.addSubview(breakLabel)
        breakLabel.anchor(top: cyrcleStatusView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 28, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        breakLabel.centerXAnchor.constraint(equalTo: cyrcleStatusView.centerXAnchor).isActive = true
        makeLabel(label: breakLabel, text: "WORK", size: 32)

        cyrcleStatusView.addSubview(singleTimerLabel)
        singleTimerLabel.anchor(top: breakLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        singleTimerLabel.centerXAnchor.constraint(equalTo: cyrcleStatusView.centerXAnchor).isActive = true

        makeLabel(label: singleTimerLabel, text: "00:00", size: 32)


        cyrcleStatusView.addSubview(allTimerLabel)
        allTimerLabel.anchor(top: nil, leading: nil, bottom: cyrcleStatusView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 40, right: 0))
        allTimerLabel.centerXAnchor.constraint(equalTo: cyrcleStatusView.centerXAnchor).isActive = true
        makeLabel(label: allTimerLabel, text: "00:00:00", size: 40)

        cyrcleStatusView.addSubview(allProgramLabel)
        allProgramLabel.anchor(top: nil, leading: nil, bottom: allTimerLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        allProgramLabel.centerXAnchor.constraint(equalTo: cyrcleStatusView.centerXAnchor).isActive = true
        makeLabel(label: allProgramLabel, text: "Full Program", size: 40)
    }

    func setupLayerOfCyrcleView() {
        createCircleShapeLayer(viewOfSetup: cyrcleStatusView, shapeLayer: trackLayer, strokeColor: .trackStrokeColor, fillColor: .clear)
        createCircleShapeLayer(viewOfSetup: cyrcleStatusView, shapeLayer: cyrcleShapeLayer, strokeColor: .outlineStrokeColor, fillColor: .clear)
        //cyrcleShapeLayer.strokeEnd = 0.5
    }
    
    private func createCircleShapeLayer(viewOfSetup: UIView , shapeLayer: CAShapeLayer, strokeColor: UIColor, fillColor: UIColor) {
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.position = CGPoint(x: viewOfSetup.bounds.midX, y: viewOfSetup.bounds.midY)
        let circularPath = UIBezierPath(arcCenter: .zero, radius: viewOfSetup.frame.height / 2 - (shapeLayer.lineWidth / 2), startAngle: (3 * CGFloat.pi / 4), endAngle: (CGFloat.pi / 4), clockwise: true)
        shapeLayer.path = circularPath.cgPath
        viewOfSetup.layer.addSublayer(shapeLayer)
    }
    // TODO: take all vars to up

    var items: [Item]? {
        didSet {
            seconds = 0
            if index != 0 {
                index = 0
            }
            isBreak = false
            guard let items = items else { return }
            array = []
            rounds = 0
            items.forEach { (i) in
                for _ in 0..<i.rounds {
                    array.append(Int16(i.amount * 3 + 10))
                    rounds += i.rounds
                }
            }
            statusView.isHidden = false
            nameOfExcercise.isHidden = false
            statusView.layoutSubviews()

        }
    }

    var startValueOfAllTraining = 0.00

    var array = [Int16]()
    var rounds = Int16(0)
    var index = Int16(0) {
        didSet {
            let newValue = CGFloat(((Double(index - 1) * 100) / Double(array.count)) / 100)
            shapeLayerOfStatusView.strokeEnd = newValue / 2
            guard let items = items else { return }
            if items.count > 1 {
                nameOfExcercise.text = "\(items[Int(index - 1 / rounds)].name)"
            } else {
                nameOfExcercise.text = "\(items[0].name)"
            }

        }
    }
    var seconds = 0 
    var isBreak = false
    var secondsTimer = 0 {
        didSet {
            if secondsTimer <= 0 {
                startButton.isEnabled = false
            } else {
                startButton.isEnabled = true
            }
            allTimerLabel.text = timeString(time: TimeInterval(secondsTimer))
        }
    }
    var startValue = 100.00
    var startSeconds = 0
    var isRunning = false
    var level: CGFloat = 0
    var timer = Timer()

    @objc func handleStartButton(_ sender: UIButton) {
        if !isRunning || secondsTimer == 0 {
            isRunning = true

            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
            startButton.setTitle("Pause", for: .normal)
        } else if secondsTimer > 0 {
            timer.invalidate()
            isRunning = false
            startButton.setTitle("Start", for: .normal)
        }
    }

    @objc func updateTimer() {
         if secondsTimer >= 0 {
            if seconds == 0 && !isBreak && index <= array.count - 1 {
                breakLabel.text = "WORK"
                seconds = Int(array[Int(index)])
                index += 1
                isBreak = true
                startValue = 100 / Double(seconds)
                AudioServicesPlayAlertSound(1304)
            } else  if seconds == 0 && isBreak {
                breakLabel.text = "REST"
                seconds = 60
                isBreak = false
                startValue = 100 / Double(seconds)
                AudioServicesPlayAlertSound(1304)
            }
            seconds -= 1
            singleTimerLabel.text = "\(seconds)"
            allTimerLabel.text = timeString(time: TimeInterval(secondsTimer))
            secondsTimer -= 1
            level = CGFloat(startValue * Double(seconds) / 100)
            cyrcleShapeLayer.strokeEnd = level
        } else {
            timer.invalidate()
            startButton.setTitle("Start", for: .normal)
            isRunning = false
            AudioServicesPlayAlertSound(1304)
        }
    }

    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

