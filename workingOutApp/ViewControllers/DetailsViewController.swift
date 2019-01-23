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

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private let cellId = "cell"
    var tableView = UITableView()
    var footerView = UIView()
    var exercise: Item!
    var selectedIndexPath: IndexPath?
    var isSelected = false

    private var fetchedRC: NSFetchedResultsController<Sets>!
    private var query = ""


    let strokeView = UIView()
    let horizontalStroceView = UIView()
    let footerAddButton = UIButton(type: .system)



    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "\(exercise?.name ?? "")"
        view.makeGradients()
        view.addSubview(tableView)
        setupTableView()
        defaultCellData(item: exercise)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    func refreshCoData(item: Item) {
        let request = Sets.fetchRequest() as NSFetchRequest<Sets>
        if query.isEmpty {
            request.predicate = NSPredicate(format: "item = %@", item)
        } else {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@ AND item = %@", query, item)
        }
        let sort = NSSortDescriptor(key: #keyPath(Sets.date), ascending: true)
        request.sortDescriptors = [sort]
        do {
           fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func defaultCellData(item: Item) {
        refreshCoData(item: item)
        guard let sets = fetchedRC.fetchedObjects else { return }
        if sets.count == 0 {
            for _ in 0...2 {
                let set = Sets(entity: Sets.entity(), insertInto: context)
                set.repeats = 8
                set.weight = 20
                set.date = NSDate()
                set.item = item
                appDelegate.saveContext()
                refreshCoData(item: item)
                tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCoData(item: exercise)
    }
    @objc func hendleFooterAddButton() {
        let set = Sets(entity: Sets.entity(), insertInto: context)
        set.repeats = 8
        set.weight = 80.5
        set.date = NSDate()
        set.item = exercise
        appDelegate.saveContext()
        refreshCoData(item: exercise)
        tableView.reloadData()
    }
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sets = fetchedRC.fetchedObjects else { return 0 }
        return sets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DetailTableViewCell
        cell.selectionStyle = .none
        cell.numberLabel.text = "\(indexPath.row + 1)"
        cell.set = fetchedRC.object(at: indexPath)
       
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let set = fetchedRC.object(at: indexPath)
            context.delete(set)
            appDelegate.saveContext()
            refreshCoData(item: exercise)
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DetailTableViewCell
        let oldIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }

        var indexPaths: [IndexPath] = []
        if let old = oldIndexPath {
            indexPaths += [old]
            cell.pickerView.isHidden = true
            (tableView.cellForRow(at: old) as! DetailTableViewCell).pickerView.isHidden = true
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
            cell.pickerView.isHidden = false
        }
        if indexPaths.count > 0 {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
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
        return 100
    }
}
extension DetailsViewController {

    fileprivate func setupTableView() {
        footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 55))
        tableView.fillSuperview()
        tableView.backgroundColor = .clear
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.tableFooterView = footerView
        tableView.dataSource = self
        tableView.delegate = self


        footerView.addSubview(horizontalStroceView)
        setupFooterHorizontalView()

        footerView.addSubview(strokeView)
        setupFooterVerticalStroke()

        footerView.addSubview(footerAddButton)
        setUpButtonOfFooter()
    }

    fileprivate func setupFooterHorizontalView() {
        horizontalStroceView.layer.borderColor = UIColor.linesColor.cgColor
        horizontalStroceView.layer.borderWidth = 1
        horizontalStroceView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStroceView.layer.cornerRadius = 1
        horizontalStroceView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        NSLayoutConstraint.activate([
            horizontalStroceView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 0),
            horizontalStroceView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 30),
            horizontalStroceView.trailingAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0),
            horizontalStroceView.heightAnchor.constraint(equalToConstant: 2)])
    }

    fileprivate func setupFooterVerticalStroke() {
        strokeView.layer.borderColor = UIColor.linesColor.cgColor
        strokeView.layer.borderWidth = 1
        strokeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            strokeView.topAnchor.constraint(equalTo: horizontalStroceView.bottomAnchor),
            strokeView.trailingAnchor.constraint(equalTo: horizontalStroceView.trailingAnchor),
            strokeView.widthAnchor.constraint(equalToConstant: 2),
            strokeView.heightAnchor.constraint(equalToConstant: 15)])
    }


    fileprivate func setUpButtonOfFooter() {
        footerAddButton.layer.cornerRadius = 20
        footerAddButton.layer.borderColor = UIColor.linesColor.cgColor
        footerAddButton.layer.borderWidth = 2
        footerAddButton.tintColor = .linesColor
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

