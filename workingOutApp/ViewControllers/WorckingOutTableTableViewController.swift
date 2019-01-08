//
//  WorckingOutTableTableViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit



class WorckingOutTableTableViewController: UIViewController {

    var items: [Item] = []

    let cellId = "cellId"
    let tableView = UITableView()

    weak var delegate: PassDataFromTableControllerToTabBar?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupTableView()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Make your excerice list"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handeleAddButton))
    }

    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
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

    override func viewWillDisappear(_ animated: Bool) {

    }
}

extension WorckingOutTableTableViewController: UITableViewDataSource {

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // guard let itemsNotNil = items else { return 0}
        return items.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WorkingOutProgrammCell
        cell.delegate = self
        //if let itemsNotNil = items {
        cell.item = items[indexPath.row]

        return cell
    }
}

extension WorckingOutTableTableViewController : DidSetSecondsFromCellToTableController {
    func passingSeconds(seconds: Double) {
        delegate?.passingSeconds(seconds: seconds)
    }
}
extension WorckingOutTableTableViewController: SelectedItemFromCollectionView {
    func appendingItem(item: Item) {
        items.append(item)
        tableView.reloadData()
        
    }


}
