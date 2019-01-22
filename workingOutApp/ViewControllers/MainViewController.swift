//
//  MainViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 12/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox


class MainViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedExercisesRC: NSFetchedResultsController<Item>!
    private var fetchedSetsRC: NSFetchedResultsController<Sets>!

    let statusView = UIView()
    let shapeLayerOfStatusView = CAShapeLayer()
    let cyrcleStatusView = UIView()
    var cyrcleShapeStrokeStatus = CAShapeLayer()
    var trackLayer = CAShapeLayer()
    var screenImage = UIImageView()
    var nameOfExcercise = UILabel()
    var breakLabel = UILabel()
    var singleTimerLabel = UILabel()
    var allProgramLabel = UILabel()
    var allTimerLabel = UILabel()
    var startButton = UIButton(type: .system)
    var nextButton = UIButton(type: .system)
    var isLaunched = false

    var startValueOfAllTraining = 0.00
    var array = [Int16]()
    var rounds = Int16(0)
    
    var seconds = 0
    var isBreak = false
    var secondsTimer = 200
    var startValue = 100.00
    var startSeconds = 0
    var isRunning = false
    var level: CGFloat = 0
    var timer = Timer()

    var indexPath = IndexPath(row: 1, section: 0)


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupVisualEffects()
        setupAllViews()
        refreshExercises()
        refreshSets()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(fetchedSetsRC.fetchedObjects?.count)
        print(fetchedExercisesRC.object(at: indexPath))
        print(fetchedExercisesRC.fetchedObjects?.count)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isLaunched {
            isLaunched = true
            statusView.setupSabLayer(shapelayerOfView: shapeLayerOfStatusView, cornerRadius: statusView.frame.height / 2, strokes: array.count, direction: .horizontal)
            setupLayerOfCyrcleView()
        }
    }

    func refreshExercises() {
        let requestExercise = Item.fetchRequest() as NSFetchRequest<Item>
        //       MARK: Filtering coreData
        let queryExercise = ""
        if !queryExercise.isEmpty {
            requestExercise.predicate = NSPredicate(format: "name CONTAINS[cd] %@", queryExercise)
        }
        let sortExercise = NSSortDescriptor(key: #keyPath(Item.group), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        requestExercise.sortDescriptors = [sortExercise]

        do {
            fetchedExercisesRC = NSFetchedResultsController(fetchRequest: requestExercise, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedExercisesRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func refreshSets() {
        let requestSets = Sets.fetchRequest() as NSFetchRequest<Sets>
        let querySets = ""
        if querySets.isEmpty {
            requestSets.predicate = NSPredicate(format: "item = %@", fetchedExercisesRC.object(at: indexPath))
        } else {
            requestSets.predicate = NSPredicate(format: "name CONTAINS[cd] %@ AND item = %@", querySets, fetchedExercisesRC.object(at: indexPath))
        }
        let sortSets = NSSortDescriptor(key: #keyPath(Sets.date), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        requestSets.sortDescriptors = [sortSets]
        do {
            fetchedSetsRC = NSFetchedResultsController(fetchRequest: requestSets, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedSetsRC.performFetch()

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }

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

    @objc func handleNextButton() {
        isBreak = true
    }

    @objc func updateTimer() {
         if secondsTimer >= 0 {
            if seconds == 0 && !isBreak {
                breakLabel.text = "WORK"
                isBreak = true
                AudioServicesPlayAlertSound(1304)
            } else  if seconds == 0 && isBreak {
                breakLabel.text = "REST"
                seconds = 60
                isBreak = false
                print(seconds)
                startValue = 100 / Double(seconds)
                AudioServicesPlayAlertSound(1304)
            }
            seconds -= 1
            singleTimerLabel.text = "\(seconds)"
            allTimerLabel.text = timeString(time: TimeInterval(secondsTimer))
            secondsTimer -= 1
            level = CGFloat(startValue * Double(seconds) / 100)
            print("start Value: \(startValue) --- * \(seconds)")
            cyrcleShapeStrokeStatus.strokeEnd = level
            print(cyrcleShapeStrokeStatus.strokeEnd, "level   ", level)
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

extension MainViewController {

    fileprivate func makeLabel(label: UILabel, text: String, size: CGFloat ) {
        label.font = UIFont.boldSystemFont(ofSize: size)
        label.textAlignment = .center
        label.text = text
        label.textColor = .textColor
        label.layer.shadowColor = UIColor.gradientLighter.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
    }

    fileprivate func setupVisualEffects() {
        view.addSubview(screenImage)
        screenImage.image = UIImage(named: "screen")
        screenImage.contentMode = .scaleAspectFill
        screenImage.fillSuperview()
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.9
        view.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        let viewGradient = UIView()
        viewGradient.alpha = 0.6
        view.addSubview(viewGradient)
        viewGradient.frame = view.frame
        viewGradient.makeGradients()
    }

    fileprivate func setupAllViews() {
        setupStatusView()
        setupStartButton()
        setupCyrcleStatusView()
        setupNextButton()
    }

    fileprivate  func setupStatusView() {
        view.addSubview(statusView)
        statusView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 20))
        statusView.isHidden = true
        view.addSubview(nameOfExcercise)
        nameOfExcercise.anchor(top: statusView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 32))
        makeLabel(label: nameOfExcercise, text: "Press Start", size: 32)
    }

    fileprivate  func setupStartButton() {
        view.addSubview(startButton)
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        startButton.layer.borderColor = UIColor.linesColor.cgColor
        startButton.layer.borderWidth = 5
        startButton.layer.cornerRadius = 50
        startButton.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
        startButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor , trailing: nil, padding: .init(top: 0, left: 0, bottom: 8, right: 0), size: CGSize(width: 100, height: 100))
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.isEnabled = true
    }

    fileprivate func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.setTitle("⇝", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        nextButton.layer.borderColor = UIColor.linesColor.cgColor
        nextButton.layer.borderWidth = 3
        nextButton.layer.cornerRadius = 25
        nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        nextButton.anchor(top: nil, leading: startButton.trailingAnchor, bottom: nil , trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: CGSize(width: 50, height: 50))
        nextButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor).isActive = true

    }

    fileprivate func setupCyrcleStatusView() {
        view.addSubview(cyrcleStatusView)
        cyrcleStatusView.anchor(top: nameOfExcercise.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 24, bottom: 0, right: 24))
        cyrcleStatusView.heightAnchor.constraint(lessThanOrEqualTo: cyrcleStatusView.widthAnchor, multiplier: 1).isActive = true
        let constraint = cyrcleStatusView.bottomAnchor.constraint(equalTo: startButton.topAnchor)
        constraint.priority = UILayoutPriority(rawValue: 998)
        constraint.isActive = true
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

    fileprivate func setupLayerOfCyrcleView() {
        createCircleShapeLayer(viewOfSetup: cyrcleStatusView, shapeLayer: trackLayer, strokeColor: .trackStrokeColor, fillColor: .clear)
        createCircleShapeLayer(viewOfSetup: cyrcleStatusView, shapeLayer: cyrcleShapeStrokeStatus, strokeColor: .outlineStrokeColor, fillColor: .clear)
    }

    fileprivate func createCircleShapeLayer(viewOfSetup: UIView , shapeLayer: CAShapeLayer, strokeColor: UIColor, fillColor: UIColor) {
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.position = CGPoint(x: viewOfSetup.bounds.midX, y: viewOfSetup.bounds.midY)
        let circularPath = UIBezierPath(arcCenter: .zero, radius: viewOfSetup.frame.height / 2 - (shapeLayer.lineWidth / 2), startAngle: (3 * CGFloat.pi / 4), endAngle: (CGFloat.pi / 4), clockwise: true)
        shapeLayer.path = circularPath.cgPath
        viewOfSetup.layer.addSublayer(shapeLayer)
    }
}
