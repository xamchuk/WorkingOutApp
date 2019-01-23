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

class ExerciseTableViewController: UIViewController {

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Item>!

    var items: [ItemJson] = []
    let cellId = "cellId"
    let tableView = UITableView()
    let tableLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new exercises"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .textColor
        return label
    }()

    var isLoaded = false
    var imageView = UIImageView()
    weak var delegate: PassDataFromTableControllerToTabBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationController()


        if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray,let
            tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
            tabBarItem.isEnabled = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshCoreData()
        tableView.reloadData()
        refreshTableLable()
    }

    func refreshCoreData() {
        let request = Item.fetchRequest() as NSFetchRequest<Item>
 //       MARK: Filtering coreData
        let query = ""
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        }
        let sort = NSSortDescriptor(key: #keyPath(Item.group), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
            fetchedRC.delegate = self

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func refreshTableLable() {
        guard let obj = fetchedRC.fetchedObjects else { return }
        if obj.count > 0 {
            tableLabel.isHidden = true
            navigationItem.title = "\(obj.count) exercises for today"
            if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray,let
                tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
                tabBarItem.isEnabled = true
            }
        } else {
            navigationItem.title = "Lets's start with ADD"
            tableLabel.isHidden = false
            if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray,let
                tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
                tabBarItem.isEnabled = false
            }
        }
    }

    @objc func handeleAddButton() {
        let addNewExCollectionViewController = AddNewExCollectionViewController()
        addNewExCollectionViewController.delegate = self
        
        let navController = UINavigationController(rootViewController: addNewExCollectionViewController)
        present(navController, animated: true, completion: nil)
    }
}

extension ExerciseTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let obj = fetchedRC.fetchedObjects else { return 0 }
        return obj.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ExerciseCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.item = fetchedRC.object(at: indexPath)
        
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

extension ExerciseTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.exercise = fetchedRC.object(at: indexPath)
        show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}

extension ExerciseTableViewController {

    fileprivate func setupTableView() {
        view.makeGradients()
        view.addSubview(tableView)
        view.addSubview(tableLabel)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        tableView.separatorStyle = .none
        tableLabel.centerInSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExerciseCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .clear
    }

    fileprivate func setupNavigationController() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handeleAddButton))
        navigationItem.setRightBarButton(addButton, animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .textColor
        let backItem = UIBarButtonItem()
        backItem.tintColor = .textColor
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.barTintColor = .gradientDarker
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textColor]
    }
}
extension ExerciseTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        refreshTableLable()

        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else {
            return
        }
        switch type {
        case .insert:
            tableView.insertRows(at: [cellIndex], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [cellIndex], with: .automatic)
        default:
            break
        }
    }
}

extension ExerciseTableViewController: ExerciseCellDelegate {
    func passingSeconds(item: Item) {
        guard let obj = fetchedRC.fetchedObjects else { return }
        var array = obj
        for i in array {
            if i.name == item.name {
                guard let index = array.index(of: i) else { return }
                array[index] = item
                break
            }
        }
    }
}

extension ExerciseTableViewController: SelectedItemFromCollectionView {
    func appendingItem(item: ItemJson) {
        var isHere = false
        guard let obj = fetchedRC.fetchedObjects else { return }
        for i in obj {
            if i.name == item.name{
                isHere = true
            }
        }
        if isHere == false {
            let exer = Item(entity: Item.entity(), insertInto: context)
            exer.name = item.name
            exer.imageURL = item.imageName
            exer.imageName = item.imageLocalName
            exer.descriptions = item.description
            exer.videoString = item.videoString
            exer.group = item.group
            let vc = DetailsViewController()
            vc.defaultCellData(item: exer)
            appDelegate.saveContext()
        }
    }
}
