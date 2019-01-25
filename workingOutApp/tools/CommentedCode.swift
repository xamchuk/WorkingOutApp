//
//  CommentedCode.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 09/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

//import Foundation


//override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//    if UIDevice.current.orientation.isLandscape {
//        portraitHeihtAnchor?.isActive = false
//        landscapeHeihtAnchor = continerView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.86)
//        landscapeHeihtAnchor?.isActive = true
//        stackView.layoutIfNeeded()
//        stackView.setNeedsLayout()
//        stackView.setNeedsDisplay()
//    }
//    if UIDevice.current.orientation.isPortrait {
//        landscapeHeihtAnchor?.isActive = false
//        portraitHeihtAnchor?.isActive = true
//    }
//}
//
// MARK: Custom Exercise Controller

//func createButton(button: UIButton, title: String, action: Selector) {
//    button.backgroundColor = .gray
//    button.layer.cornerRadius = 20
//    button.layer.borderWidth = 2
//    button.layer.borderColor = UIColor.black.cgColor
//    button.setTitle(title, for: .normal)
//    button.addTarget(self, action: action, for: .touchUpInside)
//}

// MARK: Logic for edit button


//func itemsChanges() {
//
//    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handeleAddButton))
//    let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditing))
//
//    if items.count > 0 {
//        tableLabel.isHidden = true
//        navigationItem.title = "\(items.count) exercises for today"
//        navigationItem.setRightBarButtonItems([addButton, editButton], animated: true)
//        // navigationItem.rightBarButtonItems?[1].title = "Edit"
//    } else {
//        tableLabel.isHidden = false
//        navigationItem.title = "Add new exercises"
//        navigationItem.setRightBarButtonItems([addButton], animated: true)
//        tableView.setEditing(false, animated: true)
//    }
//}
//
//@objc private func toggleEditing() {
//    tableView.setEditing(!tableView.isEditing, animated: true) // Set opposite value of current editing status
//    navigationItem.rightBarButtonItems?[1].title = tableView.isEditing ? "Done" : "Edit"
//}

//////////////////////////////////////////////
// MARK: Logik of replacing in array

//        var isMatch = false
//        if program.count == 0 {
//            program.append(item)
//        }
//        for i in program {
//            if i.name == item.name {
//                guard let index = program.index(of: i) else { return }
//                program[index] = item
//                isMatch = true
//                break
//            }
//        }
//        if !isMatch  {
//            program.append(item)
//        }
//    }


////////////////////////////////////////////////

//MARK: Handle touches of timer level

// timerview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:))))

//@objc func handlePan(gesture: UIPanGestureRecognizer) {
//    let translation = gesture.translation(in: gesture.view)
//    let percent = translation.y / timerView.bounds.height
//
//    level = max(0, min(1, shapeLayer.strokeEnd - percent))
//
//    CATransaction.begin()
//    CATransaction.setDisableActions(true)
//    shapeLayer.strokeEnd = level
//    CATransaction.commit()
//
//    gesture.setTranslation(.zero, in: gesture.view)
//}



