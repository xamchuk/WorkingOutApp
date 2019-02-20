//
//  ExerciseViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import CoreData

class ExerciseViewController: UIViewController {

    var coreDataStack: CoreDataStack!
    var fetchedRC: NSFetchedResultsController<Item>!
    var workout: Workouts!
    var items: [Exercise] = []
    let cellId = "cellId"
    var tableView = UITableView()
    var tableHeaderView = UIView()
    var tableFooterView = UIView()
    let headerTittleLabel = UILabel()
    let startButton = UIButton(type: .system)
    let addButton = UIButton(type: .system)
    var doneButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setBackgroudView()
        setupNavigationController()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchedRC.delegate = self
    }

    @objc func handleStartButtonAction() {
        let timerModel = TimerModel()
        timerModel.workout = workout
        timerModel.coreDataStack = coreDataStack
        let timerVC = TimerViewController()
        timerVC.timerModel = timerModel
        present(timerVC, animated: true, completion: nil)
    }

    @objc func handleAddButton() {
        let addNewExCollectionViewController = AddNewExCollectionViewController()
        addNewExCollectionViewController.delegate = self
        let navController = UINavigationController(rootViewController: addNewExCollectionViewController)
        present(navController, animated: true, completion: nil)
    }

    @objc func handleEditButton() {
        tableView.isEditing = !tableView.isEditing
        startButton.isEnabled = !tableView.isEditing
        addButton.isEnabled = !tableView.isEditing
        doneButton.isEnabled = !tableView.isEditing
    }

    func setupFetchRC() {
        let request = Item.fetchRequest() as NSFetchRequest<Item>
        if workout != nil {
            request.predicate = NSPredicate(format: "owner = %@", workout)
            let sort = NSSortDescriptor(key: #keyPath(Item.index), ascending: true)
            request.sortDescriptors = [sort]
            do {
                fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
                fetchedRC.delegate = self
                try fetchedRC.performFetch()
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        refreshHeaderAndButtons()
    }

    @objc func handleBackButton() {
        dismiss(animated: true)
    }

    func refreshHeaderAndButtons() {
        if fetchedRC != nil {
            if fetchedRC.fetchedObjects?.count == 0 {
                startButton.isEnabled = false
                headerTittleLabel.text = "Add new exercises"

            } else {
                startButton.isEnabled = true
                headerTittleLabel.text = "You have \(fetchedRC.fetchedObjects?.count ?? 0 ) exercise(s)"
            }
        }
    }
}

extension ExerciseViewController: SelectedItemFromCollectionView {
    func appendingItem(item: Exercise) {
        guard let fetchedRC = fetchedRC.fetchedObjects else { return }
        let itemExist = fetchedRC.contains { $0.name == item.name}
        if !itemExist {
            let exer = Item(entity: Item.entity(), insertInto: coreDataStack.viewContext)
            exer.name = item.name
            exer.imageURL = item.imageName
            exer.imageData = item.imageData as NSData?
            exer.descriptions = item.description
            exer.videoString = item.videoString
            exer.index = Int16(fetchedRC.count)
            exer.group = item.group
            exer.owner = workout
            for _ in 0...2 {
                let set = Sets(entity: Sets.entity(), insertInto: coreDataStack.viewContext)
                set.repeats = 8
                set.weight = 20
                set.date = NSDate()
                set.item = exer
            }
            coreDataStack.saveContext()
        }
    }
}



