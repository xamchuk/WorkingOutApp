//
//  WorckingOutTableTableViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

protocol PassDataFromTableControllerToTabBar: AnyObject {
    func passingProgram(program: [Item])
}

class WorckingOutTableTableViewController: UIViewController {

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var exercises: [Item] = []  {
        didSet {
            delegate?.passingProgram(program: exercises)
            if exercises.count > 0 {
                tableLabel.isHidden = true
                navigationItem.title = "\(exercises.count) exercises for today"
            } else {
                navigationItem.title = "Lets's start with ADD"
                tableLabel.isHidden = false
            }
        }
    }

    var items: [ItemJ] = []
    let cellId = "cellId"
    let tableView = UITableView()
    var cells: [WorkingOutProgrammCell]?

    let tableLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new exercises"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()

    weak var delegate: PassDataFromTableControllerToTabBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            exercises = try context.fetch(Item.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        view.backgroundColor = .white
        setupTableView()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handeleAddButton))
        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handeleAddButton))
        createButton.image = UIImage(named: <#T##String#>)
        navigationItem.rightBarButtonItem = addButton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }

    fileprivate func setupTableView() {
        view.addSubview(tableView)
        view.addSubview(tableLabel)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .gray
        tableLabel.centerInSuperview()
        tableView.dataSource = self
        tableView.register(WorkingOutProgrammCell.self, forCellReuseIdentifier: cellId)
    }
   
    @objc func handeleAddButton(_ sender: UIBarButtonItem) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let addNewExCollectionViewController = AddNewExCollectionViewController(collectionViewLayout: layout)
        addNewExCollectionViewController.delegate = self
        show(addNewExCollectionViewController, sender: true)
    }
}

extension WorckingOutTableTableViewController: UITableViewDataSource {

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WorkingOutProgrammCell
        cell.delegate = self
        cell.item = exercises[indexPath.row]
        cells?.append(cell)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(exercises[indexPath.row])
            exercises.remove(at: indexPath.row)
            appDelegate.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


extension WorckingOutTableTableViewController : DidSetSecondsFromCellToTableController {
    func passingSeconds(seconds: Double, item: Item) {
       for i in exercises {
            if i.name == item.name {
                guard let index = exercises.index(of: i) else { return }
                exercises[index] = item
                break
            }
        }
    }
}

extension WorckingOutTableTableViewController: SelectedItemFromCollectionView {
    func appendingItem(item: ItemJ) {
        let exer = Item(entity: Item.entity(), insertInto: context)
        exer.name = item.name
        exer.imageName = item.imageName
        exer.amount = Int16(item.amount)
        exer.rounds = Int16(item.rounds)
        exer.weight = item.weight ?? 0.00
        exer.descriptions = item.description
        exer.videoString = item.videoString
        exer.group = item.group
        exercises.append(exer)
        appDelegate.saveContext()
        tableView.reloadData()
    }
}
