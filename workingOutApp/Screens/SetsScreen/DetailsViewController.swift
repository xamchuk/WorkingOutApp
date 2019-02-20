//
//  DetailsViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {

    var coreDataStack: CoreDataStack!
    private let cellId = "cell"
    var tableView = UITableView()
    var footerView = UIView()
    var exercise: Item!
    var selectedIndexPath: IndexPath?
    var isSelected = false
    var section = 0
    private var fetchedRC: NSFetchedResultsController<Sets>!
    private var query = ""
    let strokeView = UIView()
    let footerAddButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setBackgroudView()
        setupNavigationController()
        setupTableView()
        defaultCellData(item: exercise)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    func refreshCoData() {
        let request = Sets.fetchRequest() as NSFetchRequest<Sets>
        if query.isEmpty {
            request.predicate = NSPredicate(format: "item = %@", exercise)
        } else {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@ AND item = %@", query, exercise)
        }
        let sort = NSSortDescriptor(key: #keyPath(Sets.date), ascending: true)
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func defaultCellData(item: Item) {
        refreshCoData()
        guard let sets = fetchedRC.fetchedObjects else { return }
        if sets.isEmpty {
            for _ in 0...1 {
                let set = Sets(entity: Sets.entity(), insertInto: coreDataStack.viewContext)
                set.repeats = 8
                set.weight = 20
                set.date = NSDate()
                set.item = exercise
                coreDataStack.saveContext()
                refreshCoData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCoData()
    }

    @objc func hendleFooterAddButton() {
        guard let setsForIndex = fetchedRC.fetchedObjects else { return }
        guard let lastIndex = setsForIndex.indices.last else { return }
        let set = Sets(entity: Sets.entity(), insertInto: coreDataStack.viewContext)
        set.repeats = setsForIndex[lastIndex].repeats
        set.weight = setsForIndex[lastIndex].weight
        set.date = NSDate()
        set.item = exercise
        coreDataStack.saveContext()
        refreshCoData()
        guard let sets = fetchedRC.fetchedObjects else { return }
        tableView.insertRows(at: [IndexPath(row: sets.count - 1, section: 0)], with: .middle)
    }
}

extension DetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sets = fetchedRC.fetchedObjects else { return 0 }
        return sets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DetailTableViewCell
        cell.coreDataStack = coreDataStack
        cell.delegate = self
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        cell.numberLabel.text = "\(indexPath.row + 1)"
        cell.set = fetchedRC.object(at: indexPath)
        cell.layoutIfNeeded()
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .default, title: "Delete") {
            (delete, indexPath) in
            self.selectedIndexPath = nil
            let set = self.fetchedRC.object(at: indexPath)
            self.coreDataStack.viewContext.delete(set)
            self.coreDataStack.saveContext()
            self.refreshCoData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        action.backgroundColor = UIColor.mainDark
        return [action]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
        let oldIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        if let old = oldIndexPath {
        (tableView.cellForRow(at: old) as! DetailTableViewCell).pickerStackView.isHidden = true
        (tableView.cellForRow(at: old) as! DetailTableViewCell).editImageView.tintColor = .white
        }
        if selectedIndexPath != nil {
            selectedCell.pickerStackView.isHidden = false
            selectedCell.editImageView.tintColor = .mainDark
        }
        tableView.beginUpdates()
        tableView.layoutIfNeeded()
        tableView.endUpdates()
    }
}

extension DetailsViewController: DetailCellDelegate {
    func cellDidChanched(set: Sets, indexPath: IndexPath) {
        var indexRow = indexPath.row
        guard let sets = fetchedRC.fetchedObjects else { return }
        for i in sets {
            if sets.index(ofElement: i) > indexRow {
                indexRow += 1
                sets[indexRow].repeats = set.repeats
                sets[indexRow].weight = set.weight
            }
        }
        coreDataStack.saveContext()
        refreshCoData()
        tableView.reloadData()
    }
}

extension DetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return 180
        }
        return 90
    }
}

extension DetailsViewController {


    fileprivate func setupNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "\(exercise?.name ?? "")"
    }

    fileprivate func setupTableView() {
        view.addSubview(tableView)
        footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 55))
        tableView.fillSuperview()
        tableView.backgroundColor = .clear
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.tableFooterView = footerView
        tableView.dataSource = self
        tableView.delegate = self
        footerView.addSubview(strokeView)
        setupFooterVerticalStroke()
        footerView.addSubview(footerAddButton)
        setUpButtonOfFooter()
    }

    fileprivate func setupFooterVerticalStroke() {
        strokeView.layer.borderColor = UIColor.white.cgColor
        strokeView.layer.borderWidth = 1
        strokeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            strokeView.topAnchor.constraint(equalTo: footerView.topAnchor),
            strokeView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            strokeView.widthAnchor.constraint(equalToConstant: 2),
            strokeView.heightAnchor.constraint(equalToConstant: 15)])
    }

    fileprivate func setUpButtonOfFooter() {
        footerAddButton.layer.cornerRadius = 20
        footerAddButton.layer.borderColor = UIColor.white.cgColor
        footerAddButton.layer.borderWidth = 2
        footerAddButton.tintColor = .white
        footerAddButton.backgroundColor = .clear
        footerAddButton.setImage(UIImage(named: "plus"), for: .normal)
        footerAddButton.addTarget(self, action: #selector(hendleFooterAddButton), for: .touchUpInside)
        footerAddButton.translatesAutoresizingMaskIntoConstraints = false
        footerAddButton.topAnchor.constraint(equalTo: strokeView.bottomAnchor).isActive = true
        footerAddButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
        footerAddButton.centerXAnchor.constraint(equalTo: strokeView.centerXAnchor).isActive = true
        footerAddButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

