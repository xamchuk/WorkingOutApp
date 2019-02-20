//
//  Exercise+UIView.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

extension ExerciseViewController {

     func setupNavigationController() {
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleBackButton))
        doneButton.tintColor = .white
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEditButton))
        editButton.tintColor = .white
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = editButton

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .white
    }

     func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.fillSuperview()

        tableView.register(ExerciseCell.self, forCellReuseIdentifier: cellId)

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 50))

        tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = tableFooterView

        setupHeaderView()
        setupAddButtonOfFooter()
    }

    func setupHeaderView() {
        let headerView = UIView()
        headerView.layer.cornerRadius = 10
        
        tableHeaderView.addSubview(headerView)
        headerView.anchor(top: tableHeaderView.topAnchor, leading: tableHeaderView.leadingAnchor, bottom: tableHeaderView.bottomAnchor, trailing: tableHeaderView.trailingAnchor, padding: .init(top: 4, left: 4, bottom: 4, right: 4))
        headerView.addSubview(headerTittleLabel)

        let style = UIFont.TextStyle.body
        headerTittleLabel.font = UIFont.preferredFont(forTextStyle: style)
        headerTittleLabel.adjustsFontSizeToFitWidth = true
        headerTittleLabel.layer.masksToBounds = true
        headerTittleLabel.textColor = .white
        headerTittleLabel.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 4, bottom: 0, right: 0))

        headerView.addSubview(startButton)
        startButton.layer.cornerRadius = 10
        startButton.backgroundColor = .mainLight
        startButton.setTitle(" Start Workout ", for: .normal)
        startButton.setTitleColor(.gray, for: .disabled)
        startButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        startButton.setTitleColor(.white, for: .normal)
        startButton.addTarget(self, action: #selector(handleStartButtonAction), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.centerYAnchor.constraint(equalTo: headerTittleLabel.centerYAnchor)])
        let trailingA = startButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -4)
        trailingA.priority = .defaultLow
        trailingA.isActive = true
    }

     func setupAddButtonOfFooter() {
        tableFooterView.addSubview(addButton)
        addButton.backgroundColor = .blackColor
        addButton.layer.cornerRadius = tableFooterView.frame.height / 4
        addButton.setTitle("✚", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.setTitleColor(.gray, for: .disabled)
        let style = UIFont.TextStyle.largeTitle
        addButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: style)
        addButton.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        addButton.centerInSuperview()
        addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
    }
}
