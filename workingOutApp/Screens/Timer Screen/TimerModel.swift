//
//  TimerModel.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 07/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import AudioToolbox
import UserNotifications
import CoreData

protocol TimerDelegate: AnyObject {
    func refresh(titleOfExercise: String)
    func refresh(exerice: String, sets: String, reps: String, weight: String)
    func refresh(startButtonTitle: String)
    func refresh(infoTitle: String)
    func refresh(breakTitle: String)
    func refresh(singleSeconds: String)
    func refreshAllSeconds(seconds: Int)
    func refresh(strokeEnd: CGFloat)
    func nextButton(isEnabled: Bool)
}

class TimerModel {
    var coreDataStack: CoreDataStack!
    var workout: Workouts?
    var items: [Item]?
    private var sets: [Sets]?
    private let notificationCenter = UNUserNotificationCenter.current()
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var seconds = 0
    var isBreak = false
    var secondsTimer = 0
    var startValue = 100.00
    var startSeconds = 0
    var isRunning = false
    var timer = Timer()
    var indexOfExercise = 0
    var indexOfSets = 0
    weak var delegate: TimerDelegate?

    func refreshExercises() {
        let requestExercise = Item.fetchRequest() as NSFetchRequest<Item>
        guard let workout = workout else { return }
        requestExercise.predicate = NSPredicate(format: "owner= %@", workout)
        let sortExercise = NSSortDescriptor(key: #keyPath(Item.index), ascending: true)
        requestExercise.sortDescriptors = [sortExercise]
        do {
            items = try coreDataStack.viewContext.fetch(requestExercise)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if items?.count == 0 {
            return
        } else {
            switchNextExerciseOrSet()
        }
    }

    func refreshSetsAt(exerciseIndex: Int) {
        let requestSets = Sets.fetchRequest() as NSFetchRequest<Sets>
        guard let items = items else { return }
        requestSets.predicate = NSPredicate(format: "item = %@", items[exerciseIndex])
        let sortSets = NSSortDescriptor(key: #keyPath(Sets.date), ascending: true)
        requestSets.sortDescriptors = [sortSets]
        do {
            sets = try coreDataStack.viewContext.fetch(requestSets)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func switchNextExerciseOrSet() {
        guard let items = items else { return }
        if indexOfExercise < items.count {
            let item = items[indexOfExercise]
            delegate?.refresh(titleOfExercise: item.name)
            refreshSetsAt(exerciseIndex: indexOfExercise)
            guard let sets = sets else { return }
            if indexOfSets < sets.count {
                delegate?.refresh(exerice: "\(indexOfExercise + 1 )/\(items.count)", sets: "\(indexOfSets + 1)/ \(item.sets?.count ?? 0)", reps: "\(sets[indexOfSets].repeats)", weight: "\(sets[indexOfSets].weight)")
            } else {
                indexOfSets = 0
                indexOfExercise += 1
                switchNextExerciseOrSet()
            }
        } else {
           // delegate?.refresh(title: "Training completed", startButtonTitle: "Done")
            timer.invalidate()
        }
    }

    func notificationCentrer() {
        let content = UNMutableNotificationContent()
        guard let items = items else { return }
        if indexOfExercise < items.count {
        let item = items[indexOfExercise]
        guard let sets = sets else { return }
        content.title = "Break has finished"
        content.subtitle = "Current exercise: \(item.name)"
        content.body = "Sets: \(indexOfSets + 1) / \(item.sets?.count ?? 0) Reps: \(sets[indexOfSets].repeats) Weight: \(sets[indexOfSets].weight)"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "TimerDone", content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: nil)
        }
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

    @objc func updateTimer() {
        if secondsTimer >= 0 {
            if seconds == 1 && !isBreak {
                notificationCentrer()
                delegate?.refresh(breakTitle: "WORK")
                delegate?.refresh(infoTitle: "Finish your set and press next")
                delegate?.refresh(singleSeconds: "")
                delegate?.nextButton(isEnabled: true)
            } else  if seconds == 0 && isBreak {
                delegate?.refresh(breakTitle: "REST")
                delegate?.refresh(infoTitle: "Prepeare for next set, your braek will finish in:")
                seconds = 60
                isBreak = false
                startValue = 100 / Double(seconds)
            }

            if seconds > 0 {
                seconds -= 1
                delegate?.refresh(singleSeconds: "\(seconds)")
                let strokeEnd = CGFloat(startValue * Double(seconds - 1) / 100)
                delegate?.refresh(strokeEnd: strokeEnd)
                if seconds == 0 {
                        AudioServicesPlayAlertSound(1304)
                }
            }
            if seconds == 0 {
                delegate?.refresh(singleSeconds: "")
            }
            delegate?.refreshAllSeconds(seconds: secondsTimer)
            if secondsTimer > 10800 {
                timer.invalidate()
                endBackgroundTask()
            }
            secondsTimer += 1
            if secondsTimer == 1 {
                delegate?.nextButton(isEnabled: true)
            }
        } else {
            timer.invalidate()
            delegate?.refresh(startButtonTitle: "Start")
            delegate?.refresh(infoTitle: "Training completed")
            isRunning = false
            AudioServicesPlayAlertSound(1304)
        }
    }

    func handleStartButton() {
        if !isRunning || secondsTimer == 0 {
            isRunning = true
            registerBackgroundTask()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
            delegate?.refresh(startButtonTitle: "Pause")
            if indexOfSets == 0 {
                delegate?.refresh(infoTitle: "Do your first set, then press next")
            } else {
                delegate?.refresh(infoTitle: "Finish your set and press next")
            }

        } else if secondsTimer > 0 {
            timer.invalidate()
            isRunning = false
            endBackgroundTask()
            delegate?.refresh(infoTitle: "Press Resume")
            delegate?.refresh(startButtonTitle: "Resume")
        }
    }
}
