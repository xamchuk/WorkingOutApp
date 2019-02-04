//
//  WorckingOutTableTableViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import CoreData

protocol PassDataFromTableControllerToTabBar: AnyObject {
    func passingProgram(program: [Item])
}

protocol ExerciseCellDelegate: AnyObject {
    func passingViewControllerForSelectedCell(exercise: Item)
    func passingAddNewExerciseAction(vc: UIViewController)
}

class ExerciseCollectionViewCell: UICollectionViewCell {

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Item>!

    var workout: Workouts!
    var items: [ItemJson] = []
    let cellId = "cellId"
    var tableView = UITableView()
    var tableHeaderView = UIView()
    let headerAddButton = UIButton(type: .system)
    var isLoaded = false
    var imageView = UIImageView()
    weak var delegate: PassDataFromTableControllerToTabBar?
    weak var delegateCell: ExerciseCellDelegate?
    var startButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        refreshCoreData()
        setupTableView()
        addSubview(startButton)
        setupStartButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleAddButton() {
        let addNewExCollectionViewController = AddNewExCollectionViewController()
        addNewExCollectionViewController.delegate = self
        delegateCell?.passingAddNewExerciseAction(vc: addNewExCollectionViewController)
    }

    func refreshCoreData() {
        let request = Item.fetchRequest() as NSFetchRequest<Item>
        if workout != nil {
            request.predicate = NSPredicate(format: "owner = %@", workout)
            let sort = NSSortDescriptor(key: #keyPath(Item.index), ascending: true)
            request.sortDescriptors = [sort]
            do {
                fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
                try fetchedRC.performFetch()
                fetchedRC.delegate = self
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        if fetchedRC != nil {
            if fetchedRC.fetchedObjects?.count == 0 {
                startButton.isEnabled = false
            } else {
                startButton.isEnabled = true
            }
        }
        tableView.reloadData()
    }
}

extension ExerciseCollectionViewCell: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let obj = fetchedRC else { return 0 }
        return obj.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ExerciseCell
        cell.selectionStyle = .none
        if fetchedRC != nil {
            cell.item = fetchedRC.object(at: indexPath)
        }
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let exercise = fetchedRC.object(at: indexPath)
            context.delete(exercise)
            appDelegate.saveContext()
        }
    }
}

extension ExerciseCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegateCell?.passingViewControllerForSelectedCell(exercise: fetchedRC.object(at: indexPath))
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .none
        } else {
            return .delete
        }
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        fetchedRC.delegate = nil
        var objects = fetchedRC.fetchedObjects!
        let object = objects[sourceIndexPath.row]
        objects.remove(at: sourceIndexPath.row)
        objects.insert(object, at: destinationIndexPath.row)
        for (index, object) in objects.enumerated() {
            object.index = Int16(index)
        }
        self.appDelegate.saveContext()
        fetchedRC.delegate = self
    }
}

extension ExerciseCollectionViewCell {

    fileprivate func setupTableView() {
        addSubview(tableView)
        tableView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 4, bottom: 68, right: 4))
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 25
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor.linesColor.cgColor
        tableView.layer.borderWidth = 3
        tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        tableView.tableHeaderView = tableHeaderView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExerciseCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .clear
        tableHeaderView.addSubview(headerAddButton)
        setupAddButtonOfHeader()
    }

    fileprivate func setupAddButtonOfHeader() {
        headerAddButton.layer.cornerRadius = 20
        headerAddButton.layer.borderColor = UIColor.linesColor.cgColor
        headerAddButton.layer.borderWidth = 3
        headerAddButton.tintColor = .linesColor
        headerAddButton.backgroundColor = .clear
        headerAddButton.setImage(UIImage(named: "plus"), for: .normal)
        headerAddButton.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        headerAddButton.anchor(top: tableHeaderView.topAnchor, leading: nil, bottom: tableHeaderView.bottomAnchor, trailing: nil, padding: .init(top: 5, left: 0, bottom: 5, right: 0), size: CGSize(width: 40, height: 0))
        headerAddButton.centerXAnchor.constraint(equalTo: tableHeaderView.leadingAnchor, constant: 60).isActive = true
    }

    fileprivate func setupStartButton() {
        startButton.backgroundColor = .clear
        startButton.layer.cornerRadius = tableView.layer.cornerRadius
        startButton.tintColor = .textColor
        startButton.setTitle("Start Workout", for: .normal)
        startButton.layer.borderColor = tableView.layer.borderColor
        startButton.layer.borderWidth = tableView.layer.borderWidth
        startButton.anchor(top: tableView.bottomAnchor, leading: tableView.leadingAnchor, bottom: bottomAnchor, trailing: tableView.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 4, right: 0))
    }
}
extension ExerciseCollectionViewCell: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else {
            return
        }
        switch type {
        case .insert:
            tableView.insertRows(at: [cellIndex], with: .automatic)
        case .delete:
            tableView.reloadData() //deleteRows(at: [cellIndex], with: .automatic)
        default:
            break
        }
    }
}

extension ExerciseCollectionViewCell: SelectedItemFromCollectionView {
    func appendingItem(item: ItemJson) {
        guard let fetchedRC = fetchedRC.fetchedObjects else { return }
        let itemExist = fetchedRC.contains { $0.name == item.name}
        if !itemExist {
            let exer = Item(entity: Item.entity(), insertInto: context)
            exer.name = item.name
            exer.imageURL = item.imageName
            exer.imageData = item.imageData as NSData?
            exer.descriptions = item.description
            exer.videoString = item.videoString
            exer.index = Int16(fetchedRC.count)
            exer.group = item.group
            exer.owner = workout
            for _ in 0...2 {
                let set = Sets(entity: Sets.entity(), insertInto: context)
                set.repeats = 8
                set.weight = 20
                set.date = NSDate()
                set.item = exer
            }
            appDelegate.saveContext()
        }
    }
}
