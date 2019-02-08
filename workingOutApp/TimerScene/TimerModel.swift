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

protocol TimerDelegate: AnyObject {
    func refreshTimer(seconds: Int)
}
class TimerModel {

    private let notificationCenter = UNUserNotificationCenter.current()
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    
    var startValueOfAllTraining = 0.00
    var seconds = 0
    var isBreak = false
    var secondsTimer = 0
    var startValue = 100.00
    var startSeconds = 0
    var isRunning = false
    var timer = Timer()
    
    weak var delegate: TimerDelegate?

    var notificationSubTitle = ""
    var notificationBodyLeft = ""
    var notificationBodyRight = ""

    func notificationCentrer() {
        let content = UNMutableNotificationContent()
        content.title = "Break has finished"
        content.subtitle = "NEXT EXERCISE: \(notificationSubTitle)"
        content.body = "\(notificationBodyLeft), \(notificationBodyRight)"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "TimerDone", content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: nil)
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
                AudioServicesPlayAlertSound(1304)
            } else  if seconds == 0 && isBreak {
                seconds = 60
                isBreak = false
                startValue = 100 / Double(seconds)
            }
            if seconds > 0 {
                seconds -= 1
            }
            if seconds == 0 {

            } else {
                
            }
            print(secondsTimer)
            if secondsTimer > 10800 {
                timer.invalidate()
                endBackgroundTask()
            }
            secondsTimer += 1
            if secondsTimer == 1 {

               // nextButton.isEnabled = true
            }
            _ = (startValue * Double(seconds) / 100)
        } else {
            timer.invalidate()
            print("Start")
            isRunning = false
            AudioServicesPlayAlertSound(1304)
        }
        delegate?.refreshTimer(seconds: secondsTimer)
        
    }

    func handleStartButton(button: UIButton, label: UILabel) {
        if !isRunning || secondsTimer == 0 {
            isRunning = true
            registerBackgroundTask()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
            button.setTitle("Pause", for: .normal)
            label.text = "Do your first set, then press next"
        } else if secondsTimer > 0 {
            timer.invalidate()
            isRunning = false
            endBackgroundTask()
            button.setTitle("Resume", for: .normal)
        }
    }
}
