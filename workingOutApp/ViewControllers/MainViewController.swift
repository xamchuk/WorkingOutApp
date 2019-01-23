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
    private var fetchedSetsRC: NSFetchedResultsController<Sets>?

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
    var resetButton = UIButton(type: .system)
    let exerciseControllView = ExerciceControllView()
    var isLaunched = false

    var startValueOfAllTraining = 0.00
    var strokesCount = 0
    
    var seconds = 0
    var isBreak = false
    var secondsTimer = 0
    var startValue = 100.00
    var startSeconds = 0
    var isRunning = false
    var level: CGFloat = 0
    var timer = Timer()
    var indexOfExercise = 0
    var indexOfSets = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupVisualEffects()
        setupAllViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        refreshExercises()
        if fetchedExercisesRC.fetchedObjects?.count == 0 {
            return
        } else {
            switchNextExerciseOrSet()
        }

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isLaunched {
            isLaunched = true
            statusView.setupSabLayer(shapelayerOfView: shapeLayerOfStatusView, cornerRadius: statusView.frame.height / 2, strokes: strokesCount, direction: .horizontal)
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

    func refreshSetsAt(exerciseIndex: Int) {
        let requestSets = Sets.fetchRequest() as NSFetchRequest<Sets>

        guard let fetched = fetchedExercisesRC.fetchedObjects else { return }
            requestSets.predicate = NSPredicate(format: "item = %@", fetched[exerciseIndex])
            let sortSets = NSSortDescriptor(key: #keyPath(Sets.date), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
            requestSets.sortDescriptors = [sortSets]
            do {
                fetchedSetsRC = NSFetchedResultsController(fetchRequest: requestSets, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
                try fetchedSetsRC?.performFetch()

            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
    }

    func switchNextExerciseOrSet() {
        guard let items = fetchedExercisesRC.fetchedObjects else { return }
        strokesCount =  items.count
        shapeLayerOfStatusView.strokeEnd = CGFloat((Double(indexOfExercise) / Double(strokesCount)) / 2)
        print(shapeLayerOfStatusView.strokeEnd)
        if indexOfExercise < items.count {
            let item = items[indexOfExercise]
            exerciseControllView.title.text = item.name

            refreshSetsAt(exerciseIndex: indexOfExercise)
            guard let sets = fetchedSetsRC?.fetchedObjects else { return }
            if indexOfSets < sets.count {
                exerciseControllView.sets.text = "Sets: \(indexOfSets + 1) / \(item.sets?.count ?? 0)"
                exerciseControllView.repsAndweight.text = "Reps: \(sets[indexOfSets].repeats) / Weight: \(sets[indexOfSets].weight)"
            } else {
                indexOfSets = 0
                indexOfExercise += 1

                switchNextExerciseOrSet()
            }
        } else {
            timer.invalidate()
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
        indexOfSets += 1
        switchNextExerciseOrSet()
        isBreak = true
        nextButton.isEnabled = false
    }

    @objc func handleResetButton() {

        indexOfSets = 0
        indexOfExercise = 0
        secondsTimer = 0
        seconds = 0
        isBreak = true
        switchNextExerciseOrSet()
    }

    @objc func updateTimer() {
         if secondsTimer >= 0 {
            if seconds == 1 && !isBreak {
                breakLabel.text = "WORK"
                nextButton.isEnabled = true
                AudioServicesPlayAlertSound(1304)
            } else  if seconds == 0 && isBreak {
                breakLabel.text = "REST"
                seconds = 60
                isBreak = false
                startValue = 100 / Double(seconds)

            }
            if seconds > 0 {
                seconds -= 1
            }

            singleTimerLabel.text = "\(seconds)"
            allTimerLabel.text = timeString(time: TimeInterval(secondsTimer))
            secondsTimer += 1
            level = CGFloat(startValue * Double(seconds) / 100)
            cyrcleShapeStrokeStatus.strokeEnd = level
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
        label.adjustsFontSizeToFitWidth = true
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
        setupCyrcleStatusView()
        setupStartButton()
        setupNextButton()
        setupResetButton()
        setupExerciseControllView()
    }

    fileprivate  func setupStatusView() {
        view.addSubview(statusView)
        statusView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 20))
        statusView.isHidden = false
        view.addSubview(nameOfExcercise)
        nameOfExcercise.anchor(top: statusView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 32))
        makeLabel(label: nameOfExcercise, text: "Press Start", size: 32)
    }

    fileprivate func setupCyrcleStatusView() {
        view.addSubview(cyrcleStatusView)
        cyrcleStatusView.anchor(top: nameOfExcercise.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 24, bottom: 0, right: 24))
        cyrcleStatusView.heightAnchor.constraint(lessThanOrEqualTo: cyrcleStatusView.widthAnchor, multiplier: 1).isActive = true
        cyrcleStatusView.addSubview(breakLabel)
        breakLabel.anchor(top: cyrcleStatusView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 28, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        breakLabel.centerXAnchor.constraint(equalTo: cyrcleStatusView.centerXAnchor).isActive = true
        makeLabel(label: breakLabel, text: "WORK", size: 30)
        cyrcleStatusView.addSubview(singleTimerLabel)
        singleTimerLabel.anchor(top: breakLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        singleTimerLabel.centerXAnchor.constraint(equalTo: cyrcleStatusView.centerXAnchor).isActive = true
        makeLabel(label: singleTimerLabel, text: "00:00", size: 30)
        cyrcleStatusView.addSubview(allTimerLabel)
        allTimerLabel.anchor(top: nil, leading: nil, bottom: cyrcleStatusView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 40, right: 0))
        allTimerLabel.centerXAnchor.constraint(equalTo: cyrcleStatusView.centerXAnchor).isActive = true
        makeLabel(label: allTimerLabel, text: "00:00:00", size: 36)
        cyrcleStatusView.addSubview(allProgramLabel)
        allProgramLabel.anchor(top: nil, leading: nil, bottom: allTimerLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        allProgramLabel.centerXAnchor.constraint(equalTo: cyrcleStatusView.centerXAnchor).isActive = true
        makeLabel(label: allProgramLabel, text: "Full Program", size: 36)
    }

    fileprivate  func setupStartButton() {
        view.addSubview(startButton)
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        startButton.layer.borderColor = UIColor.linesColor.cgColor
        startButton.layer.borderWidth = 5
        startButton.layer.cornerRadius = 40
        startButton.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
        startButton.anchor(top: allTimerLabel.bottomAnchor, leading: nil, bottom: nil , trailing: nil, padding: .init(top: view.frame.height / 8, left: 0, bottom: 0, right: 0), size: CGSize(width: 80, height: 80))
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.isEnabled = true
    }

    fileprivate func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.textAlignment = .center
        nextButton.titleLabel?.numberOfLines = 0
        nextButton.setTitleColor(.white, for: .normal)

        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        nextButton.titleLabel?.layer.cornerRadius = 25
        nextButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextButton.layer.borderColor = UIColor.linesColor.cgColor
        nextButton.layer.borderWidth = 3
        nextButton.layer.cornerRadius = 25
        nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        nextButton.anchor(top: nil, leading: startButton.trailingAnchor, bottom: nil , trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: CGSize(width: 50, height: 50))
        nextButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor).isActive = true
    }

    fileprivate func setupResetButton() {
        view.addSubview(resetButton)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.textAlignment = .center
        resetButton.titleLabel?.numberOfLines = 0
        resetButton.setTitleColor(.white, for: .normal)

        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        resetButton.titleLabel?.layer.cornerRadius = 25
        resetButton.titleLabel?.adjustsFontSizeToFitWidth = true
        resetButton.layer.borderColor = UIColor.linesColor.cgColor
        resetButton.layer.borderWidth = 3
        resetButton.layer.cornerRadius = 25
        resetButton.addTarget(self, action: #selector(handleResetButton), for: .touchUpInside)
        resetButton.anchor(top: nil, leading: nil, bottom: nil , trailing: startButton.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: CGSize(width: 50, height: 50))
        resetButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor).isActive = true
    }

    fileprivate func setupExerciseControllView() {
        view.addSubview(exerciseControllView)
        exerciseControllView.anchor(top: startButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }

    fileprivate func setupLayerOfCyrcleView() {
        createCircleShapeLayer(viewOfSetup: cyrcleStatusView, shapeLayer: trackLayer, strokeColor: .textColor, fillColor: .clear)
        createCircleShapeLayer(viewOfSetup: cyrcleStatusView, shapeLayer: cyrcleShapeStrokeStatus, strokeColor: .darkOrange, fillColor: .clear)
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
