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

    var items: [Item] = [] {
        didSet {
            delegate?.passingProgram(program: items)
            if items.count > 0 {
                tableLabel.isHidden = true
                navigationItem.title = "\(items.count) exercises for today"
            } else {
                navigationItem.title = "Lets's start with ADD"
                tableLabel.isHidden = false
            }
        }
    }
    
//    var program: [Item] = [] {
//        didSet {
//            delegate?.passingProgram(program: program)
//        }
//    }
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

        view.backgroundColor = .white
        setupTableView()


        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handeleAddButton))
        navigationItem.rightBarButtonItem = addButton

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
        return items.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WorkingOutProgrammCell
        cell.delegate = self
        cell.item = items[indexPath.row]
        cells?.append(cell)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
//            if program.count > 0 {
//                program.remove(at: indexPath.row)
//            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


extension WorckingOutTableTableViewController : DidSetSecondsFromCellToTableController {
    func passingSeconds(seconds: Double, item: Item) {
       for i in items {
            if i.name == item.name {
                guard let index = items.index(of: i) else { return }
                items[index] = item
                break
            }
        }
    }
}
extension WorckingOutTableTableViewController: SelectedItemFromCollectionView {
    func appendingItem(item: Item) {
        items.append(item)
        tableView.reloadData()
    }
}
