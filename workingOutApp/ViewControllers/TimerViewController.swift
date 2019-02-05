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
import UserNotifications

class TimerViewController: UIViewController {

    var coreDataStack: CoreDataStack!
    private var fetchedExercisesRC: NSFetchedResultsController<Item>!
    private var fetchedSetsRC: NSFetchedResultsController<Sets>?
    private let notificationCenter = UNUserNotificationCenter.current()
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var workout: Workouts?
    let statusView = UIView()
    let progressOfExercise = CAShapeLayer()
    let cyrcleStatusView = UIView()
    let cyrcleShapeStrokeStatus = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let screenImage = UIImageView()
    let titleLabel = UILabel()
    let breakLabel = UILabel()
    let singleTimerLabel = UILabel()
    let allProgramLabel = UILabel()
    let allTimerLabel = UILabel()

    var startButton = UIButton(type: .system)
    var nextButton = UIButton(type: .system)
    var resetButton = UIButton(type: .system)
    
    let exerciseControllView = ExerciceControllView()
    var isLaunched = 0
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

        if isLaunched < 2 {
            setupLayerOfCyrcleView()
            isLaunched += 1
        }
        statusView.setupSabLayer(shapelayerOfView: progressOfExercise, cornerRadius: statusView.frame.height / 2, strokes: strokesCount, direction: .horizontal)
    }

    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }

    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }

    func refreshExercises() {
        let requestExercise = Item.fetchRequest() as NSFetchRequest<Item>
        guard let workout = workout else { return }
        requestExercise.predicate = NSPredicate(format: "owner= %@", workout)
        let sortExercise = NSSortDescriptor(key: #keyPath(Item.index), ascending: true)
        requestExercise.sortDescriptors = [sortExercise]
        do {
            fetchedExercisesRC = NSFetchedResultsController(fetchRequest: requestExercise, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedExercisesRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func refreshSetsAt(exerciseIndex: Int) {
        let requestSets = Sets.fetchRequest() as NSFetchRequest<Sets>
        guard let fetched = fetchedExercisesRC.fetchedObjects else { return }
        requestSets.predicate = NSPredicate(format: "item = %@", fetched[exerciseIndex])
        let sortSets = NSSortDescriptor(key: #keyPath(Sets.date), ascending: true)
        requestSets.sortDescriptors = [sortSets]
        do {
            fetchedSetsRC = NSFetchedResultsController(fetchRequest: requestSets, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedSetsRC?.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func switchNextExerciseOrSet() {
        guard let items = fetchedExercisesRC.fetchedObjects else { return }
        strokesCount =  items.count
        progressOfExercise.strokeEnd = CGFloat((Double(indexOfExercise) / Double(strokesCount)) / 2)
        if indexOfExercise < items.count {
            let item = items[indexOfExercise]
            exerciseControllView.titleLabel.text =  item.name

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
            registerBackgroundTask()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
            startButton.setTitle("Pause", for: .normal)
            titleLabel.text = "Do your first set, then press next"
        } else if secondsTimer > 0 {
            timer.invalidate()
            isRunning = false
            endBackgroundTask()
            startButton.setTitle("Resume", for: .normal)
        }
    }

    @objc func handleNextButton() {
        indexOfSets += 1
        switchNextExerciseOrSet()
        isBreak = true
        nextButton.isEnabled = false
        titleLabel.isHidden = true
    }

    @objc func handleStopButton() {
        dismiss(animated: true)
    }

    @objc func updateTimer() {
        if secondsTimer >= 0 {
            if seconds == 1 && !isBreak {
                notificationCentrer()
                breakLabel.text = "WORK"
                singleTimerLabel.text = ""
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
            if seconds == 0 {
                singleTimerLabel.text = ""
            } else {
                singleTimerLabel.text = "\(seconds)"
            }
            allTimerLabel.text = timeString(time: TimeInterval(secondsTimer))
            if secondsTimer > 10800 {
                timer.invalidate()
                endBackgroundTask()
            }
            secondsTimer += 1
            if secondsTimer == 1 {
                nextButton.isEnabled = true
            }
            cyrcleShapeStrokeStatus.strokeEnd = CGFloat(startValue * Double(seconds) / 100)
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

    func notificationCentrer() {
        let content = UNMutableNotificationContent()
        content.title = "Break has finished"
        content.subtitle = "NEXT EXERCISE: \(exerciseControllView.titleLabel.text ?? "finish")"
        content.body = "\(exerciseControllView.sets.text ?? "0"), \(exerciseControllView.repsAndweight.text ?? "0")"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "TimerDone", content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: nil)
    }
}

extension TimerViewController {

    fileprivate func makeLabel(label: UILabel, text: String, size: CGFloat ) {
        label.font = UIFont.boldSystemFont(ofSize: size)
        label.adjustsFontSizeToFitWidth = true
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
        setupTitleLabel()
        setupCyrcleStatusView()
        setupExerciseControllView()
    }

    fileprivate  func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 32))
        makeLabel(label: titleLabel, text: "Press Start", size: 32)
    }

    fileprivate func setupCyrcleStatusView() {
        view.addSubview(cyrcleStatusView)
        cyrcleStatusView.anchor(top: titleLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 24, bottom: 0, right: 24))
        cyrcleStatusView.heightAnchor.constraint(lessThanOrEqualTo: cyrcleStatusView.widthAnchor, multiplier: 1).isActive = true
        cyrcleStatusView.addSubview(breakLabel)
        breakLabel.anchor(top: cyrcleStatusView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 28, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        breakLabel.centerXAnchor.constraint(equalTo: cyrcleStatusView.centerXAnchor).isActive = true
        makeLabel(label: breakLabel, text: "WORK", size: 30)
        cyrcleStatusView.addSubview(singleTimerLabel)
        singleTimerLabel.anchor(top: breakLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        singleTimerLabel.centerXAnchor.constraint(equalTo: cyrcleStatusView.centerXAnchor).isActive = true
        makeLabel(label: singleTimerLabel, text: "", size: 30)
        cyrcleStatusView.addSubview(allTimerLabel)
        allTimerLabel.anchor(top: nil, leading: nil, bottom: cyrcleStatusView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 40, right: 0))
        allTimerLabel.centerXAnchor.constraint(equalTo: cyrcleStatusView.centerXAnchor).isActive = true
        makeLabel(label: allTimerLabel, text: "00:00:00", size: 36)
        cyrcleStatusView.addSubview(allProgramLabel)
        allProgramLabel.anchor(top: nil, leading: nil, bottom: allTimerLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        allProgramLabel.centerXAnchor.constraint(equalTo: cyrcleStatusView.centerXAnchor).isActive = true
        makeLabel(label: allProgramLabel, text: "Full Program", size: 30)
    }

    fileprivate func setupExerciseControllView() {
        view.addSubview(exerciseControllView)
        exerciseControllView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 8, right: 8), size: CGSize(width: 0, height: 200))
        startButton = exerciseControllView.startButton
        nextButton = exerciseControllView.nextButton
        nextButton.isEnabled = false
        resetButton = exerciseControllView.stopButton
        startButton.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(handleStopButton), for: .touchUpInside)
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
